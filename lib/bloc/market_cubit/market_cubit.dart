import 'dart:convert';
import 'package:awamrakeprovider/helpers/constants.dart';
import 'package:awamrakeprovider/helpers/functions.dart';
import 'package:awamrakeprovider/models/market.dart';
import 'package:awamrakeprovider/ui/main_ui/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../helpers/helper_function.dart';
part 'market_state.dart';

class MarketCubit extends Cubit<MarketState> {
  MarketCubit() : super(MarketInitial());

  static MarketCubit get(context) => BlocProvider.of<MarketCubit>(context);
  bool isLoadMarket = false;
  bool isFound = false;
  MarketResponse marketResponse = MarketResponse();

  getMarket({userId}) async {
    isLoadMarket = true;
    emit(GetMarketLoad());
    var headers = {'Authorization': token};
    var request =
        http.MultipartRequest('GET', Uri.parse(baseUrl + '/field/get-market'));
    request.fields.addAll({'uderId': userId});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonsDataString = await response.stream.bytesToString();
      final jsonData = jsonDecode(jsonsDataString);
      marketResponse = MarketResponse.fromJson(jsonData);
      if(marketResponse.status!){

        updateDeviceToken(userId: marketResponse.market!.id!,token: currentUser.deviceToken);
      }

      // print(currentUser.deviceToken.toString()+"user \n" + "market"+marketResponse.market!.token!);

      isLoadMarket = false;
      emit(GetMarketSuccess());
    } else {
      print(response.statusCode);
      isLoadMarket = false;
      emit(GetMarketError());
    }
  }

  updateDeviceToken({token, userId}) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse(baseUrl + '/market/update-deviceToken'));
    request.fields.addAll({'UserId': userId.toString(), 'Token': token});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("updatedToken");
    } else {
      print("ErrorUpdatedToken"+response.statusCode.toString());
    }
  }


  bool addLoadMarket = false;

  addMarket(MarketModel model, BuildContext context, {onSuccess}) async {
    addLoadMarket = true;
    emit(AddMarketLoad());
    var headers = {'Authorization': token};
    var request =
        http.MultipartRequest('POST', Uri.parse(baseUrl + '/field/add'));
    request.fields.addAll({
      'name': model.name!,
      'Image': model.image!,
      'City': model.city!,
      'status': '0',
      'address': model.address!,
      'details': model.details!,
      'userId': model.userId!,
      'lat': model.lat.toString(),
      'lng': model.lng.toString(),
      "phone" :model.phone!,
      'categoryId': model.categoryId!.toString(),
      'token': currentUser.deviceToken!
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      addLoadMarket = false;
      onSuccess();
      // getMarket(userId: currentUser.id);
      replacePage(page: HomeScreen(), context: context);
      HelperFunction.slt.notifyUser(
          context: context, color: Colors.green, message: "تم انشاء المحل ");
      sendNotification(
          context: context,title:"تم انشاء متجر جديد",body: "${model.name} "
          );
      emit(AddMarketSuccess());
    } else {
      print(response.statusCode);
      addLoadMarket = false;
      print(response.statusCode);
      emit(AddMarketError());
    }
  }


  sendNotification({title,context,body})async{

    var request = http.MultipartRequest('POST', Uri.parse(baseUrl+'/api/notification/send/topic'));
    request.fields.addAll({
      'topice': 'admin',
      'title': title,
      'body': body,
      'subject': 'dd',
      'imageUrl': '20220412T091809.jpeg',
      'desc': 'ffgg'
    });


    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(response.statusCode.toString());


      // emit(SendNotificationSuccessStat());
    }
    else {
      print(response.statusCode.toString());
      // emit(SendNotificationErrorStat());
    }

  }

}
