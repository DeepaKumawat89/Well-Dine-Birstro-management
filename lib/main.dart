import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'SplashScreen/SplashScreen.dart';
import 'SplashScreen/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFF8B1A1A),
        scaffoldBackgroundColor: Color(0xFFFFF8F0),
        colorScheme: ColorScheme.light(
          primary: Color(0xFF8B1A1A),
          secondary: Color(0xFFD4A843),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
