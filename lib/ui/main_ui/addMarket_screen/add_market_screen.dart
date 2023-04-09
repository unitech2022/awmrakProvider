import 'dart:io';

import 'package:awamrakeprovider/bloc/home_cubit/home_cubit.dart';
import 'package:awamrakeprovider/bloc/market_cubit/market_cubit.dart';
import 'package:awamrakeprovider/helpers/router.dart';
import 'package:awamrakeprovider/models/market.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../helpers/constants.dart';
import '../../../helpers/functions.dart';
import '../../../helpers/helper_function.dart';
import '../../../helpers/styles.dart';
import '../../../widgets/Buttons.dart';
import '../../../widgets/custom_drop_down_widget.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/text_widget.dart';

class AddMarketScreen extends StatefulWidget {
  const AddMarketScreen({Key? key}) : super(key: key);

  @override
  State<AddMarketScreen> createState() => _AddMarketScreenState();
}

class _AddMarketScreenState extends State<AddMarketScreen> {
  final _controllerName = TextEditingController();

  final _controllerDetails = TextEditingController();

  final _controllerAddress = TextEditingController();
  final _controllerPhone = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    HomeCubit
        .get(context)
        .currentCategory = null;
    HomeCubit
        .get(context)
        .governorate = null;
    HomeCubit
        .get(context)
        .currentCity = null;
  }

  double lat = 0.0;
  double lng = 0.0;
  File? _file;
  String image = "";

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerName.dispose();
    _controllerDetails.dispose();
    _controllerAddress.dispose();
    _controllerPhone.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MarketCubit, MarketState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: const Text("اضافة محل", style: TextStyle(fontSize: 18)),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      TitleWidget("اسم المحل "),
                      CustomFormField(
                        headingText: "Email",
                        hintText: "اسم المحل",
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
                      TitleWidget("رقم الهاتف"),
                      CustomFormField(
                        headingText: "Email",
                        hintText: "رقم الهاتف",
                        obsecureText: false,
                        suffixIcon: const SizedBox(),
                        controller: _controllerPhone,
                        maxLines: 1,
                        textInputAction: TextInputAction.done,
                        textInputType: TextInputType.phone,
                      ),
                      const SizedBox(
                        height: 10,
                      ),


                      TitleWidget("العنوان بالتفصيل"),
                      CustomFormField(
                        headingText: "Email",
                        hintText: "العنوان",
                        obsecureText: false,
                        suffixIcon: const SizedBox(),
                        controller: _controllerAddress,
                        maxLines: 1,
                        textInputAction: TextInputAction.done,
                        textInputType: TextInputType.text,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TitleWidget("تفاصيل المحل"),
                      CustomFormField(
                        headingText: "Password",
                        maxLines: 8,
                        textInputAction: TextInputAction.done,
                        textInputType: TextInputType.text,
                        hintText: "تفاصيل المحل ",
                        obsecureText: false,
                        suffixIcon: const SizedBox(),
                        controller: _controllerDetails,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      BlocConsumer<HomeCubit, HomeState>(
                        listener: (context, state) {
                          // TODO: implement listener
                        },
                        builder: (context, state) {
                          return Column(
                            children: [
                              TitleWidget("القسم "),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                        width: 1, color: Colors.black)),
                                child: CustomDropDownWidget2(
                                    listWidget: HomeCubit
                                        .get(context)
                                        .homeModel
                                        .categories!
                                        .map((item) =>
                                        DropdownMenuItem<dynamic>(
                                            value: item,
                                            child: Text(
                                              item.name!,
                                              style: const TextStyle(
                                                fontFamily: "pnuR",
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            )))
                                        .toList(),
                                    currentValue:
                                    HomeCubit
                                        .get(context)
                                        .currentCategory,
                                    selectCar: false,
                                    textColor: Colors.black26,
                                    isTwoIcons: false,
                                    iconColor: const Color(0xff515151),
                                    list: HomeCubit
                                        .get(context)
                                        .homeModel
                                        .categories!,
                                    onSelect: (dynamic value) {
                                      HomeCubit.get(context).changeNav(value);
                                    },
                                    hint: "اختار القسم"),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TitleWidget("المحافظة"),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                        width: 1, color: Colors.black)),
                                child: CustomDropDownWidget2(
                                    listWidget: HomeCubit
                                        .get(context)
                                        .governorates
                                        .map((item) =>
                                        DropdownMenuItem<dynamic>(
                                            value: item,
                                            child: Text(
                                              item.governorateNameAr!,
                                              style: const TextStyle(
                                                fontFamily: "pnuR",
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            )))
                                        .toList(),
                                    currentValue: HomeCubit
                                        .get(context)
                                        .governorate,
                                    selectCar: false,
                                    textColor: Colors.black26,
                                    isTwoIcons: false,
                                    iconColor: const Color(0xff515151),
                                    list: HomeCubit
                                        .get(context)
                                        .governorates,
                                    onSelect: (dynamic value) {
                                      HomeCubit
                                          .get(context)
                                          .currentCity = null;
                                      HomeCubit.get(context).changeGover(value);

                                      HomeCubit.get(context).getCities(
                                          value.id!);
                                    },
                                    hint: "اختار المحافظة"),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TitleWidget("المدينة "),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                        width: 1, color: Colors.black)),
                                child: CustomDropDownWidget2(
                                    listWidget: HomeCubit
                                        .get(context)
                                        .cities
                                        .map((item) =>
                                        DropdownMenuItem<dynamic>(
                                            value: item,
                                            child: Text(
                                              item.cityNameAr!,
                                              style: const TextStyle(
                                                fontFamily: "pnuR",
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            )))
                                        .toList(),
                                    currentValue: HomeCubit
                                        .get(context)
                                        .currentCity,
                                    selectCar: false,
                                    textColor: Colors.black26,
                                    isTwoIcons: false,
                                    iconColor: const Color(0xff515151),
                                    list: HomeCubit
                                        .get(context)
                                        .cities,
                                    onSelect: (dynamic value) {
                                      HomeCubit.get(context).changeCity(value);
                                    },
                                    hint: "اختار المدينة"),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          );
                        },
                      ),
                      InkWell(
                        onTap: () async {
                          var results =
                          await Navigator.pushNamed(context, mapScreen);

                          if (results != null) {
                            // You code goes here.

                            setState(() {
                              final splitted = results.toString().split(',');
                              // location == results.toString().split("/")[1];

                              lat = double.parse(splitted[0]);
                              lng = double.parse(splitted[1]);
                              print("resulte${lat}");
                            });
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              (lat == 0.0 || lng == 0.0)
                                  ? Icons.location_on_outlined
                                  : Icons.check,
                              color: Colors.green,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              (lat == 0.0 || lng == 0.0)
                                  ? "حدد العنوان علي الخريطة"
                                  : "تم تحديد الموقع ",
                              style: const TextStyle(fontFamily: "pnuB"),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
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
                      MarketCubit
                          .get(context)
                          .addLoadMarket
                          ? const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: homeColor,
                        ),
                      )
                          : DefaultButton(
                        colorText: const Color(0xffffffff),
                        height: 50,
                        text: "اضافة",
                        onPress: () {
                          MarketModel model =
                          MarketModel(
                            userId: currentUser.id,
                            city: HomeCubit
                                .get(context)
                                .currentCity!
                                .cityNameAr,
                            status: 0,
                            token: token,
                            lat: lat,
                            phone: _controllerPhone.text.trim(),
                            address: _controllerAddress.text,
                            categoryId: HomeCubit
                                .get(context)
                                .currentCategory!
                                .id,
                            image: image,
                            name: _controllerName.text,
                            lng: lng,
                            details: _controllerDetails.text,


                          );


                          if (isValidate(context)) {
                            MarketCubit.get(context).
                            addMarket(model, context, onSuccess: () {
                              HomeCubit
                                  .get(context)
                                  .currentCity = null;
                              HomeCubit
                                  .get(context)
                                  .governorate = null;
                              HomeCubit.get(context).getHomeData();
                            });
                          }
                          // Navigator.of(context).pushNamed(ValidateNumberScreen.id);
                        },
                        color: homeColor,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
          ),
        );
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
          context: context, color: Colors.red, message: "اكتب اسم المحل ");
      return false;
    } else if (_controllerAddress.text.isEmpty) {
      HelperFunction.slt.notifyUser(
          context: context, color: Colors.red, message: "اكتب عنوان المحل");
      return false;
    }
    else if (_controllerPhone.text.isEmpty) {
      HelperFunction.slt.notifyUser(
          context: context, color: Colors.red, message: "اكتب رقم الهاتف");
      return false;
    }
    else if (_controllerDetails.text.isEmpty) {
      HelperFunction.slt.notifyUser(
          context: context, color: Colors.red, message: "اكتب تفاصيل المحل");
      return false;
    } else if (HomeCubit
        .get(context)
        .currentCategory == null) {
      HelperFunction.slt.notifyUser(
          context: context, color: Colors.red, message: "اختار القسم");
      return false;
    } else if (HomeCubit
        .get(context)
        .currentCity == null) {
      HelperFunction.slt.notifyUser(
          context: context, color: Colors.red, message: "اختار المدينة");
      return false;
    } else if (lat == 0.0 || lng == 0.0) {
      HelperFunction.slt.notifyUser(
          context: context,
          color: Colors.red,
          message: "حدد العنوان علي الخريطة");
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

class TitleWidget extends StatelessWidget {
  final String text;

  TitleWidget(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Text(text,
          style: const TextStyle(
              fontFamily: "pnuB", fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}
