import 'dart:convert';

import 'package:awamrakeprovider/models/order_response.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../helpers/constants.dart';
import '../../helpers/functions.dart';
import '../../models/order.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderInitial());

  static OrderCubit get(context) => BlocProvider.of<OrderCubit>(context);

  List<ResponseOrder> orders = [];

  bool loadOrders = false;

  getOrders({market_id}) async {
    orders = [];
    loadOrders = true;
    emit(GetOrderGetDataLoad());
    var headers = {'Authorization': token};
    var request = http.MultipartRequest(
        'GET', Uri.parse(baseUrl + '/order/get-market-Orders'));
    request.fields.addAll({'market_id': market_id.toString()});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonsDataString = await response.stream.bytesToString();
      final jsonData = jsonDecode(jsonsDataString);
      printFunction(jsonData);
      orders = [];
      jsonData.forEach((v) {
        orders.add(ResponseOrder.fromJson(v));
      });
      print(orders.length);
      loadOrders = false;

      emit(GetOrderLoadDataSuccess());
    } else {
      loadOrders = false;
      printFunction("errrrrrrrrrror");
      emit(GetOrderLoadDataError());
    }
  }

  int cunt = 0;

  sendNotification({deviceId, title, body, image, desc, userId}) async {
    cunt++;
    print("send" + cunt.toString());
    var request = http.MultipartRequest(
        'POST', Uri.parse(baseUrl + '/api/notification/send'));
    request.fields.addAll({
      'deviceId': deviceId,
      'isAndroiodDevice': 'true',
      'title': title,
      'body': body,
      'subject': 'dd',
      'userId': userId,
      'imageUrl': image,
      'desc': desc
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(response.statusCode);
    } else {
      print(response.statusCode);
    }
  }

  List<Status> listStatus = [
    Status(0, "جارى التنفيذ"),
    Status(1, "جارى التوصيل"),
    Status(2, "تم الاستلام"),
    Status(3, "تم الانتهاء"),
  ];
  Status? currentStatus;

  changeStatus(Status status) {
    currentStatus = status;
    emit(ChangeStatus());
  }

  bool loadOrderUpdate = false;

  updateOrder({marketId, orderId, status}) async {
    loadOrderUpdate = true;
    emit(UpdateOrderDetailsLoad());

    var headers = {
      "Authorization": token,

      // If  needed
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse(baseUrl + '/order/update-status-Order'));
    request.fields.addAll({
      'id': orderId.toString(),
      'status': status.toString(),
      'market_id': marketId.toString()
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonsDataString = await response.stream.bytesToString();
      final jsonData = jsonDecode(jsonsDataString);
      printFunction(response.statusCode);

      Order order = Order.fromJson(jsonData);
      loadOrderUpdate = false;

      getOrders(market_id: marketId);
      emit(UpdateOrderDetailsSuccess());
      sendNotification(
          image: "",
          title: "تم تغيير حالة طلبك",
          body: listStatus[order.status!].name,
          userId: order.userId,
          desc: "${order.id}",
          deviceId: order.fcmToken);
    } else {
      loadOrderUpdate = false;
      printFunction("errrrrrrrrrror");
      emit(UpdateOrderDetailsError());
    }
  }
/*
  bool loadAddOrder = false;

  Future addOrder({price,addressId,onSuccess}) async {
    loadAddOrder = true;
    emit(AddOrderGetDataLoad());

    var headers = {
      'Authorization': token
    };
    var request = http.MultipartRequest('POST', Uri.parse(baseUrl+addOrderPoint));
    request.fields.addAll({
      'Price': '$price',
      'Status': '0',
      // 'SellerId': selerId.toString(),
      'addressId': '$addressId'
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonsDataString = await response.stream.bytesToString();
      final jsonData = jsonDecode(jsonsDataString);

      loadAddOrder = false;
      printFunction(jsonData);
      onSuccess();
      emit(AddOrderLoadDataSuccess());
    } else {
      loadAddOrder = false;
      print(response.statusCode);
      emit(AddOrderLoadDataError());
    }
  }


  Future deleteOrder(int id) async {

    emit(DeleteOrderGetDataLoad());


    final params = {
      "id": "$id",
    };

    http.StreamedResponse response =
        await httpPost(id, params, deleteCartPoint);
    //
    if (response.statusCode == 200) {
      String jsonsDataString = await response.stream.bytesToString();
      final jsonData = jsonsDataString;


      emit(DeleteOrderLoadDataSuccess(jsonData));

      */ /*     // get Carts

      final dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          headers: headers,
          responseType: ResponseType.plain));
      final responseCarts = await dio.get(getCartsPoint);

      if (responseCarts.statusCode == 200) {
        carts = [];
        printFunction(responseCarts.statusCode);
        var decode = jsonDecode(responseCarts.data.toString());
        printFunction(decode);

        decode.forEach((v) {
          carts.add(Cart.fromJson(v));
        });
        quantities = [];
        prices = [];
        carts.forEach((element) {
          quantities.add(element.quantity!);
          prices.add(double.parse("${element.price}"));
        });
        emit(DeleteCartLoadDataSuccess(jsonData));

      }*/ /*

      //
    } else {
      printFunction("errrrrrrrrrror");
      emit(DeleteOrderLoadDataError());
    }
  }




int currentIndex=0;
changeStepperOrder(int index){
    currentIndex=index;
    emit(ChangeStepperOrderStae());
}


  Future<http.StreamedResponse> httpPost(
      int id, Map<String, String> params, endPoint) async {
    final headers = {
      "Authorization": token,

      // If  needed
    };
    var request = http.MultipartRequest('POST', Uri.parse(baseUrl + endPoint));
    request.fields.addAll({'id': "$id"});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    return response;
  }*/
}

class Status {
  int id;
  String name;

  Status(this.id, this.name);
}
