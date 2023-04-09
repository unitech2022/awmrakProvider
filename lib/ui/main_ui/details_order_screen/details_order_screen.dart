import 'package:awamrakeprovider/bloc/order_cubit/order_cubit.dart';
import 'package:awamrakeprovider/helpers/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../helpers/constants.dart';
import '../../../models/order_response.dart';
import '../../../widgets/custom_drop_down2.dart';
import '../../../widgets/custom_drop_down_widget.dart';
import '../../../widgets/text_widget.dart';

class DetailsOrderScreen extends StatefulWidget {
  final ResponseOrder responseOrder;

  DetailsOrderScreen(this.responseOrder);

  @override
  State<DetailsOrderScreen> createState() => _DetailsOrderScreenState();
}

class _DetailsOrderScreenState extends State<DetailsOrderScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    OrderCubit.get(context).currentStatus = OrderCubit.get(context)
        .listStatus
        .firstWhere(
            (element) => element.id == widget.responseOrder.order!.status!,
            orElse: () => Status(0, "جارى التنفيذ"));
  }

  @override
  Widget build(BuildContext context) {
    DateTime now =
        DateTime.parse(widget.responseOrder.order!.createdAt.toString());
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

    return BlocConsumer<OrderCubit, OrderState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: const Text(
              "تفاصيل الطلب",
              maxLines: 1,
              style: TextStyle(
                  fontSize: 20,
                  height: 1.20,
                  fontFamily: "pnuB",
                  color: Colors.white),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  Text(
                    "طلب رقم : ${widget.responseOrder.order!.id!}",
                    style: const TextStyle(
                        fontSize: 20,
                        height: 1.20,
                        fontFamily: "pnuB",
                        color: homeColor),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  details_order_text(
                    title: "اسم العميل :",
                    value: widget.responseOrder.userName!,
                  ),
                  const Divider(
                    height: 1,
                  ),
                  details_order_text(
                    title: "رقم الهاتف  :",
                    value: widget.responseOrder.userPhone!,
                  ),
                  const Divider(
                    height: 1,
                    color: Colors.black26,
                  ),
                  details_order_text(
                    title: "العنوان  :",
                    value: widget.responseOrder.address!.lable!,
                  ),
                  const Divider(
                    height: 1,
                  ),
                  details_order_text(
                    title: "وقت الطلب : ",
                    value: formattedDate,
                  ),
                  const Divider(
                    height: 1,
                  ),
                  details_order_text(
                    title: "السعر الكلى  :",
                    value: widget.responseOrder.order!.price!.toString(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "تحديث الحالة :",
                        style: TextStyle(
                            fontSize: 20,
                            height: 1.20,
                            fontFamily: "pnuB",
                            color: homeColor),
                      ),
                      Container(
                        width: 150,
                        height: 40,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: OrderCubit.get(context).loadOrderUpdate
                            ? const Padding(
                                padding: EdgeInsets.all(3.0),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : CustomDropDownWidget2(
                                listWidget: OrderCubit.get(context)
                                    .listStatus
                                    .map((item) => DropdownMenuItem<dynamic>(
                                        value: item,
                                        child: Text(
                                          item.name,
                                          style: const TextStyle(
                                            fontFamily: "pnuR",
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        )))
                                    .toList(),
                                currentValue:
                                    OrderCubit.get(context).currentStatus,
                                selectCar: false,
                                textColor: Colors.white,
                                isTwoIcons: false,
                                iconColor: Colors.white,
                                backroundColor: Colors.black54,
                                list: OrderCubit.get(context).listStatus,
                                onSelect: (dynamic value) {
                                  if(value.id != 0){
                                    OrderCubit.get(context).changeStatus(value);
                                    OrderCubit.get(context).updateOrder(
                                        status: value.id,
                                        orderId: widget.responseOrder.order!.id!,
                                        marketId: widget
                                            .responseOrder.order!.sellerId!);

                                  }

                                },
                                hint: ""),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "المنتجات المطلوبة",
                    style: TextStyle(
                        fontSize: 20,
                        height: 1.20,
                        fontFamily: "pnuB",
                        color: homeColor),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.responseOrder.products!.length,
                      itemBuilder: (_, i) {
                        Cart cart = widget.responseOrder.products![i];
                        return Container(
                          height: 80,
                          padding: paddingSymmetric(hor: 5, ver: 10),
                          margin: const EdgeInsets.only(bottom: 10),
                          width: 200,
                          color: Colors.white,
                          child: Row(
                            children: [
                              CachedNetworkImage(
                                imageUrl: baseurlImage + cart.image!,
                                width: 60,
                                height: 60,
                                fit: BoxFit.fill,
                                placeholder: (context, url) => const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextWidget2(
                                          width: 140,
                                          alginText: TextAlign.start,
                                          isCustomColor: true,
                                          text: cart.nameProduct!,
                                          fontFamliy: "pnuB",
                                          fontSize: 12,
                                          color: Colors.black),
                                    ],
                                  ),
                                  RichTextOrder(
                                    value: cart.quantity.toString(),
                                    lable: "عدد ",
                                  ),
                                ],
                              ),
                              TextWidget3(
                                  alginText: TextAlign.start,
                                  isCustomColor: true,
                                  text: " ${cart.total} جنية",
                                  fontFamliy: "pnuB",
                                  fontSize: 20,
                                  color: priceColor),
                            ],
                          ),
                        );
                      })
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class RichTextOrder extends StatelessWidget {
  final String lable, value;

  RichTextOrder({required this.lable, required this.value});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: lable,
        style: TextStyle(
            fontSize: 14,
            fontFamily: "pnuR",
            fontWeight: FontWeight.bold,
            color: Colors.black.withOpacity(.5)),
        children: [
          TextSpan(
              text: value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "pnuR",
                  color: Colors.black,
                  fontSize: 14)),
        ],
      ),
    );
  }
}

class details_order_text extends StatelessWidget {
  final String title, value;

  details_order_text({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              maxLines: 2,
              style: const TextStyle(
                  fontSize: 16,
                  fontFamily: "pnuB",
                  height: 1.20,
                  color: homeColor),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            value,
            maxLines: 1,
            textAlign: TextAlign.start,
            style: const TextStyle(
                height: 1.20,
                fontSize: 18,
                fontFamily: "pnuB",
                color: Colors.black),
          ),
          const SizedBox(
            height: 2,
          ),
        ],
      ),
    );
  }
}
