import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:techpack_flutter/user.dart';

class Register extends StatefulWidget {
  const Register({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController? phonenumberController;
  TextEditingController? nameController;
  TextEditingController? passwordController;
  TextEditingController? passwordConfirmController;

  FirebaseFirestore db = FirebaseFirestore.instance;
  final User user = User.instance;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    initControls();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: const Color(0xff53c499),
            child: Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 8),
              child: Column(
                children: [
                  const Text(
                    'Tech Pack',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Image.asset('assets/images/loginDelivery.png'),
                ],
              ),
            ),
          ),
          Positioned(bottom: 0, child: registerForm()),
        ],
      ),
    );
  }

  Widget registerForm() {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          )),
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Бүртгүүлэх',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 30,
          ),
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: phonenumberController,
                  keyboardType: TextInputType.phone,
                  enabled: false,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                    hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: formValidator,
                  controller: nameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                    hintText: 'Нэр',
                    hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: passwordInputValidator,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                    hintText: 'Нууц үг',
                    hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
                  ),
                  obscureText: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: passwordConfirmInputValidator,
                  controller: passwordConfirmController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                    hintText: 'Нууц үг баталгаажуулалт',
                    hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                isLoading
                    ? LoadingAnimationWidget.inkDrop(
                        color: Theme.of(context).colorScheme.primary,
                        size: 35,
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: FilledButton(
                              onPressed: register,
                              child: const Text('Бүртгүүлэх'),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Divider(),
                          const SizedBox(
                            height: 10,
                          ),
                          TextButton(
                            onPressed: () {
                              _formKey.currentState?.reset();
                              Navigator.pop(context);
                            },
                            child: const Text('Буцах'),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> register() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          isLoading = true;
        });
        var salt = await FlutterBcrypt.saltWithRounds(rounds: 10);

        var hashPw = await FlutterBcrypt.hashPw(
          password: passwordController!.value.text,
          salt: salt,
        );

        final user = <String, dynamic>{"phoneNumber": phonenumberController!.value.text, "password": hashPw, "name": nameController!.value.text, "salt": salt};

        db.collection("users").doc(phonenumberController!.value.text).set(user);
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.deepPurpleAccent,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } finally {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
          msg: "Бүртгэл амжилттай",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.deepPurpleAccent,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        user.login(name: nameController!.value.text, phoneNumber: phonenumberController!.value.text);
        if (mounted) {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/homepage');
        }
      }
    }
  }

  String? formValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Заавал бөглөх талбар.';
    }
    return null;
  }

  String? passwordConfirmInputValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Заавал бөглөх талбар.';
    }
    if (passwordController!.value.text != value) {
      return 'Нууц үг ялгаатай байна';
    }
    return null;
  }

  String? passwordInputValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Заавал бөглөх талбар.';
    }
    if (passwordConfirmController!.value.text != value) {
      return 'Нууц үг ялгаатай байна';
    }
    return null;
  }

  void initControls() {
    phonenumberController = TextEditingController(text: widget.phoneNumber);
    nameController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmController = TextEditingController();
  }
}
