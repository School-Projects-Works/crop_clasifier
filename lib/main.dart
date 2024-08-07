import 'package:crop_clasifier/features/auth/views/login_page.dart';
import 'package:crop_clasifier/features/home/views/home_page.dart';
import 'package:crop_clasifier/firebase_options.dart';
import 'package:crop_clasifier/utils/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/auth/data/user_model.dart';
import 'features/auth/provider/user_provider.dart';
import 'generated/assets.dart';
import 'utils/text_styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return MaterialApp(
        title: 'Crop Classifier',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
          useMaterial3: true,
        ),
        builder: FlutterSmartDialog.init(),
        home: FutureBuilder(
          future: getUserData(ref),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  title: Image.asset(
                    Assets.imagesLogoLight,
                    width: 70,
                    height: 70,
                  ),
                ),
                body: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text('Errorc:${snapshot.error}'),
                ),
              );
            }else{
              var user = ref.watch(userProvider);

              if (user.id.isEmpty) {
                return const LoginPage();
              } else {
                return const HomePage();
              }
            }
            
          },
        ));
  }

  Future<UserModel?> getUserData(WidgetRef ref) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //remove
      //prefs.remove('user');
      var user = prefs.getString('user');
      if (user != null) {
        ref.read(userProvider.notifier).setUser(UserModel.fromJson(user));
        //navigate to home
        return UserModel.fromJson(user);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
