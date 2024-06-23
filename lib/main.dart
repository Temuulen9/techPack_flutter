import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:techpack_flutter/firebase_options.dart';
import 'package:techpack_flutter/pages/homepage.dart';
import 'package:techpack_flutter/pages/login.dart';
import 'package:techpack_flutter/pages/verify_otp.dart';
import 'package:techpack_flutter/user.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final User user = User.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tech Pack',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/verifyOtp': (context) => const VerifyOtp(),
        '/homepage': (context) => const HomePage(),
      },
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff53c499)),
        useMaterial3: true,
      ),
    );
  }
}
