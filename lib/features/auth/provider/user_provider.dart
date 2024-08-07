// ignore_for_file: use_build_context_synchronously

import 'package:crop_clasifier/core/views/custom_dialog.dart';
import 'package:crop_clasifier/features/auth/data/user_model.dart';
import 'package:crop_clasifier/features/auth/services/auth_services.dart';
import 'package:crop_clasifier/features/auth/views/login_page.dart';
import 'package:crop_clasifier/features/home/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userProvider = StateNotifierProvider<UserProvider, UserModel>((ref) {
  return UserProvider();
});

class UserProvider extends StateNotifier<UserModel> {
  UserProvider()
      : super(UserModel(id: '', name: '', email: '', password: '', phone: ''));

  void setUser(UserModel user) {
    state = user;
  }

  void clearUser() {
    state = UserModel(id: '', name: '', email: '', password: '', phone: '');
  }

  void setPassword(String? password) {
    state = state.copyWith(password: password);
  }

  void setEmail(String? email) {
    state = state.copyWith(email: email);
  }

  void loginUser(BuildContext context) async {
    CustomDialogs.loading(
      message: 'Logging in...',
    );
    var data = await AuthServices.signIn(state.email, state.password);
    if (data != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('user', data.toJson());
      state = data;
      CustomDialogs.dismiss();
      CustomDialogs.toast(message: 'Login successful');
      //pop to home
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(message: 'Login failed. Check email and password');
    }
  }

  void register(BuildContext context) async {
    CustomDialogs.loading(
      message: 'Registering...',
    );
    var data = await AuthServices.createUser(state);
    if (data) {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setString('user', state.toJson());
      CustomDialogs.dismiss();
      CustomDialogs.toast(message: 'Registration successful',type: DialogType.success);
      //pop to home
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(message: 'Registration failed. Try again',type: DialogType.error);
    }
  }

  void setName(String? name) {
    state = state.copyWith(name: name);
  }

  void setPhone(String? phone) {
    state = state.copyWith(phone: phone);
  }
}

final userFutureProvider = FutureProvider<UserModel>((ref) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var user = prefs.getString('user');
  if (user != null) {
    var data = UserModel.fromJson(user);
    ref.read(userProvider.notifier).setUser(data);
    return data;
  } else {
    return UserModel(id: '', name: '', email: '', password: '', phone: '');
  }
});
