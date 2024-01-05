import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final CollectionReference productsReference =
      FirebaseFirestore.instance.collection("Products");

  final CollectionReference usersReference =
      FirebaseFirestore.instance.collection("Users");

  String getUserId() {
    return _firebaseAuth.currentUser.uid;
  }
}
