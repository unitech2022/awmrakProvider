import 'package:awamrakeprovider/bloc/market_cubit/market_cubit.dart';
import 'package:awamrakeprovider/helpers/constants.dart';
import 'package:awamrakeprovider/helpers/functions.dart';
import 'package:awamrakeprovider/ui/main_ui/addMarket_screen/add_market_screen.dart';
import 'package:awamrakeprovider/ui/main_ui/notifications/notifications_screen.dart';
import 'package:awamrakeprovider/ui/main_ui/order_screen/orders_screen.dart';
import 'package:awamrakeprovider/ui/main_ui/products_screen/products_screen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../bloc/home_cubit/home_cubit.dart';
import '../../../helpers/add_helper.dart';
import '../../../helpers/helper_function.dart';
import '../../../helpers/styles.dart';
import '../../../widgets/Buttons.dart';
import '../../../widgets/Texts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getAdds();
    _loadInterstitialAd();
    getLocation();
    MarketCubit.get(context).getMarket(userId: currentUser.id);
    print(token);
    HomeCubit.get(context).getHomeData();
    HomeCubit.get(context).getGovernorates();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      // NotifyAowsome(notification!.title!,notification.body!);
      if (notification != null && android != null && !kIsWeb) {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
          id: createUniqueId(),

          color: homeColor,
          icon: 'resource://drawable/ic_launcher',

          channelKey: 'key1',
          title:
              '${Emojis.money_money_bag + Emojis.plant_cactus}${notification.title}',
          body: notification.body,
          // bigPicture: "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
          // notificationLayout: NotificationLayout.BigPicture,
          // largeIcon: "asset://assets/images/logo_final.png"
        ));
        print("aaaaaaaaaaaawww${message.data["desc"]}");
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bannerAd!.dispose();
  }

  int click = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MarketCubit, MarketState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: FloatingActionButton.small(
              backgroundColor: Colors.white,
              onPressed: () {
                MarketCubit.get(context).getMarket(userId: currentUser.id);
              },
              child: const Icon(
                Icons.refresh,
                color: Colors.green,
              ),
            ),
          ),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              "الصفحة الرئيسية",
              style: TextStyle(fontSize: 18),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    signOut(ctx: context);
                  },
                  icon: const Icon(Icons.logout)),
              IconButton(
                  onPressed: () {
                    pushPage(context: context, page: NotificationsScreen());
                  },
                  icon: const Icon(Icons.notifications))
            ],
          ),
          bottomSheet: _bannerAd != null
              ? Container(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                )
              : SizedBox(),
          body: MarketCubit.get(context).isLoadMarket
              ? const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: homeColor,
                  ),
                )
              : MarketCubit.get(context).marketResponse.status!
                  ? MarketCubit.get(context).marketResponse.market!.status == 0
                      ? const Center(
                          child: Text(
                            "تم انشاء المتجر في انتظار الموافقة من الادارة",
                            style: TextStyle(
                                fontFamily: "pnuB",
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "متجر ${MarketCubit.get(context).marketResponse.market!.name}",
                              style: const TextStyle(
                                  fontSize: 25,
                                  fontFamily: "pnuB",
                                  color: Colors.black),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            MarketWidget(
                              title: "الطلبات",
                              onPress: () {
                                pushPage(
                                    context: context,
                                    page: OrdersScreen(
                                        MarketCubit.get(context)
                                            .marketResponse
                                            .market!
                                            .id!));
                                // click = 1;
                                //
                                // setState(() {});
                                // if (_interstitialAd != null) {
                                //   _interstitialAd!.show();
                                // } else {
                                //   pushPage(
                                //       context: context,
                                //       page: OrdersScreen(
                                //           MarketCubit.get(context)
                                //               .marketResponse
                                //               .market!
                                //               .id!));
                                // }
                              },
                              iconData: Icons.reorder,
                            ),
                            MarketWidget(
                              title: "المنتجات",
                              onPress: () {

                                pushPage(
                                    context: context,
                                    page: ProductsScreen(
                                        MarketCubit.get(context)
                                            .marketResponse
                                            .market!
                                            .id!));

                             /*   click = 2;
                                setState(() {});
                                if (_interstitialAd != null) {
                                  _interstitialAd!.show();
                                } else {
                                  pushPage(
                                      context: context,
                                      page: ProductsScreen(
                                          MarketCubit.get(context)
                                              .marketResponse
                                              .market!
                                              .id!));
                                }*/
                              },
                              iconData: Icons.bookmark_border,
                            ),
                          ],
                        )
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: DefaultButton(
                          colorText: const Color(0xffffffff),
                          height: 50,
                          text: "أضف متجرك",
                          onPress: () {
                            pushPage(
                                context: context,
                                page: const AddMarketScreen());
                          },
                          color: homeColor,
                        ),
                      ),
                    ),
        );
      },
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
  _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              if (click == 2) {
                pushPage(
                    context: context,
                    page: ProductsScreen(
                        MarketCubit.get(context).marketResponse.market!.id!));
              } else if (click == 1) {
                pushPage(
                    context: context,
                    page: OrdersScreen(
                        MarketCubit.get(context).marketResponse.market!.id!));
              }
            },
          );

          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (error) {
          print(error.message + "adds");
        },
      ),
    );
  }
}

class MarketWidget extends StatelessWidget {
  final String title;
  final IconData iconData;
  final void Function() onPress;

  MarketWidget(
      {required this.title, required this.iconData, required this.onPress});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: onPress,
      child: Container(
        height: 90,
        padding: EdgeInsets.symmetric(horizontal: 20),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Row(
            children: [
              Icon(
                iconData,
                size: 40,
              ),
              const SizedBox(
                width: 20,
              ),
              Texts(
                color: Colors.black,
                fSize: 20,
                lines: 1,
                title: title,
                familay: "pnuB",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
