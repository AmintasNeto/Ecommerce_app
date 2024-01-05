import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Widgets/Custom_actionBar.dart';
import 'package:ecommerce_app/Widgets/Product_card.dart';
import 'package:flutter/material.dart';
import '../Services/Firebase Services.dart';

class HomepageTab extends StatelessWidget {
  final FirebaseServices _firebaseServices = FirebaseServices();

  HomepageTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<QuerySnapshot>(
            future: _firebaseServices.productsReference.get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView(
                  padding: const EdgeInsets.only(top: 108, bottom: 12),
                  children: snapshot.data!.docs.map((document) {
                    return ProductCard(document: document);
                  }).toList(),
                );
              }
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              );
            }),
        CustomActionBar(
          title: "Home",
          hasBackArrow: false,
          hasTitle: true,
          hasBackground: true,
        ),
      ],
    );
  }
}
