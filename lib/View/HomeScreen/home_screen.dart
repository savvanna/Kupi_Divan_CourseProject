import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/duplicate_controller.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/home_controller.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/profile_controller.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Color/color.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Constant/const.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Font/font.dart';
import 'package:flutter_application_ecommerce/Model/Tools/JsonParse/product_parse.dart';
import 'package:flutter_application_ecommerce/Model/Widget/widget.dart';
import 'package:flutter_application_ecommerce/View/HomeScreen/AddProductScreen/add_product_screen.dart';
import 'package:flutter_application_ecommerce/View/HomeScreen/SerachScreen/serach_screen.dart';
import 'package:flutter_application_ecommerce/View/HomeScreen/ShopScreen/shop_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'bloc/home_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

HomeBloc? homeBloc;

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  final duplicateController = Get.find<DuplicateController>();
  final homeController = Get.find<HomeController>();
  final profileController = Get.find<ProfileController>();
  final getContext = Get.context!;
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: duplicateController.colors.whiteColor));
    super.initState();
  }

  @override
  void dispose() {
    homeBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider(
      create: (context) {
        final bloc = HomeBloc(homeRepository: homeController.homeRepository);
        bloc.add(HomeStart());
        homeBloc = bloc;
        return bloc;
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          final CustomColors colors = duplicateController.colors;
          final CustomTextStyle textStyle = duplicateController.textStyle;
          final ScrollPhysics physics =
              duplicateController.uiDuplicate.defaultScroll;
          if (state is HomeLoading) {
            return const CustomLoading();
          } else if (state is HomeSuccess) {
            final List<ProductEntity> productList = state.productList;
            final profileFunctions =
                Get.find<ProfileController>().profileFunctions;
            return Scaffold(
              backgroundColor: colors.blackColor,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: colors.blackColor,
                centerTitle: true,
                title: Text(
                  "MAKE YOUR HOME BEAUTIFUL",
                  style:
                      textStyle.titleLarge.copyWith(color: colors.whiteColor),
                ),
                leading: CupertinoButton(
                  child: Icon(
                    Icons.menu,
                    color: colors.whiteColor,
                  ),
                  onPressed: () {
                    showMenu(
                      color: colors.gray,
                      context: context,
                      position: RelativeRect.fill,
                      items: [
                        PopupMenuItem(
                          child: FutureBuilder<bool>(
                            future: profileController.authenticationFunctions
                                .isAdmin(),
                            builder: (BuildContext context,
                                AsyncSnapshot<bool> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (snapshot.hasData &&
                                    snapshot.data == true) {
                                  return TextButton(
                                    onPressed: () {
                                      Get.to(AddProductPage());
                                    },
                                    child: Text(
                                      "Add FURNITURE",
                                      style: textStyle.bodyNormal,
                                    ),
                                  );
                                } else {
                                  return TextButton(
                                    onPressed: () async {
                                      final Uri params = Uri(
                                        scheme: 'mailto',
                                        path: 'guchtv24@gmail.com',
                                        query:
                                            'subject=I want to become an admin',
                                      );

                                      if (await canLaunchUrl(params)) {
                                        await launchUrl(params);
                                      } else {
                                        print('Could not launch $params');
                                      }
                                    },
                                    child: Text(
                                      "Admin",
                                      style: textStyle.bodyNormal,
                                    ),
                                  );
                                }
                              } else {
                                return const CircularProgressIndicator(); // Loading indicator
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
                actions: [
                  CupertinoButton(
                    child: Icon(
                      Icons.search,
                      color: colors.whiteColor,
                    ),
                    onPressed: () {
                      Get.to(const SearchScreen());
                    },
                  )
                ],
              ),
              body: duplicateContainer(
                colors: colors,
                child: ListView.builder(
                  physics: physics,
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 1:
                        return Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Ideas for your house",
                                style: textStyle.titleLarge.copyWith(
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "",
                                style: textStyle.bodyNormal,
                              )
                            ],
                          ),
                        );
                      case 2:
                        return ProductListView(
                            colors: colors,
                            profileFunctions: profileFunctions,
                            reverse: false,
                            physics: physics,
                            textStyle: textStyle,
                            productList: productList,
                            callback: () {
                              Get.to(ShopScreen(
                                  title: "Maybe Interested",
                                  productList: productList));
                            },
                            title: "Maybe Interested");

                      case 3:
                        return BannerListView(
                            callback: () {
                              Get.to(ShopScreen(
                                  title: "POPULAR", productList: productList));
                            },
                            produtList: productList,
                            colors: colors,
                            textStyle: textStyle);

                      case 4:
                        return ProductListView(
                            profileFunctions: profileFunctions,
                            colors: colors,
                            textStyle: textStyle,
                            productList: productList.reversed.toList(),
                            title: "Recommended today",
                            physics: physics,
                            callback: () {
                              Get.to(ShopScreen(
                                  title: "Recommended today",
                                  productList: productList.reversed.toList()));
                            },
                            reverse: false);
                      default:
                        return Container();
                    }
                  },
                ),
              ),
            );
          } else if (state is HomeError) {
            return AppException(
              callback: () {
                homeBloc!.add(HomeStart());
              },
            );
          }
          return Container();
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
