import 'package:ecommerce_app/Screens/Register_page.dart';
import 'package:ecommerce_app/Widgets/Custom_btn.dart';
import 'package:ecommerce_app/Widgets/Custom_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = "";
  String password = "";
  late FocusNode passwordFocusNode;
  late FocusNode emailFocusNode;
  bool loginFormLoading = false;

  @override
  void initState(){
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose(){
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _alertDialogBuilder(String text) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Something went wrong"),
            content: Container(
              child: Text(text),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Close Dialog"))
            ],
          );
        });
  }

  Future<String> _loginToAccount() async {
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return "";
    } on FirebaseAuthException catch (e){
      return e.message;
    } catch (ex) {
      return ex.toString();
    }
  }

  void submitForm() async {
    setState(() {
      loginFormLoading = true;
    });

    String loginAccountFedback = await _loginToAccount();
    if(loginAccountFedback != ""){
      _alertDialogBuilder(loginAccountFedback);
      setState(() {
        loginFormLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 24),
              child: Text(
                "Welcome User,\nlogin to your account",
                style: Constants.boldHeading,
                textAlign: TextAlign.center,
              ),
            ),
            Column(
              children: [
                CustomInput(
                  hintText: "E-mail",
                  OnChanged: (value) {
                    email = value;
                  },
                  OnSubmited: (value) {
                    passwordFocusNode.requestFocus();
                  },
                  focusNode: emailFocusNode,
                  textInputAction: TextInputAction.next,
                ),
                CustomInput(
                  hintText: "Password",
                  OnChanged: (value) {
                    password = value;
                  },
                  OnSubmited: (value) {
                    submitForm();
                  },
                  focusNode: passwordFocusNode,
                  textInputAction: TextInputAction.done,
                  isPassword: true,
                ),
                CustomBtn(
                  text: "Login",
                  onPressed: () {
                    submitForm();
                  },
                  outlineBtn: false,
                  isLoading: loginFormLoading,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomBtn(
                text: "Create New Account",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage()));
                },
                outlineBtn: true,
                isLoading: false,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
