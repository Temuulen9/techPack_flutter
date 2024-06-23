import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:techpack_flutter/user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  late TextEditingController phonenumberController;
  late TextEditingController passwordController;
  final User user = User.instance;
  final _formKey = GlobalKey<FormState>();
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();

  bool userNotExist = false;
  bool wrongPassword = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    initControls();
  }

  @override
  void dispose() {
    focusNode1.dispose();
    focusNode2.dispose();
    super.dispose();
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
          Positioned(bottom: 0, child: loginForm()),
        ],
      ),
    );
  }

  Widget loginForm() {
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
            'Нэвтрэх',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Тавтай морилно уу. Утасны дугаар, нууц үгээ оруулан нэвтэрнэ үү.',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.grey),
          ),
          const SizedBox(
            height: 30,
          ),
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  focusNode: focusNode1,
                  validator: formValidator,
                  controller: phonenumberController,
                  onTapOutside: (PointerDownEvent event) => {focusNode1.unfocus()},
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                    errorText: userNotExist ? 'Бүртгэлгүй хэрэглэгч байна.' : null,
                    hintText: 'Утасны дугаар',
                    hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  focusNode: focusNode2,
                  onTapOutside: (PointerDownEvent event) => {focusNode2.unfocus()},
                  validator: formValidator,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: passwordController,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                      errorText: wrongPassword ? 'Нууц үг буруу байна.' : null,
                      hintText: 'Нууц үг',
                      hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey)),
                  obscureText: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    isLoading
                        ? LoadingAnimationWidget.inkDrop(
                            color: Theme.of(context).colorScheme.primary,
                            size: 35,
                          )
                        : SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: FilledButton(
                              onPressed: login,
                              child: const Text('Нэвтрэх'),
                            ),
                          ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 15,
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _formKey.currentState?.reset();
                        });
                        focusNode1.unfocus();
                        focusNode2.unfocus();
                        resetValidation();
                        Navigator.pushNamed(context, '/verifyOtp');
                      },
                      child: const Text('Бүртгүүлэх'),
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

  void login() async {
    resetValidation();
    if (_formKey.currentState!.validate()) {
      final docRef = await db.collection("users").doc(phonenumberController.value.text).get();

      if (docRef.data() == null) {
        setState(() {
          userNotExist = true;
        });
        return;
      }

      setState(() {
        isLoading = true;
      });
      final userData = docRef.data();

      var hashPw = await FlutterBcrypt.hashPw(
        password: passwordController.value.text,
        salt: userData?['salt'],
      );

      if (hashPw == userData?['password']) {
        user.login(name: userData?['name'], phoneNumber: userData?['phoneNumber']);

        if (mounted) {
          _formKey.currentState?.reset();
          phonenumberController.text = '';
          passwordController.text = '';
          resetValidation();
          Navigator.pushNamed(context, '/homepage');
        }
      } else {
        setState(() {
          wrongPassword = true;
        });
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  void resetValidation() {
    setState(() {
      userNotExist = false;
      wrongPassword = false;
    });
  }

  String? formValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Заавал бөглөх талбар.';
    }
    return null;
  }

  void initControls() {
    phonenumberController = TextEditingController(text: '');
    passwordController = TextEditingController(text: '');
  }
}
