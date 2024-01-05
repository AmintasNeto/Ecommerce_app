import 'package:ecommerce_app/Screens/Homepage.dart';
import 'package:ecommerce_app/Screens/Login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../Constants.dart';

class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(
                child: Text(
                  "Initialization Error",
                  style: Constants.regularReading,
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot2) {
                if (snapshot2.hasError) {
                  return const Scaffold(
                    body: Center(
                      child: Text(
                        "Initialization Error",
                        style: Constants.regularReading,
                      ),
                    ),
                  );
                }

                if (snapshot2.connectionState == ConnectionState.active) {
                  Object? _user = snapshot2.data;

                  if (_user == null) {
                    return LoginPage();
                  } else {
                    return Homepage();
                  }
                }

                return Scaffold(
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Center(
                        child: Text(
                          "Checking Authentication",
                          style: Constants.regularReading,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 25),
                        child: CircularProgressIndicator(color: Colors.black,),
                      ),
                    ],
                  ),
                );
              },
            );
          }

          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Center(
                  child: Text(
                    "Initiating App",
                    style: Constants.regularReading,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 25),
                  child: CircularProgressIndicator(color: Colors.black,),
                )
              ],
            ),
          );
        });
  }
}
