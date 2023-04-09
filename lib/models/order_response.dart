import 'order.dart';

class ResponseOrder {
  String? userPhone;
  String? userName;
  String? userEmail;
  Order? order;
  Address? address;
  List<Cart>? products;

  ResponseOrder(
      {this.userPhone,
        this.userName,
        this.userEmail,
        this.order,
        this.address,
        this.products});

  ResponseOrder.fromJson(Map<String, dynamic> json) {
    userPhone = json['userPhone'];
    userName = json['userName'];
    userEmail = json['userEmail'];
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
    address =
    json['address'] != null ? new Address.fromJson(json['address']) : null;
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products!.add( Cart.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userPhone'] = this.userPhone;
    data['userName'] = this.userName;
    data['userEmail'] = this.userEmail;
    if (this.order != null) {
      data['order'] = this.order!.toJson();
    }
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class Address {
  int? id;
  String? userId;
  String? lable;
  double? lat;
  double? lng;
  String? createdAt;

  Address(
      {this.id, this.userId, this.lable, this.lat, this.lng, this.createdAt});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    lable = json['lable'];
    lat = json['lat'];
    lng = json['lng'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['lable'] = this.lable;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['createdAt'] = this.createdAt;
    return data;
  }
}

class Cart {
  int? id;
  int? orderId;
  String? image;
  String? nameProduct;
  int? productId;
  var price;
  var total;
  int? marketId;
  String? userId;
  int? quantity;

  Cart(
      {this.id,
        this.orderId,
        this.image,
        this.nameProduct,
        this.productId,
        this.price,
        this.total,
        this.marketId,
        this.userId,
        this.quantity});

  Cart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['orderId'];
    image = json['image'];
    nameProduct = json['nameProduct'];
    productId = json['productId'];
    price = json['price'];
    total = json['total'];
    marketId = json['market_id'];
    userId = json['userId'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['orderId'] = this.orderId;
    data['image'] = this.image;
    data['nameProduct'] = this.nameProduct;
    data['productId'] = this.productId;
    data['price'] = this.price;
    data['total'] = this.total;
    data['market_id'] = this.marketId;
    data['userId'] = this.userId;
    data['quantity'] = this.quantity;
    return data;
  }
}
