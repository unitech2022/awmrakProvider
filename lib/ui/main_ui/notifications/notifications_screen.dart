import 'package:awamrakeprovider/bloc/notification_cubit/notification_cubit.dart';
import 'package:awamrakeprovider/helpers/constants.dart';
import 'package:awamrakeprovider/models/notification_model.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../helpers/functions.dart';
import '../../../helpers/styles.dart';
import 'details_notifications.dart';




class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    NotificationCubit.get(context)
        .getNotifications(userId: currentUser.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationCubit, NotificationState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              elevation: 0,

              leading: IconButton(
                onPressed: () {
                  pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              backgroundColor: const Color(0xff6A644C),
              title: const Text("الاشعارات",
                  style: TextStyle(
                    fontFamily: 'pnuB',
                    fontSize: 18,
                    color: Colors.white,
                  )),
            ),
            body: NotificationCubit.get(context).getNotyLoad
                ? const Center(
                    child: CircularProgressIndicator(
                      color: homeColor,
                      strokeWidth: 3,
                    ),
                  )
                :  NotificationCubit.get(context).notifications.isEmpty?

                Center(
                  child:  const Text("لا توجد اشعارات ",
                      style: TextStyle(
                        fontFamily: 'pnuB',
                        fontSize: 18,
                        color: Colors.black,
                      )),
                )



            :RefreshIndicator(
                    onRefresh: () async {
                      NotificationCubit.get(context)
                          .getNotifications(userId: currentUser.id);
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      itemCount:
                          NotificationCubit.get(context).notifications.length,
                      itemBuilder: (_, i) {
                        NotificationModel model =
                            NotificationCubit.get(context).notifications[i];

                        print(model.image);

                        DateTime now =
                            DateTime.parse(model.createdAt.toString());
                        String formattedDate =
                            DateFormat('yyyy-MM-dd – kk:mm').format(now);
                        return Container(
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                            child: ListTile(
                              onTap: (){
                                pushPage(page: DetailsNotification(model),context: context);
                              },
                              subtitle: Text(
                                model.body!,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "pnuR",
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey),
                              ),
                                leading: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.notifications_active,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  model.name!,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "pnuB",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                trailing: Text(
                                  formattedDate,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: "pnuB",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                )));
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(),
                    ),
                  ));
      },
    );
  }
}
