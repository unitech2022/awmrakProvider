import 'dart:io';
import 'package:awamrakeprovider/bloc/market_cubit/market_cubit.dart';
import 'package:awamrakeprovider/bloc/product_cubit/product_cubit.dart';
import 'package:awamrakeprovider/models/product.dart';
import 'package:awamrakeprovider/ui/main_ui/home_screen/home_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import '../../../bloc/auth_cubit/auth_cubit.dart';
import '../../../bloc/home_cubit/home_cubit.dart';
import '../../../helpers/add_helper.dart';
import '../../../helpers/constants.dart';
import '../../../helpers/functions.dart';
import '../../../helpers/helper_function.dart';
import '../../../helpers/styles.dart';
import '../../../widgets/Buttons.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/text_widget.dart';
import '../addMarket_screen/add_market_screen.dart';

class AddProductScreen extends StatefulWidget {
  final Product product;
  final int status;

  AddProductScreen(this.product, this.status);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _controllerName = TextEditingController();

  final _controllerDetails = TextEditingController();

  final _controllerPrice = TextEditingController();
  final _controllerOfferPrice = TextEditingController();

  // TODO: Add _interstitialAd

  File? _file;
  String image = "";
  BannerAd? _bannerAd;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAdds();
    ProductCubit.get(context).loadInterstitialAd(context: context);
    _controllerOfferPrice.text = "";
    if (widget.status == 1) {
      _controllerPrice.text = widget.product.price.toString();
      _controllerDetails.text = widget.product.detail!;
      _controllerName.text = widget.product.name!;
      if (widget.product.offerId == 1) {
        ProductCubit
            .get(context)
            .isChecked = true;
        _controllerOfferPrice.text = widget.product.offerPrice.toString();
      }
      image = widget.product.image!;
    }
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerName.dispose();
    _controllerDetails.dispose();
    _controllerPrice.dispose();
    _controllerOfferPrice.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductCubit, ProductState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              title: Text(
                widget.status == 0 ? "اضافة منتج" : "تعديل المنتج",
                style: const TextStyle(fontSize: 18),
              ),
            ),
            bottomSheet: _bannerAd != null ?
            Container(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ) : SizedBox(),
            body: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        TitleWidget("اسم المنتج "),
                        CustomFormField(
                          headingText: "Email",
                          hintText: "اسم المنتج",
                          obsecureText: false,
                          suffixIcon: const SizedBox(),
                          controller: _controllerName,
                          maxLines: 1,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.text,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TitleWidget("تفاصيل المنتج"),
                        CustomFormField(
                          headingText: "Password",
                          maxLines: 8,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.text,
                          hintText: "تفاصيل المنتج ",
                          obsecureText: false,
                          suffixIcon: const SizedBox(),
                          controller: _controllerDetails,
                        ),
                        TitleWidget("االسعر"),
                        CustomFormField(
                          headingText: "Email",
                          hintText: "سعر المنتج",
                          obsecureText: false,
                          suffixIcon: const SizedBox(),
                          controller: _controllerPrice,
                          maxLines: 1,
                          textInputAction: TextInputAction.done,
                          textInputType: const TextInputType.numberWithOptions(
                              decimal: true),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                    value: ProductCubit
                                        .get(context)
                                        .isChecked,
                                    onChanged: (value) {
                                      ProductCubit.get(context).changeCheckBox(
                                          value!);
                                    }),
                                TitleWidget("اضافة عرض"),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ProductCubit
                            .get(context)
                            .isChecked ? Column(
                          children: [
                            TitleWidget("هذا السعر بدلا من "),
                            CustomFormField(
                              headingText: "Password",
                              maxLines: 1,
                              textInputAction: TextInputAction.done,
                              textInputType: const TextInputType
                                  .numberWithOptions(
                                  decimal: true),
                              hintText: "السعر القديم",
                              obsecureText: false,
                              suffixIcon: const SizedBox(),
                              controller: _controllerOfferPrice,
                            ),
                          ],
                        ) : const SizedBox(),

                        const SizedBox(
                          height: 15,
                        ),
                        BlocConsumer<HomeCubit, HomeState>(
                          listener: (context, state) {
                            // TODO: implement listener
                          },
                          builder: (context, state) {
                            if (state is PickedImage) {
                              _file = state.imagePath;
                              HomeCubit.get(context).uploadImage(_file);
                            }

                            if (state is UploadImageSuccess) {
                              image = state.imageUpload;
                              print("image$image");
                            }
                            return InkWell(
                              onTap: () {
                                HelperFunction.slt
                                    .showSheet(context, _selectImage(context));
                              },
                              child: _file != null
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.file(
                                  _file!,
                                  height: 90,
                                  fit: BoxFit.cover,
                                  width: 90,
                                ),
                              )
                                  : ClipRRect(
                                child: CachedNetworkImage(
                                  imageUrl: image != null
                                      ? baseurlImage + image
                                      : "notFound",
                                  height: 150,
                                  fit: BoxFit.cover,
                                  width: 150,
                                  placeholder: (context, url) =>
                                  const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: CircularProgressIndicator(
                                      color: homeColor,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                  const Icon(
                                    Icons.photo,
                                    size: 100,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        (ProductCubit
                            .get(context)
                            .loadAdd ||
                            ProductCubit
                                .get(context)
                                .updateLoad)
                            ? const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: homeColor,
                          ),
                        )
                            : DefaultButton(
                          colorText: const Color(0xffffffff),
                          height: 50,
                          text: widget.status == 0 ? "اضافة" : "تعديل",
                          onPress: () {
                            if (isValidate(context)) {
                              if (widget.status == 0) {
                                if (ProductCubit
                                    .get(context)
                                    .isChecked) {
                                  Product product = Product(
                                    name: _controllerName.text,
                                    image: image,
                                    categoryId: MarketCubit
                                        .get(context)
                                        .marketResponse
                                        .market!
                                        .id!,
                                    city: MarketCubit
                                        .get(context)
                                        .marketResponse
                                        .market!
                                        .city,
                                    offerId: 1,
                                    offerPrice: _controllerOfferPrice.text,
                                    sellerId: currentUser.id,
                                    detail: _controllerDetails.text,
                                    price:
                                    double.parse(_controllerPrice.text),
                                  );

                                  ProductCubit.get(context)
                                      .addProduct(product, context,
                                    MarketCubit
                                        .get(context)
                                        .marketResponse
                                        .market!
                                        .categoryId!,);
                                } else {
                                  Product product = Product(
                                    name: _controllerName.text,
                                    image: image,
                                    categoryId: MarketCubit
                                        .get(context)
                                        .marketResponse
                                        .market!
                                        .id!,
                                    city: MarketCubit
                                        .get(context)
                                        .marketResponse
                                        .market!
                                        .city,
                                    offerPrice: "0",
                                    offerId: 0,
                                    sellerId: currentUser.id,
                                    detail: _controllerDetails.text,
                                    price:
                                    double.parse(_controllerPrice.text),
                                  );

                                  ProductCubit.get(context)
                                      .addProduct(product, context,
                                      MarketCubit
                                          .get(context)
                                          .marketResponse
                                          .market!
                                          .categoryId!,
                                      onSuccess: () {
                                        if (ProductCubit
                                            .get(context)
                                            .interstitialAd != null) {
                                          ProductCubit
                                              .get(context)
                                              .interstitialAd!
                                              .show();
                                        } else {
                                          pushPage(
                                              context: context,
                                              page: HomeScreen()
                                          );
                                        }
                                      });
                                }
                              } else {
                                if (ProductCubit
                                    .get(context)
                                    .isChecked) {
                                  Product product = Product(
                                      name: _controllerName.text,
                                      image: image,
                                      categoryId: widget.product.categoryId,
                                      city: widget.product.city,
                                      sellerId: currentUser.id,
                                      detail: _controllerDetails.text,
                                      offerPrice: _controllerOfferPrice.text,
                                      homeCategoryId: widget.product
                                          .homeCategoryId,

                                      price: double.parse(
                                          _controllerPrice.text),
                                      id: widget.product.id,
                                      createAt: widget.product.createAt,
                                      status: widget.product.status,
                                      offerId: 1);

                                  ProductCubit.get(context)
                                      .updateProduct(product, context);
                                } else {
                                  Product product = Product(
                                      name: _controllerName.text,
                                      image: image,
                                      categoryId: widget.product.categoryId,
                                      city: widget.product.city,
                                      sellerId: currentUser.id,
                                      detail: _controllerDetails.text,
                                      offerPrice: '0',
                                      homeCategoryId: widget.product
                                          .homeCategoryId,

                                      price: double.parse(
                                          _controllerPrice.text),
                                      id: widget.product.id,
                                      createAt: widget.product.createAt,
                                      status: widget.product.status,
                                      offerId: 0);

                                  ProductCubit.get(context)
                                      .updateProduct(product, context);
                                }
                              }
                            }
                          },
                          color: homeColor,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                      ],
                    ),
                  ])),
            ));
      },
    );
  }

  _selectImage(context) =>
      Container(
        height: 280,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18.0,
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 24,
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.5),
                  color: const Color(0xFFDCDCDF),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 147,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        pop(context);
                        HomeCubit.get(context)
                            .getImage(context, ImageSource.gallery);
                        // printFunction(image);
                        // AuthProvider.getInItRead(context).updateProfile(context,key: "ImageUrl",value:image);
                      },
                      child: Container(
                        height: 147,
                        width: 147,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFFF6F2F2),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.video_library_outlined,
                              size: 30,
                              color: homeColor,
                            ),
                            const SizedBox(height: 10),
                            TextWidget3(
                                alginText: TextAlign.start,
                                isCustomColor: true,
                                text: "اخترصورة",
                                fontFamliy: "pnuL",
                                fontSize: 18,
                                color: textColor.withOpacity(.5))
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    InkWell(
                      onTap: () async {
                        pop(context);
                        HomeCubit.get(context)
                            .getImage(context, ImageSource.camera);
                        // String image = await HelperFunction.slt.getImage(
                        //
                        //     context,
                        //    );
                        // AuthProvider.getInItRead(context).updateProfile(context,key: "ImageUrl",value:image);
                        // emitMessage(image+"大"+"0");
                      },
                      child: Container(
                        height: 147,
                        width: 147,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFFF6F2F2),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.video_call,
                              size: 30,
                              color: homeColor,
                            ),
                            const SizedBox(height: 10),
                            TextWidget3(
                                alginText: TextAlign.start,
                                isCustomColor: true,
                                text: "استخدام الكاميرا",
                                fontFamliy: "pnuL",
                                fontSize: 18,
                                color: textColor.withOpacity(.5))
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );

  updateImageDialog(context) {
    var _image;

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                final picker = ImagePicker();
                Future getImage() async {
                  final pickedFile =
                  await picker.getImage(source: ImageSource.gallery);
                  setState(() {
                    if (pickedFile != null) {
                      _image = File(pickedFile.path);
                    } else {
                      print('No image selected.');
                    }
                  });
                }

                return Container(
                  color: Colors.white,
                  height: 310 + MediaQuery
                      .of(context)
                      .viewInsets
                      .bottom,
                  padding: const EdgeInsets.all(30),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      InkWell(
                        onTap: () {
                          getImage();
                        },
                        child: _image != null
                            ? Container(
                          height: 120,
                          width: 100,
                          margin: const EdgeInsets.symmetric(horizontal: 120),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              _image,
                              height: 100,
                              width: 100,
                              fit: BoxFit.fill,
                            ),
                          ),
                        )
                            : Container(
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 120),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: Image.asset(
                            "assets/images/file-upload.png",
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Buttons(
                          onPressed: () async {
                            if (_image != null) {
                              // String imageUrl =
                              //     await AuthProvider.getInItRead(context)
                              //         .uploadImage(_image, "user",
                              //             currentUser.user.id, context);
                              // AuthProvider.getInItRead(context).updateProfile(
                              //     context,
                              //     key: "ImageUrl",
                              //     value: imageUrl);
                            }
                          },
                          title: "حفظ وتعديل",
                          radius: 10,
                          height: 60,
                          bgColor: homeColor,
                          horizontalMargin: 30,
                          width: double.infinity)
                    ],
                  ),
                );
              });
        });
  }

  bool isValidate(BuildContext context) {
    if (_controllerName.text.isEmpty) {
      HelperFunction.slt.notifyUser(
          context: context, color: Colors.red, message: "اكتب اسم المنتج ");
      return false;
    } else if (_controllerDetails.text.isEmpty) {
      HelperFunction.slt.notifyUser(
          context: context, color: Colors.red, message: "اكتب تفاصيل المنتج");
      return false;
    } else if (_controllerPrice.text.isEmpty) {
      HelperFunction.slt.notifyUser(
          context: context, color: Colors.red, message: "اكتب سعر المنتج");
      return false;
    } else if (image == "") {
      HelperFunction.slt.notifyUser(
          context: context, color: Colors.red, message: "اختار الصورة");
      return false;
    } else {
      return true;
    }
  }
}
