import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'SplashScreen/SplashScreen.dart';
import 'SplashScreen/firebase_options.dart';

void main() async {
  runApp(MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: New(),
      // home: AdminPage(),

         home: SplashScreen(),
      // home: FullDescriptionOfRequest(),
      // home: LoginScreen(),
    );
  }
}














