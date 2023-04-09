import 'dart:convert';

import 'package:awamrakeprovider/ui/main_ui/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../../helpers/constants.dart';
import '../../helpers/functions.dart';
import '../../helpers/helper_function.dart';
import '../../models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of<AuthCubit>(context);
  bool isCheckedUserName = false;

  checkUserName({phone}) async {
    isCheckedUserName = true;
    emit(CheckUserAuthStateLoad());

    var request =
        http.MultipartRequest('POST', Uri.parse(baseUrl + checkUserNamePoint));
    request.fields.addAll({'phone': phone});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonsDataString = await response.stream.bytesToString();
      final jsonData = jsonDecode(jsonsDataString);
      printFunction(jsonData);
      isCheckedUserName = false;

      emit(CheckUserAuthStateSuccess(
          phone: phone, code: jsonData["code"], status: jsonData["status"]));
    } else {
      isCheckedUserName = false;
      printFunction("errrrrrrrrrror");
      emit(CheckUserAuthStateError());
    }
  }

  bool isValidate = false;

  validateUser({username, email, fullName}) async {
    emit(ValidateAuthStateLoad());

    var request =
        http.MultipartRequest('POST', Uri.parse(baseUrl + validatePoint));
    request.fields.addAll({'email': email, 'userName': username});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonsDataString = await response.stream.bytesToString();
      // final jsonData = jsonDecode(jsonsDataString);
      printFunction(jsonsDataString);

      registerUser(email: email, userName: username, fullName: fullName);
    } else if (response.statusCode == 400) {
      String jsonsDataString = await response.stream.bytesToString();
      // final jsonData = jsonDecode(jsonsDataString);
      printFunction(jsonsDataString);
      emit(ValidateAuthStateError(jsonsDataString));
    } else {
      printFunction(response.statusCode);
      emit(ValidateAuthStateError("errrrrrrrrrror"));
    }
  }

  bool isRegisterLoad = false;

  registerUser({fullName, email, userName, role}) async {
    isRegisterLoad = true;
    emit(RegisterAuthStateLoad());

    var request =
        http.MultipartRequest('POST', Uri.parse(baseUrl + registerPoint));
    request.fields.addAll({
      'fullName': fullName,
      'email': email,
      'userName': userName,
      'knownName': 'askdkalshkjsa',
      'Role': role,
      'password': 'Abc123@',
      'DeviceFCM': tokenFCM
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonsDataString = await response.stream.bytesToString();
      final jsonData = jsonDecode(jsonsDataString);
      printFunction(jsonData);
      isRegisterLoad = false;
      emit(
          RegisterAuthStateSuccess(code: jsonData["code"], userName: userName));
    }if (response.statusCode == 500) {
      printFunction(response.reasonPhrase);
      isRegisterLoad = false;
      emit(ValidateAuthStateError("الرقم موجود بالفعل "));
    }

    else {
      printFunction(response.reasonPhrase);
      isRegisterLoad = false;
      emit(ValidateAuthStateError("الحساب غير موجود  "));

    }
  }

  UserModel user = UserModel();
  bool isLoginLoad = false;

  loginUser({code, userName, context}) async {
    isLoginLoad = true;
    emit(LoginAuthStateLoad());

    var request =
        http.MultipartRequest('POST', Uri.parse(baseUrl + loginPoint));


      request.fields.addAll({'code': "$code", 'userName': userName});


    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonsDataString = await response.stream.bytesToString();
      final jsonData = jsonDecode(jsonsDataString);
      printFunction(jsonData);
      UserResponse userResponse = UserResponse.fromJson(jsonData);

      // printFunction("currentUser${userResponse.token}");

      printFunction(userResponse.user!.role);
      if (userResponse.user!.role == "provider") {
        token = "Bearer " + userResponse.token!;
        currentUser = user = userResponse.user!;
        updateDeviceToken(userId: userResponse.user!.id!).then((value)async{


          await saveToken();
          pushPage(page: HomeScreen(), context: context);
        });



      } else {
        HelperFunction.slt.notifyUser(
            context: context, color: Colors.red, message: "الحساب غير موجود");
      }
      // if(data['driver']!=null) currentUser.driver = Driver.fromJson(data['driver']);

      isLoginLoad = false;
      emit(LoginAuthStateSuccess(userResponse));
    }



    else {

      isLoginLoad = false;
      print(response.statusCode);
      emit(LoginAuthStateError());
    }
  }

  bool isChecked = false;

  changeCheckBox(bool checked) {
    isChecked = checked;
    printFunction(isChecked);
    emit(ChangeCheckBox());
  }

  int currentStatus = 0;

  currentStatusState(int newStatus) {
    currentStatus = newStatus;
    printFunction(currentStatus);
    emit(ChangeCheckBox());
  }

Future updateDeviceToken({token, userId}) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse(baseUrl + '/auth/update-deviceToken'));
    request.fields.addAll({'UserId': userId, 'Token': tokenFCM});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      currentUser.deviceToken=tokenFCM;
      print("updatedTokenUsre"+response.statusCode.toString());
    } else {
      print("ErrorUpdatedToken"+response.statusCode.toString());
    }
  }



}
