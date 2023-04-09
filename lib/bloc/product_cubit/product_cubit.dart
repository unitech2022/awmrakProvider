import 'dart:convert';


import 'package:awamrakeprovider/ui/main_ui/products_screen/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import '../../helpers/add_helper.dart';
import '../../helpers/constants.dart';
import '../../helpers/functions.dart';
import '../../helpers/helper_function.dart';
import '../../models/product.dart';
import '../../ui/main_ui/home_screen/home_screen.dart';
import '../../ui/main_ui/order_screen/orders_screen.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  static ProductCubit get(context) => BlocProvider.of<ProductCubit>(context);

  List<Product> products = [];
  bool load = false;

  getProductsByCategory(int id) async {
    products = [];
    load = true;
    emit(GetProductDataLoad());
    var request = http.MultipartRequest(
        'GET', Uri.parse(baseUrl + getProductsByCategoryPoint));
    request.fields.addAll({'categoryId': id.toString()});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonsDataString = await response.stream.bytesToString();
      final jsonData = jsonDecode(jsonsDataString);
      printFunction(jsonData);
      jsonData.forEach((v) {
        products.add(Product.fromJson(v));
      });
      load = false;

      emit(GetProductDataSuccess());
    } else {
      printFunction("errrrrrrrrrror");
      emit(GetProductDataError());
    }
  }

  bool loadAdd = false;

  addProduct(Product product, BuildContext context, int homeId, {onSuccess}) async {
    loadAdd = true;
    emit(AddProductDataLoad());

    var request = http.MultipartRequest(
        'POST', Uri.parse(baseUrl + '/product/add-product'));
    request.fields.addAll({
      'name': product.name!,
      'image': product.image!,
      'SellerId': product.sellerId!.toString(),
      'Detail': product.detail!,
      'Price': product.price!.toString(),
      'CategoryId': product.categoryId.toString(),
      'offerId': product.offerId.toString(),
      "offerPrice": product.offerPrice.toString(),
      'Status': '1',
      'city': product.city!,
      'homeCategoryId': homeId.toString()
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonsDataString = await response.stream.bytesToString();
      final jsonData = jsonDecode(jsonsDataString);
      printFunction(jsonData);

      loadAdd = false;


      onSuccess();
      HelperFunction.slt.notifyUser(
          context: context, color: Colors.green, message: "تم اضافة المنتج");
      isChecked = false;
      emit(AddProductDataSuccess());
    } else {
      print(response.statusCode);
      loadAdd = false;
      emit(AddProductDataError());
    }
  }

  bool updateLoad = false;

  updateProduct(Product product, BuildContext context) async {
    updateLoad = true;
    emit(UpdateProductDataLoad());

    var request = http.MultipartRequest(
        'POST', Uri.parse(baseUrl + '/product/update-product'));
    request.fields.addAll({
      'name': product.name!,
      'image': product.image!,
      'SellerId': product.sellerId!.toString(),
      'Detail': product.detail!,
      'Price': product.price!.toString(),
      'CategoryId': product.categoryId.toString(),
      'offerId': product.offerId!.toString(),
      "offerPrice": product.offerPrice.toString(),
      'Status': product.status!.toString(),
      'city': product.city!,
      'id': product.id.toString()
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 204) {
      updateLoad = false;
      replacePage(page: ProductsScreen(product.categoryId!), context: context);
      HelperFunction.slt.notifyUser(
          context: context, color: Colors.green, message: "تم تعديل المنتج");
      emit(UpdateProductDataSuccess());
    } else {
      print(response.statusCode);
      updateLoad = false;
      emit(UpdateProductDataError());
    }
  }

  InterstitialAd? interstitialAd;
  // TODO: Implement _loadInterstitialAd()
  loadInterstitialAd({context}) {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad){
              pushPage(page: HomeScreen(),context: context);
            },
          );




        },
        onAdFailedToLoad:(error){
          print(error.message+"adds");
        } ,

      ),
    );
  }

/*
  List<Product> searchProducts = [];
  bool loadSearch = false;

  searchProductsData({name}) async {
    searchProducts = [];
    loadSearch = true;
    emit(SearchProductDataLoad());
    var request = http.MultipartRequest(
        'GET', Uri.parse(baseUrl + searchProductsPoint));
    request.fields.addAll({'name': name});

    http.StreamedResponse response = await request.send();


    if (response.statusCode == 200) {
      String jsonsDataString = await response.stream.bytesToString();
      final jsonData = jsonDecode(jsonsDataString);
      printFunction(jsonData);
      jsonData.forEach((v) {
        searchProducts.add(Product.fromJson(v));
      });
      loadSearch = false;
      emit(SearchProductDataSuccess());
    } else {
      loadSearch = false;
      printFunction("errrrrrrrrrror");
      emit(SearchProductDataError());
    }
  }

  List<Product> offersProducts = [];

  bool loadOffers=false;
  getOffers() async {
    loadOffers=true;
    offersProducts = [];

    emit(GetProductOfferDataLoad());
    var request = http.MultipartRequest(
        'GET', Uri.parse(baseUrl + '/product/get-offer-products'));


    http.StreamedResponse response = await request.send();


    if (response.statusCode == 200) {
      String jsonsDataString = await response.stream.bytesToString();
      final jsonData = jsonDecode(jsonsDataString);
      printFunction(jsonData);
      jsonData.forEach((v) {
        offersProducts.add(Product.fromJson(v));
      });
      loadOffers = false;
      emit(GetProductOfferDataSuccess());
    } else {
      loadOffers=false;
      printFunction("errrrrrrrrrror");
      emit(GetProductOfferDataError());
    }
  }




  bool loadProduct=false;
  Product? product;
  getProductDetails(int id) async {
    product=null;
    loadProduct=true;
    offersProducts = [];

    emit(GetProductDetailsDataLoad());
    var request = http.MultipartRequest(
        'GET', Uri.parse(baseUrl + '/product/get-product-details'));

    request.fields.addAll({
      'Id': id.toString()
    });

    http.StreamedResponse response = await request.send();


    if (response.statusCode == 200) {
      String jsonsDataString = await response.stream.bytesToString();
      final jsonData = jsonDecode(jsonsDataString);
      printFunction(jsonData);
     product=Product.fromJson(jsonData);
      loadProduct = false;
      emit(GetProductDetailsDataSuccess(product!));
    } else {
      loadProduct=false;
      printFunction("errrrrrrrrrror");
      emit(GetProductDetailsDataError());
    }
  }
*/

  bool removeLoad = false;

  removeProduct(int id, int categoryId, BuildContext context) async {
    removeLoad = true;
    emit(RemoveProductOfferDataLoad());
    var headers = {'Authorization': token};
    var request = http.MultipartRequest(
        'POST', Uri.parse(baseUrl + '/product/delete-product'));
    request.fields.addAll({'id': id.toString()});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      removeLoad = false;
      getProductsByCategory(categoryId);
      pop(context);
      HelperFunction.slt.notifyUser(
          context: context, color: Colors.green, message: "تم حذف المنتج");
      emit(RemoveProductOfferDataSuccess());
    } else {
      removeLoad = false;
      print(response.statusCode);
      emit(RemoveProductOfferDataError());
    }
  }

// pagination
//   var request = http.MultipartRequest('GET', Uri.parse('https://awamrk.api.urapp.site/product/get-products-by-category-user'));
//   request.fields.addAll({
//   'ItemsPerPage': '3',
//   'page': '1',
//   'categoryId': '1'
//   });
//
//
//   http.StreamedResponse response = await request.send();
//
//   if (response.statusCode == 200) {
//   print(await response.stream.bytesToString());
//   }
//   else {
//   print(response.reasonPhrase);
//   }

  ResponseProduct? responseProducts;
  List<Product> newList = [];
  bool loadingPage = false;
  getProductsPagination({page, isPage, categoryId}) async {
    if(isPage){
       loadingPage = true;
    }else{
      load = true;
      newList = [];
    }

    emit(GetProductOfferDataLoad());

    var request = http.MultipartRequest(
        'GET', Uri.parse(baseUrl + '/product/get-products-by-category-user'));
    request.fields.addAll({
      'ItemsPerPage': '10',
      'page': page.toString(),
      'categoryId': categoryId.toString()
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonsDataString = await response.stream.bytesToString();
      final jsonData = jsonDecode(jsonsDataString);

      responseProducts = ResponseProduct.fromJson(jsonData);

      newList.addAll(responseProducts!.items!);
      if(isPage){
        loadingPage = false;
      }else{
        load = false;

      }


      emit(GetProductOfferDataSuccess());
    } else {
      print(response.reasonPhrase);
      if(isPage){
        loadingPage = false;
      }else{
        load = false;

      }

      emit(GetProductOfferDataError());
    }
  }

  bool isChecked = false;

  changeCheckBox(bool checked) {
    isChecked = checked;
    print(isChecked);
    emit(ChangeCheckBox());
  }
}
