import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Services/Firebase%20Services.dart';
import 'package:ecommerce_app/Widgets/Custom_input.dart';
import 'package:flutter/material.dart';
import '../Constants.dart';
import '../Widgets/Product_card.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({Key? key}) : super(key: key);

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  String searchString = "";

  @override
  Widget build(BuildContext context) {
    FirebaseServices firebaseServices = FirebaseServices();
    return Stack(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 125, left: 145),
          child: Text("Search Results", style: Constants.regularDarkText),
        ),
        if(searchString.isNotEmpty)
          FutureBuilder<QuerySnapshot>(
            future: firebaseServices.productsReference.orderBy("Search_Name").startAt(
                [searchString]).endAt(["$searchString\uf8ff"]).get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView(
                  padding: const EdgeInsets.only(top: 148, bottom: 12),
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
        Padding(
          padding: const EdgeInsets.only(top: 45),
          child: CustomInput(
            hintText: "Search Here",
            OnChanged: (text) {
                setState(() {
                  searchString = text.toLowerCase();
                });
            },
            OnSubmited: (text) {
                setState(() {
                  searchString = text.toLowerCase();
                });
            },
            textInputAction: TextInputAction.done,
          ),
        ),
      ],
    );
  }
}
