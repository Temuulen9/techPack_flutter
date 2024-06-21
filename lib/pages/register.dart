import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key, this.phoneNumber});

  final String? phoneNumber;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController? phonenumberController;

  @override
  void initState() {
    super.initState();

    phonenumberController = TextEditingController(text: widget.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
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
                controller: phonenumberController,
                keyboardType: TextInputType.phone,
                enabled: false,
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
              const TextField(
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'Нууц үг баталгаажуулалт',
                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              TextButton(
                onPressed: () => {},
                child: const Text('Бүртгүүлэх'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
