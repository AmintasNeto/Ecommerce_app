import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Constants.dart';
import 'package:ecommerce_app/Services/Firebase%20Services.dart';
import 'package:ecommerce_app/Widgets/Custom_actionBar.dart';
import 'package:ecommerce_app/Widgets/Image_swipe.dart';
import 'package:ecommerce_app/Widgets/Product_size.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  String productId;
  final String? productSize;

  ProductPage({Key? key, required this.productId, this.productSize})
      : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final FirebaseServices _firebaseServices = FirebaseServices();

  String _selectedProductSize = "";
  bool isSaved = false;

  Future<void> addToCart() {
    return _firebaseServices.usersReference
        .doc(_firebaseServices.getUserId())
        .collection("Cart")
        .doc("${widget.productId} - $_selectedProductSize")
        .set({"Size": _selectedProductSize});
  }

  Future<void> addToSaveList() {
    return _firebaseServices.usersReference
        .doc(_firebaseServices.getUserId())
        .collection("Saved")
        .doc("${widget.productId} - $_selectedProductSize")
        .set({"Size": _selectedProductSize});
  }

  Future<bool> checkSaved(String id) async {
    QuerySnapshot query = await _firebaseServices.usersReference
        .doc(_firebaseServices.getUserId())
        .collection("Saved").get();
    var tempList = query.docs;
    var list = tempList.map((DocumentSnapshot docs) {
      return docs.id;
    }).toList();
    return list.contains(id);
  }

  Future<void> updateConditional() async {
    isSaved = await checkSaved(widget.productId);
  }

  final SnackBar _snackBar = const SnackBar(
    content: Text(
      "Product added to the cart",
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Color(0xFFFF1E00),
  );

  final SnackBar _snackBarSaved = const SnackBar(
    content: Text(
      "Product added to the save list",
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.black,
  );

  @override
  void initState() {
    widget.productId = widget.productId.split(" - ")[0];
    updateConditional();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<dynamic>(
            future:
                _firebaseServices.productsReference.doc(widget.productId).get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> documentData = snapshot.data.data();
                List imageList = documentData["Images"];
                List sizesList = documentData["Sizes"];
                int idSelected = 0;
                _selectedProductSize = widget.productSize ?? sizesList[0];
                for (int i = 0; i < sizesList.length; i++) {
                  if (sizesList[i] == widget.productSize) {
                    idSelected = i;
                  }
                }
                return ListView(
                  children: [
                    PageSwipe(imageList),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 24,
                        left: 24,
                        right: 24,
                        bottom: 4,
                      ),
                      child: Text(
                        documentData['Name'],
                        style: Constants.boldHeading,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 4,
                      ),
                      child: Text(
                        "R\$ ${documentData['Price'].toString()}",
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      child: Text(
                        documentData['Description'],
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 24,
                      ),
                      child: Text(
                        "Select Size",
                        style: Constants.regularDarkText,
                      ),
                    ),
                    ProductSize(
                      sizesList: sizesList,
                      onSelected: (size) {
                        _selectedProductSize = size;
                      },
                      idSelected: idSelected,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 24, right: 24, top: 130),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await addToSaveList();
                              updateConditional();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(_snackBarSaved);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCDCDC),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              width: 60,
                              height: 60,
                              child: Icon(
                                isSaved
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                size: 28,
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                await addToCart();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(_snackBar);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 60,
                                margin: const EdgeInsets.only(left: 16),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  "Add to cart",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              );
            },
          ),
          CustomActionBar(
            title: "",
            hasBackArrow: true,
            hasTitle: false,
            hasBackground: false,
          ),
        ],
      ),
    );
  }
}
