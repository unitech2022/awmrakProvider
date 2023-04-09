import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../bloc/auth_cubit/auth_cubit.dart';
import '../../../helpers/functions.dart';
import '../../../helpers/helper_function.dart';
import '../../../helpers/styles.dart';
import '../../../widgets/Buttons.dart';
import '../home_screen/home_screen.dart';

import '../signup_screen/signup_screen.dart';


class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String userName = "";

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
  listener: (context, state) {
    // if (state is CheckUserAuthStateSuccess) {
    //   printFunction( "${state.status}" );
    //
    //   if (state.status == 0) {
    //     // Future.delayed( Duration.zero, () {
    //     //   pushPage(
    //     //       page: SignUpScreen(state.phone), context: context);
    //     // });
    //
    //
    //   } else {
    //     Future.delayed(Duration.zero, () {
    //       pushPage(
    //           page: OtpScreen(phone: state.phone, code: state.code),
    //           context: context);
    //     });
    //     //
    //   }
    // }
    // if(state is LoginAuthStateSuccess){
    //
    //   Future.delayed(Duration.zero,(){
    //     replacePage(context: context,page: const HomeScreen());
    //   });
    // }
  },
  builder: (context, state) {



    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 120,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    "assets/images/logo_provider.png",
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(
                  height: 70,
                ),
                Card(
                  color: const Color(0xffFEEE00),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 2.5,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        const Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                            fontFamily: 'pnuB',
                            fontSize: 32,
                            color: Colors.black,
                            height: 1.40625,
                          ),
                          textHeightBehavior: TextHeightBehavior(
                              applyHeightToFirstAscent: false),
                          textAlign: TextAlign.center,
                        ),
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
                        AuthCubit.get(context).isLoginLoad
                            ? const SizedBox(
                                height: 50,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            : DefaultButton(
                                colorText: const Color(0xffffffff),
                                height: 50,
                                text: "دخول",
                                onPress: () {
                                  if (userName.trim().length == 14 &&
                                      userName.trim().startsWith("+20") &&
                                      userName.isNotEmpty) {
                                    AuthCubit.get(context)
                                        .loginUser(userName: userName,context: context);
                                  } else {
                                    HelperFunction.slt.notifyUser(
                                        context: context,
                                        message: "رقم الهاتف غير صحيح",
                                        color: Colors.black45);
                                  }
                                },
                                color: homeColor,
                              ),
                        const SizedBox(
                          height: 30,
                        ),
                        DefaultButton(
                          colorText: const Color(0xffffffff),
                          
                          height: 50,
                          text: "انشاء حساب جديد",
                          onPress: () {
                          pushPage(context: context,page: SignUpScreen());
                          },
                          color: homeColor.withOpacity(.5),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .2,
                )
              ],
            ),
          ),
        ),
      ),
    );
  },
);
  }

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
        style: const TextStyle(
            fontFamily: "pnuB", fontSize: 15, color: Colors.black),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          hintText: "أدخل رقم الهاتف ",
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      );
}
