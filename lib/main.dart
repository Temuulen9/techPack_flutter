import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:techpack_flutter/firebase_options.dart';
import 'package:techpack_flutter/pages/login.dart';
import 'package:techpack_flutter/pages/verify_otp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tech Pack',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/verifyOtp': (context) => const VerifyOtp(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
