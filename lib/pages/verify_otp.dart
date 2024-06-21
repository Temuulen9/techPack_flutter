import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:techpack_flutter/pages/register.dart';

class VerifyOtp extends StatefulWidget {
  const VerifyOtp({super.key});

  @override
  State<VerifyOtp> createState() => _VerifyOtpeState();
}

class _VerifyOtpeState extends State<VerifyOtp> {
  TextEditingController? phonenumberController;

  @override
  void initState() {
    super.initState();

    phonenumberController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = const Color(0xFF121212);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Бүртгүүлэх'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.phone,
                controller: phonenumberController,
                decoration: const InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'Утасны дугаар',
                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              OtpTextField(
                numberOfFields: 6,
                borderColor: primaryColor,
                focusedBorderColor: primaryColor,
                showFieldAsBox: false,
                borderWidth: 4.0,
                onCodeChanged: (String code) {},
                onSubmit: (String verificationCode) {
                  log('filled');
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextButton(
                onPressed: onPressed,
                child: const Text('Утасны дугаар баталгаажуулах'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onPressed() {
    if (phonenumberController!.value.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Register(
            phoneNumber: phonenumberController!.value.text,
          ),
        ),
      );
    }
  }
}
