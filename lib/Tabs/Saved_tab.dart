import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Services/Firebase%20Services.dart';
import 'package:flutter/material.dart';
import '../Constants.dart';
import '../Screens/Product Page.dart';
import '../Widgets/Custom_actionBar.dart';

class SavedTab extends StatefulWidget {
  const SavedTab({Key? key}) : super(key: key);

  @override
  State<SavedTab> createState() => _SavedTabState();
}

class _SavedTabState extends State<SavedTab> {
  @override
  Widget build(BuildContext context) {
    FirebaseServices _firebaseServices = FirebaseServices();
    return Stack(
      children: [
        FutureBuilder<QuerySnapshot>(
            future: _firebaseServices.usersReference
                .doc(_firebaseServices.getUserId())
                .collection("Saved")
                .get(),
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
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductPage(
                                productId: document.id.split(" - ")[0],
                                productSize: document.data()["Size"],
                              ),
                            ),
                          );
                        },
                        child: FutureBuilder<dynamic>(
                          future: _firebaseServices.productsReference
                              .doc(document.id.split(" - ")[0])
                              .get(),
                          builder: (context, productSnapshot) {
                            if (productSnapshot.hasError) {
                              return Center(
                                child: Text("${productSnapshot.error}"),
                              );
                            }

                            if (productSnapshot.connectionState ==
                                ConnectionState.done) {
                              Map _productMap = productSnapshot.data.data();
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 5,
                                ),
                                child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      _productMap["Images"][0],
                                      fit: BoxFit.cover,
                                      width: 90,
                                      height: 90,
                                    ),
                                  ),
                                  title: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _productMap["Name"],
                                        style: Constants.regularReading,
                                      ),
                                      Text(
                                        "R\$ ${_productMap["Price"]}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        "Size - ${document.data()["Size"]}",
                                        style: Constants.regularDarkText,
                                      ),
                                    ],
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _firebaseServices.usersReference
                                              .doc(
                                                  _firebaseServices.getUserId())
                                              .collection("Saved")
                                              .doc(
                                                  "${productSnapshot.data.id} - ${document.data()["Size"]}")
                                              .delete();
                                          setState(() {});
                                        },
                                        child: Container(
                                          padding:
                                              const EdgeInsets.only(right: 25),
                                          child: const Icon(Icons.delete),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 45),
                                child: CircularProgressIndicator(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            );
                          },
                        ));
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
          title: "Saved",
          hasBackArrow: false,
          hasTitle: true,
          changeTotalValue: true,
        ),
      ],
    );
  }
}
