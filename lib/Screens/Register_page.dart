import 'package:ecommerce_app/Widgets/Custom_btn.dart';
import 'package:ecommerce_app/Widgets/Custom_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../Constants.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool registerFormLoading = false;
  String email = "";
  String password = "";
  late FocusNode passwordFocusNode;
  late FocusNode emailFocusNode;

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
            title: const Text("Error"),
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

  Future<String> _createAccount() async {
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      return "";
    } on FirebaseAuthException catch (e){
      return e.message;
    } catch (ex) {
      return ex.toString();
    }
  }

  void submitForm() async {
    setState(() {
      registerFormLoading = true;
    });

    String createAccountFedback = await _createAccount();
    if(createAccountFedback != ""){
      _alertDialogBuilder(createAccountFedback);
      setState(() {
        registerFormLoading = false;
      });
    } else {
      Navigator.pop(context);
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
                "Create a new account",
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
                  text: "Create Account",
                  onPressed: () {
                    submitForm();
                  },
                  outlineBtn: false,
                  isLoading: registerFormLoading,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomBtn(
                text: "Back to Login Page",
                onPressed: () {
                  Navigator.pop(context);
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
