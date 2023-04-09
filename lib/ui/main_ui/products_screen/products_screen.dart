import 'package:awamrakeprovider/bloc/product_cubit/product_cubit.dart';
import 'package:awamrakeprovider/helpers/functions.dart';
import 'package:awamrakeprovider/ui/main_ui/home_screen/home_screen.dart';
import 'package:awamrakeprovider/ui/main_ui/products_screen/add_product_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../helpers/add_helper.dart';
import '../../../helpers/constants.dart';
import '../../../helpers/styles.dart';
import '../../../models/product.dart';

class ProductsScreen extends StatefulWidget {
  final int id;

  ProductsScreen(this.id);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final ScrollController _controller = ScrollController();
  int page = 1;
  BannerAd? _bannerAd;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAdds();
    ProductCubit.get(context)
        .getProductsPagination(isPage: false, categoryId: widget.id, page: 1);
    _controller.addListener(() {
      if (_controller.position.pixels >= _controller.position.maxScrollExtent) {
        if (page >= ProductCubit.get(context).responseProducts!.totalPage!) {
          return;
        } else {
          page++;

          ProductCubit.get(context).getProductsPagination(
              isPage: true, categoryId: widget.id, page: page);
        }
      }
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bannerAd!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => pushPage(context: context, page: const HomeScreen()),
      child: BlocConsumer<ProductCubit, ProductState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
              bottomSheet:_bannerAd != null?
              Container(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ):SizedBox(),
              appBar: AppBar(
                automaticallyImplyLeading: true,
                title: const Text(
                  "المنتجات",
                  style: TextStyle(fontSize: 18),
                ),
                leading: IconButton(
                  onPressed: () {
                    pushPage(context: context, page: const HomeScreen());
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
              floatingActionButton: Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: FloatingActionButton.small(
                    backgroundColor: Colors.white,
                    child: const Icon(
                      Icons.add,
                      color: KYellowColor,
                    ),
                    onPressed: () {
                      pushPage(
                          context: context, page: AddProductScreen(Product(), 0));
                    }),
              ),
              body: ProductCubit.get(context).load
                  ? const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: homeColor,
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.only(left: 5,right: 5,top: 20,bottom: 50),
                      child: Stack(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                           controller: _controller,
                            itemCount: ProductCubit.get(context).newList.length,
                            itemBuilder: (BuildContext context, int index) {
                              Product category =
                                  ProductCubit.get(context).newList[index];
                              return ItemProduct(category: category);
                            },
                          ),

                          ProductCubit.get(context).loadingPage
                              ? Align(
                              alignment: Alignment.center,
                              child: Container(
                                padding: EdgeInsets.all(20),
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(20),
                                  color: Colors.black.withOpacity(.5),
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              )):SizedBox()
                        ],
                      ),
                    ));
        },
      ),
    );
  }

  void getAdds() {
    // TODO: Load a banner ad
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }

  // TODO: Add _interstitialAd
  InterstitialAd? _interstitialAd;

  // TODO: Implement _loadInterstitialAd()
  void _loadInterstitialAd(onDone,onError) {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: onDone,
          );

          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad:onError ,

      ),
    );
  }
}

class ItemProduct extends StatelessWidget {
  const ItemProduct({
    Key? key,
    required this.category,
  }) : super(key: key);

  final Product category;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // pushPage(context:context,page:CategoryScreen(category));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        height: 120,
        width: double.infinity,
        child: Card(
          elevation: 5,
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(1.0),
          child: Container(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: baseurlImage + category.image!,
                    height: double.infinity,
                    width: 100,
                    fit: BoxFit.fill,
                    placeholder: (context, url) => Center(
                      child: Container(
                          width: 25,
                          height: 25,
                          child: const CircularProgressIndicator(
                            color: Colors.green,
                          )),
                    ),
                    errorWidget: (context, url, error) => Container(
                        height: 100,
                        child: const Center(
                            child: Icon(
                          Icons.error,
                          size: 25,
                        ))),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        category.name!,
                        maxLines: 1,
                        style: const TextStyle(
                            height: 1.20,
                            fontFamily: "pnuB",
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        category.detail!,
                        maxLines: 2,
                        style: TextStyle(
                            fontFamily: "pnuR",
                            height: 1.20,
                            color: Colors.black.withOpacity(.6)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        category.price!.toString() + "  جنية ",
                        maxLines: 2,
                        style: const TextStyle(
                            fontFamily: "pnuB",
                            height: 1.20,
                            color: Colors.red),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    TextButton(
                        onPressed: () {
                          showDialog(
                            barrierColor: Colors.black26,
                            context: context,
                            builder: (context) {
                              return CustomAlertDialog(
                                title: category.name!,
                                description: "هل تريد حذف هذا المنتج ",
                                product: category,
                              );
                            },
                          );
                        },
                        child: const Text(
                          "حذف",
                          style: TextStyle(
                              fontFamily: "pnuB",
                              fontSize: 18,
                              color: Colors.red),
                        )),
                    TextButton(
                        onPressed: () {
                          pushPage(
                              page: AddProductScreen(category, 1),
                              context: context);
                        },
                        child: const Text(
                          "تعديل",
                          style: TextStyle(
                              fontFamily: "pnuB",
                              fontSize: 18,
                              color: Colors.green),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomAlertDialog extends StatefulWidget {
  final String title, description;
  Product product;

  CustomAlertDialog(
      {required this.title, required this.description, required this.product});

  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: const Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: BlocConsumer<ProductCubit, ProductState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 25),
              Text(
                widget.title,
                style: const TextStyle(
                    fontSize: 18.0,
                    fontFamily: "pnuB",
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
              const SizedBox(height: 15),
              Text(
                widget.description,
                style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "pnuM",
                    color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Divider(
                height: 1,
              ),
              Row(
                children: [
                  Expanded(
                    child: ProductCubit.get(context).removeLoad
                        ? const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: homeColor,
                            ),
                          )
                        : SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: InkWell(
                              highlightColor: Colors.grey[200],
                              onTap: () {
                                ProductCubit.get(context).removeProduct(
                                    widget.product.id!,
                                    widget.product.categoryId!,
                                    context);
                              },
                              child: Center(
                                child: Text(
                                  "حذف",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                  Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: InkWell(
                        highlightColor: Colors.grey[200],
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Text(
                            "الغاء",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
