import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          title: Text("Entrar"),
          centerTitle: true,
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Criar conta",
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
              textColor: Colors.white,
              onPressed: (){
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignupScreen())
                );
              },
            )
          ],
        ),
        body: ScopedModelDescendant<UserModel>(
            builder: (context, child, model){
              if(model.isLoading)
                return Center(child: CircularProgressIndicator(),);

              return Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(16.0),
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          hintText: "E-mail"
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (text){
                        if(text.isEmpty || !text.contains("@")) return "E-mail inválido";
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _passController,
                      decoration: InputDecoration(
                          hintText: "Senha"
                      ),
                      obscureText: true,
                      validator: (text){
                        if(text.isEmpty || text.length < 6) return "Senha invalida";
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        onPressed: (){
                          if(_emailController.text.isEmpty)
                            _scaffoldkey.currentState.showSnackBar(
                                SnackBar(content: Text('Insira seu e-mail para recuperação!'),
                                  backgroundColor: Colors.redAccent,
                                  duration: Duration(seconds: 2),
                                )
                            );
                          else{
                            model.recoverPass(_emailController.text);
                            _scaffoldkey.currentState.showSnackBar(
                                SnackBar(content: Text('Confira seu e-mail!'),
                                  backgroundColor: Theme.of(context).primaryColor,
                                  duration: Duration(seconds: 2),
                                )
                            );
                          }
                        },
                        child: Text(
                          "Esqueci minha senha",
                          textAlign: TextAlign.right,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    SizedBox(height: 16.0,),
                    SizedBox(
                      height: 44.0,
                      child: RaisedButton(
                          onPressed: (){
                            if(_formKey.currentState.validate()){
                            }

                            model.signIn(
                                email: _emailController.text,
                                pass: _passController.text,
                                onSuccess: _onSuccess,
                                onFail: _onFail
                            );
                          },
                          child: Text(
                            "Entrar",
                            style: TextStyle(
                                fontSize: 18.0
                            ),
                          ),
                          textColor: Colors.white,
                          color: Theme.of(context).primaryColor
                      ),
                    )
                  ],
                ),
              );
            }
        )
    );
  }

  void _onSuccess(){
    Navigator.of(context).pop();
  }

  void _onFail(){
    _scaffoldkey.currentState.showSnackBar(
        SnackBar(content: Text('Falha ao entrar!'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );
  }
}


