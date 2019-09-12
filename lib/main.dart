import 'package:flutter/material.dart';

import 'package:Fluttergram/src/bloc/provider.dart';
import 'package:Fluttergram/src/pages/home_page.dart';
import 'package:Fluttergram/src/pages/login_page.dart';
import 'package:Fluttergram/src/pages/product_page.dart';
import 'package:Fluttergram/src/pages/sign-up_page.dart';
import 'package:Fluttergram/src/settings/user_preferences.dart';

void main() async {
  final prefs = UserPreferences();
  await prefs.initPrefs();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'login',
        routes: {
          'login'  : (BuildContext context) => LoginPage(),
          'home'   : (BuildContext context) => HomePage(),
          'product': (BuildContext context) => ProductPage(),
          'sign-in': (BuildContext context) => SignUpPage()
        },
        theme: ThemeData(
          primaryColor: Colors.deepPurple
        ),
      ),
    );
  }
}
