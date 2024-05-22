import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/duplicate_controller.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/profile_controller.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Color/color.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Font/font.dart';
import 'package:flutter_application_ecommerce/Model/Tools/JsonParse/product_parse.dart';
import 'package:flutter_application_ecommerce/Model/Widget/widget.dart';
import 'package:flutter_application_ecommerce/View/CartScreen/cart_screen.dart';
import 'package:flutter_application_ecommerce/View/HomeScreen/AddProductScreen/add_product_screen.dart';
import 'package:flutter_application_ecommerce/View/HomeScreen/AddProductScreen/update_product_screen.dart';
import 'package:flutter_application_ecommerce/View/HomeScreen/bloc/home_bloc.dart';
import 'package:flutter_application_ecommerce/View/HomeScreen/home_screen.dart';
import 'package:flutter_application_ecommerce/ViewModel/Cart/cart.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.productEntity});
  final ProductEntity productEntity;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final double rate = Random.secure().nextInt(5).toDouble();
  @override
  Widget build(BuildContext context) {
    final duplicateController = Get.find<DuplicateController>();
    final profileController = Get.find<ProfileController>();
    final CustomTextStyle textStyle = duplicateController.textStyle;
    final CustomColors colors = duplicateController.colors;
    final CartFunctions cartFunctions = duplicateController.cartFunctions;
    final profileFunctions = profileController.profileFunctions;
    final bool isInFavorite =
        profileFunctions.isInFavoriteBox(productEntity: widget.productEntity);

    Future<void> deleteProduct(int id) async {
      final collection = FirebaseFirestore.instance.collection('products');

      // Find the document with the matching id
      final querySnapshot = await collection.where('id', isEqualTo: id).get();

      // Firestore should only return one document with the unique id
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      homeBloc?.add(HomeStart());

      Get.to(HomeScreen());

      print('Product with ID: $id deleted successfully');
    }

    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: paddingFromRL(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: colors.gray,
                child: IconButton(
                  highlightColor: colors.whiteColor,
                  splashColor: colors.whiteColor,
                  icon: isInFavorite
                      ? Icon(
                          CupertinoIcons.heart_fill,
                          color: colors.blackColor,
                        )
                      : Icon(
                          CupertinoIcons.heart,
                          color: colors.blackColor,
                        ),
                  onPressed: () async {
                    if (isInFavorite) {
                      await profileFunctions.removeFavorite(
                          productEntity: widget.productEntity);
                      setState(() {});
                    } else {
                      await profileFunctions.addToFavorite(
                          productEntity: widget.productEntity);
                      setState(() {});
                    }
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: CupertinoTheme(
                    data: CupertinoThemeData(primaryColor: colors.primary),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CupertinoButton.filled(
                        child: Text(
                          "Add to cart",
                          style: textStyle.bodyNormal
                              .copyWith(color: colors.whiteColor),
                        ),
                        onPressed: () async {
                          bool isAdd = await cartFunctions.addToCart(
                              productEntity: widget.productEntity);
                          if (isAdd) {
                            Get.snackbar("Add to cart", "",
                                messageText: Text(
                                  "successfully add to cart",
                                  style: textStyle.bodyNormal,
                                ),
                                backgroundColor: colors.gray);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              CircleAvatar(
                backgroundColor: colors.gray,
                child: IconButton(
                  highlightColor: colors.whiteColor,
                  splashColor: colors.whiteColor,
                  icon: Icon(
                    CupertinoIcons.arrow_up_right,
                    color: colors.blackColor,
                  ),
                  onPressed: () {
                    Share.shareWithResult(widget.productEntity.name,
                        subject: "Product");
                  },
                ),
              )
            ],
          ),
        ),
        backgroundColor: colors.whiteColor,
        appBar: AppBar(
          foregroundColor: colors.blackColor,
          backgroundColor: colors.whiteColor,
          centerTitle: true,
          title: Text(
            "",
            style: textStyle.titleLarge,
          ),
          actions: [
            CartLengthBadge(
              duplicateController: duplicateController,
              colors: colors,
              textStyle: textStyle,
              badgeCallback: () {
                Get.to(const CartScreen());
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              width: Get.size.width,
              height: Get.size.height * 0.4,
              color: colors.blackColor,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      top: 15,
                    ),
                    height: 300,
                    width: 300,
                    child: CachedNetworkImage(
                      imageUrl: widget.productEntity.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: colors.blackColor,
              ),
              child: Container(
                height: Get.size.height * 0.4,
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                    color: colors.whiteColor,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(15))),
                child: SingleChildScrollView(
                  physics: duplicateController.uiDuplicate.defaultScroll,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          paddingFromRL(
                            child: Text(
                              widget.productEntity.name,
                              style: textStyle.titleLarge,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      paddingFromRL(
                          child: Text(
                        widget.productEntity.description,
                        style: textStyle.bodySmall
                            .copyWith(color: colors.captionColor),
                      )),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "₽${widget.productEntity.price}",
                        style: textStyle.titleLarge
                            .copyWith(color: colors.primary),
                      ),
                      FutureBuilder<bool>(
                        future:
                            profileController.authenticationFunctions.isAdmin(),
                        builder: (BuildContext context,
                            AsyncSnapshot<bool> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData &&
                                snapshot.data == true) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                    child: CircleAvatar(
                                      backgroundColor: colors.gray,
                                      child: IconButton(
                                        highlightColor: colors.whiteColor,
                                        splashColor: colors.whiteColor,
                                        icon: Icon(
                                          CupertinoIcons.trash,
                                          color: colors.blackColor,
                                        ),
                                        onPressed: () async {
                                          await deleteProduct(
                                              widget.productEntity.id);
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 20, 15, 20),
                                    child: CircleAvatar(
                                      backgroundColor: colors.gray,
                                      child: IconButton(
                                        highlightColor: colors.whiteColor,
                                        splashColor: colors.whiteColor,
                                        icon: Icon(
                                          CupertinoIcons.pen,
                                          color: colors.blackColor,
                                        ),
                                        onPressed: () async {
                                          Get.to(UpdateProductPage(
                                              product: widget.productEntity));
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return SizedBox.shrink(); // Empty widget
                            }
                          } else {
                            return CircularProgressIndicator(); // Loading indicator
                          }
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

Widget paddingFromRL({required Widget child}) {
  return Padding(
    padding: const EdgeInsets.only(left: 15, right: 15),
    child: child,
  );
}
