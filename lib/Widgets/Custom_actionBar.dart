import 'package:ecommerce_app/Constants.dart';
import 'package:flutter/material.dart';
import '../Screens/Cart_page.dart';
import '../Services/Firebase Services.dart';

class CustomActionBar extends StatelessWidget {
  final String title;
  final bool hasBackArrow;
  final bool hasTitle;
  final bool? hasBackground;
  final bool? hideCart;
  final bool? changeTotalValue;
  int totalItens = 0;

  CustomActionBar(
      {Key? key,
      required this.title,
      required this.hasBackArrow,
      required this.hasTitle,
      this.hasBackground,
      this.hideCart,
      this.changeTotalValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseServices _firebaseServices = FirebaseServices();
    bool hideCondition = hideCart ?? false;

    return Container(
      decoration: BoxDecoration(
        gradient: hasBackground ?? false
            ? LinearGradient(
          colors: [
            Colors.white,
            Colors.white.withOpacity(0),
          ],
          begin: const Alignment(0, 0),
          end: const Alignment(0, 1),
        )
            : null,
      ),
      padding: const EdgeInsets.only(top: 56, left: 24, right: 24, bottom: 42),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (hasBackArrow)
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          if (hasTitle)
            Text(
              title,
              style: Constants.boldHeading,
            ),
          if (!hideCondition)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(),
                  ),
                );
              },
              child: SizedBox(
                width: 40,
                height: 40,
                child: Center(
                  child: StreamBuilder<dynamic>(
                    stream: changeTotalValue ?? false
                        ? _firebaseServices.usersReference
                        .doc(_firebaseServices.getUserId())
                        .collection("Saved")
                        .snapshots()
                        : _firebaseServices.usersReference
                        .doc(_firebaseServices.getUserId())
                        .collection("Cart")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        List _documents = snapshot.data.docs;
                        totalItens = _documents.length;
                      }

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: totalItens > 0 ? Theme.of(context).colorScheme.secondary : Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "$totalItens",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
