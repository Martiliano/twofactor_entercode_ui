import 'package:flutter/material.dart';

import 'package:twofactor_insertcode_ui/twofactor_theme.dart';

class TwoFactorCodeScreen extends StatefulWidget {
  const TwoFactorCodeScreen({Key? key}) : super(key: key);

  @override
  State<TwoFactorCodeScreen> createState() => _TwoFactorCodeScreenState();
}

class _TwoFactorCodeScreenState extends State<TwoFactorCodeScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _textNode = FocusNode();

  bool showProgressBar = true;
  double barInGradient = 0.0;
  double barInWhite = 6.0;
  double barNumberOfParts = 6.0;

  String code = '';
  bool isKeyboardShow = false;
  bool codeIsInserted = false;
  bool codeIsValid = false;

  @override
  void initState() {
    super.initState();
    code = '';
    isKeyboardShow = false;
    codeIsInserted = false;
  }

  List<Widget> getField() {
    final List<Widget> result = <Widget>[];

    for (int i = 1; i <= 6; i++) {
      result.add(Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: TwoFactorTheme.topContainerGradientSecondColor,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: code.isEmpty || code.length < i
                  ? const Text(
                      '5',
                      style: TextStyle(
                        color: Colors.transparent,
                        fontSize: 40,
                      ),
                    )
                  : Text(
                      code[i - 1],
                      style: const TextStyle(
                        color: TwoFactorTheme.loginTextColor,
                        fontSize: 40,
                      ),
                    ),
            ),
          ],
        ),
      ));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    var sizeOfDevice = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Insert Two Factor Code"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                TwoFactorTheme.topContainerGradientFirstColor,
                TwoFactorTheme.topContainerGradientSecondColor,
              ],
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          if (isKeyboardShow) {
            _textNode.unfocus();
          } else {
            _textNode.requestFocus();
          }
          isKeyboardShow = !isKeyboardShow;
        },
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              if (showProgressBar)
                Row(
                  children: [
                    Container(
                      height: 10,
                      width: (sizeOfDevice.width / barNumberOfParts) *
                          barInGradient,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            TwoFactorTheme.topContainerGradientFirstColor,
                            TwoFactorTheme.topContainerGradientSecondColor,
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 10,
                      width:
                          (sizeOfDevice.width / barNumberOfParts) * barInWhite,
                      decoration: const BoxDecoration(color: Colors.white),
                    ),
                  ],
                ),
              const SizedBox(
                height: 50,
              ),
              Center(
                child: Image.asset(
                  'public/images/marca.png',
                  width: sizeOfDevice.width * 0.3,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                    'Digite o codigo de verificação que enviamos lhe enviamos.'),
              ),
              SizedBox(
                height: 75,
                width: sizeOfDevice.width,
                child: Stack(
                  children: [
                    Opacity(
                      opacity: 0.0,
                      child: TextFormField(
                        controller: _controller,
                        focusNode: _textNode,
                        keyboardType: TextInputType.number,
                        onChanged: (val) async {
                          code = val;

                          barInGradient = code.length.toDouble();
                          barInWhite = 6.0 - code.length.toDouble();

                          if (code.length > 5) {
                            FocusScope.of(context).unfocus();
                            await Future.delayed(
                                const Duration(milliseconds: 200), () {});

                            if (code == '123456') {
                              setState(() {
                                codeIsValid = true;
                                codeIsInserted = true;
                              });
                            } else {
                              setState(() {
                                codeIsValid = false;
                                codeIsInserted = true;
                              });
                            }

                            if (codeIsValid) {
                              final snackBar = SnackBar(
                                duration: Duration(seconds: 2),
                                elevation: 5,
                                dismissDirection: DismissDirection.startToEnd,
                                content: Text(
                                  'Código Validado com Sucesso !',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                backgroundColor: TwoFactorTheme
                                    .topContainerGradientFirstColor,
                              );

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              final snackBar = SnackBar(
                                duration: Duration(seconds: 2),
                                elevation: 5,
                                dismissDirection: DismissDirection.startToEnd,
                                content: Text(
                                  'Erro na Validação do Código !',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                backgroundColor: Colors.redAccent,
                              );

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          } else {
                            setState(() {
                              codeIsInserted = false;
                            });
                          }
                        },
                        maxLength: 6,
                      ),
                    ),
                    Positioned(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: getField(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(60.0, 20.0, 60.0, 0.0),
                child: ElevatedButton(
                  onPressed: !codeIsInserted || !codeIsValid
                      ? null
                      : () async {
                          FocusScope.of(context).unfocus();
                          await Future.delayed(
                              const Duration(milliseconds: 100), () {});

                          if (codeIsValid) {
                            // Call next screen
                          }
                        },
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text('CONTINUAR',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              )),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        size: 16,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: TwoFactorTheme.topContainerGradientSecondColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
