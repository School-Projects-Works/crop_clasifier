import 'package:crop_clasifier/core/views/custom_button.dart';
import 'package:crop_clasifier/core/views/custom_input.dart';
import 'package:crop_clasifier/features/auth/views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../generated/assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/text_styles.dart';
import '../provider/user_provider.dart';

class RegistrationPage extends ConsumerStatefulWidget {
  const RegistrationPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends ConsumerState<RegistrationPage> {

  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    var style = CustomTextStyles();
    var notifier = ref.read(userProvider.notifier);
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    Assets.imagesLogoLight,
                    width: 70,
                    height: 70,
                  ),
                  Text(
                    'Registration',
                    style: style.titleStyle(color: primaryColor,fontSize: 25),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(
                    color: secondaryColor,
                    thickness: 3,
                    endIndent: 40,
                    indent: 40,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //name 
                  CustomTextFields(
                    label: 'Name',
                    prefixIcon: Icons.person,
                    validator: (name) {
                      if (name == null || name.isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                    onSaved: (name) {
                      notifier.setName(name);
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFields(
                    label: 'Email',
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (email) {
                      if (email == null || email.isEmpty) {
                        return 'Email is required';
                      } else if (!email.contains('@') && !email.contains('.')) {
                        return 'Invalid email';
                      }
                      return null;
                    },
                    onSaved: (email) {
                      notifier.setEmail(email);
                    },
                  ),
                  //phone
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFields(
                    label: 'Phone',
                    prefixIcon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    validator: (phone) {
                      if (phone == null || phone.isEmpty) {
                        return 'Phone is required';
                      } else if (phone.length < 10) {
                        return 'Phone must be at least 10 characters';
                      }
                      return null;
                    },
                    onSaved: (phone) {
                      notifier.setPhone(phone);
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFields(
                    label: 'Password',
                    prefixIcon: Icons.lock,
                    obscureText: _isObscure,
                    suffixIcon: IconButton(
                      icon: Icon(
                          _isObscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                    validator: (password) {
                      if (password == null || password.isEmpty) {
                        return 'Password is required';
                      } else if (password.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    onSaved: (password) {
                      notifier.setPassword(password);
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    text: 'Registaer',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        //login user
                        notifier.register(context);
                      }
                    },
                    radius: 10,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an Account? ',
                        style: style.bodyStyle(),
                      ),
                      TextButton(
                        onPressed: () {
                          //open register page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        },
                        child: Text(
                          'Login',
                          style: style.bodyStyle(color: primaryColor),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
