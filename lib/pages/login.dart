import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: const Text('Tech Pack'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'Утасны дугаар',
                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const TextField(
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'Нууц үг',
                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(
                height: 15,
              ),
              TextButton(
                onPressed: () => {},
                child: const Text('Нэвтрэх'),
              ),
              TextButton(
                onPressed: () => {Navigator.pushNamed(context, '/verifyOtp')},
                child: const Text('Бүртгүүлэх'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
