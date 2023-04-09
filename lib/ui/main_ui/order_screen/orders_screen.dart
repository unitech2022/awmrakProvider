import 'package:awamrakeprovider/bloc/order_cubit/order_cubit.dart';
import 'package:awamrakeprovider/helpers/functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../helpers/add_helper.dart';
import '../../../helpers/constants.dart';
import '../../../helpers/styles.dart';
import '../../../models/order_response.dart';
import '../details_order_screen/details_order_screen.dart';

class OrdersScreen extends StatefulWidget {
  final int id;

  OrdersScreen(this.id);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {

  BannerAd? _bannerAd;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAdds();
    OrderCubit.get(context).getOrders(market_id: widget.id);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          "الطلبات",
          style: TextStyle(fontSize: 18),
        ),
      ),
      bottomSheet: _bannerAd != null?
      Container(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      ):SizedBox(),
      body: BlocConsumer<OrderCubit, OrderState>(
        listener: (context, state) {},
        builder: (context, state) {
          return OrderCubit.get(context).loadOrders
              ? const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: homeColor,
                  ),
                )
              : ListView.builder(
                  itemCount: OrderCubit.get(context).orders.length,
                  padding: const EdgeInsets.only(left: 5,right:5,bottom: 50,top: 10),
                  itemBuilder: (_, index) {
                    ResponseOrder responseOrder =
                        OrderCubit.get(context).orders[index];
                    DateTime now = DateTime.parse(
                        responseOrder.order!.createdAt.toString());
                    String formattedDate =
                        DateFormat('yyyy-MM-dd – kk:mm').format(now);

                    return InkWell(
                      onTap: (){

                        pushPage(
                          context: context,page: DetailsOrderScreen(
                            responseOrder
                        )
                        );
                      },
                      child: Container(
                        height: 80,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Container(
                              decoration:
                                  const BoxDecoration(shape: BoxShape.circle),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: CachedNetworkImage(
                                  imageUrl: responseOrder.products!.isNotEmpty?  baseurlImage +responseOrder.products![0].image!:"",
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: SizedBox(
                                        width: 25,
                                        height: 25,
                                        child: CircularProgressIndicator(
                                          color: Colors.green,
                                        )),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const SizedBox(
                                          height: 100,
                                          child: Center(
                                              child: Icon(
                                            Icons.photo,
                                            size: 25,
                                          ))),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20,),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "طلب رقم : ${responseOrder.order!.id!}",
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
                                  formattedDate,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontFamily: "pnuR",
                                      height: 1.20,
                                      color: Colors.black.withOpacity(.6)),
                                ),
                              ],
                            )),
                             Text(
                              OrderCubit.get(context).listStatus[responseOrder.order!.status!].name,
                               style: TextStyle(
                                 fontFamily: "pnuB",color:responseOrder.order!.status==0? Colors.green
                               :responseOrder.order!.status==1?Colors.red:Colors.brown),
                            ),

                          ],
                        ),
                      ),
                    );
                  });
        },
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bannerAd!.dispose();
  }
}
