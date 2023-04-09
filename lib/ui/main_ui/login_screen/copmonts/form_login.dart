
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



import '../../../../bloc/auth_cubit/auth_cubit.dart';
import '../../../../helpers/functions.dart';
import '../../../../helpers/helper_function.dart';
import '../../../../helpers/styles.dart';
import '../../../../widgets/Buttons.dart';
import '../../otp_screen/otp_screen.dart';


class FormLogin extends StatefulWidget {
  @override
  _FormLoginState createState() => _FormLoginState();
}

 String userName="";

class _FormLoginState extends State<FormLogin> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AuthCubit, AuthState>(
  listener: (context, state) {

  },
  builder: (context, state) {
    if (state is CheckUserAuthStateSuccess) {
      printFunction( "${state.status}" );

      if (state.status == 0) {
        // Future.delayed( Duration.zero, () {
        //   pushPage(
        //       page: SignUpScreen(state.phone), context: context);
        // });
        // //

      } else {
        Future.delayed(Duration.zero, () {
          pushPage(
              page: OtpScreen(phone: state.phone, code: state.code),
              context: context);
        });
        //
      }
    }
    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              buildTextFieldPhone(),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 20,
              ),
           AuthCubit.get(context).isCheckedUserName?const SizedBox(
             height: 50,
             child: Center(
               child: CircularProgressIndicator(
                 color: Colors.black,
               ),
             ),
           ):   DefaultButton(
                colorText: const Color(0xffffffff),
                height: 50,
                text: "دخول".tr(),
                onPress: () {
                  if (userName.trim().length == 14&&userName.trim().startsWith("+20")&&userName.isNotEmpty) {

                     AuthCubit.get(context).checkUserName(phone: userName);

                  } else {
                    HelperFunction.slt.notifyUser(
                        context: context,
                        message: "رقم الهاتف غير صحيح".tr(),
                        color: Colors.black45);
                  }
                },
                color: homeColor,
              ),

              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ));
  },
);
  }

  // _onComplete(status, userCode) {
  //   featchedCode = userCode;
  //   if (status == 1) {
  //     replacePage(
  //         context: context,
  //         page: ValidateNumberScreen(
  //           username: userName,
  //           code: userCode,
  //         ));
  //   } else {
  //     pushPage(context: context, page: CompleteAccountScreen());
  //   }
  // }

  TextFormField buildTextFieldPhone() => TextFormField(
        keyboardType: TextInputType.phone,
        inputFormatters: [
          FilteringTextInputFormatter.deny(
            RegExp("[٠-٩]"),
          ),
        ],

        maxLength: 11,
        onChanged: (value) {
          userName = "+20" + value.toString();
        },
        validator: (value) {
          return null;
        },
        textAlign: TextAlign.center,
        style: const TextStyle(fontFamily: "pnuB", fontSize: 15, color: Colors.black),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          hintText: "أدخل رقم الهاتف ".tr(),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      );
}
