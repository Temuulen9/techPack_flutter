import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:techpack_flutter/pages/register.dart';

class VerifyOtp extends StatefulWidget {
  const VerifyOtp({super.key});

  @override
  State<VerifyOtp> createState() => _VerifyOtpeState();
}

class _VerifyOtpeState extends State<VerifyOtp> {
  TextEditingController? phonenumberController;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  bool otpSent = false;
  String verificationCode = '';
  String verificationId = '';
  final _formKey = GlobalKey<FormState>();
  bool userAlrExist = false;
  bool isLoading = false;
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    phonenumberController = TextEditingController();
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
          Positioned(
            bottom: 0,
            child: verifyOtp(),
          )
        ],
      ),
    );
  }

  Widget verifyOtp() {
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
            height: 5,
          ),
          const Text(
            'Утасны дугаараа баталгаажуулна уу.',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.grey),
          ),
          const SizedBox(
            height: 20,
          ),
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  validator: formValidator,
                  keyboardType: TextInputType.phone,
                  controller: phonenumberController,
                  focusNode: focusNode,
                  onTapOutside: (PointerDownEvent event) => {focusNode.unfocus()},
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                    errorText: userAlrExist ? 'Бүртгэлтэй хэрэглэгч байна.' : null,
                    hintText: 'Утасны дугаар',
                    hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                otpSent
                    ? OtpTextField(
                        numberOfFields: 6,
                        borderColor: Theme.of(context).colorScheme.primary,
                        focusedBorderColor: Theme.of(context).colorScheme.primary,
                        showFieldAsBox: false,
                        borderWidth: 4.0,
                        onCodeChanged: (String code) {},
                        onSubmit: (String code) => otpFilled(code))
                    : Container(),
                const SizedBox(
                  height: 25,
                ),
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
                              onPressed: onPressed,
                              child: Text(otpSent ? 'Дахин илгээх' : 'Баталгаажуулах код илгээх'),
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
                              Navigator.popUntil(
                                context,
                                ModalRoute.withName('/'),
                              );
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

  void onPressed() async {
    if (_formKey.currentState!.validate()) {
      final docRef = await db.collection("users").doc(phonenumberController?.value.text).get();

      if (docRef.data() != null) {
        setState(() {
          userAlrExist = true;
        });
        return;
      }

      if (userAlrExist) {
        userAlrExist = false;
      }

      setState(() {
        isLoading = true;
      });

      await auth.verifyPhoneNumber(
        phoneNumber: phonenumberController!.value.text,
        timeout: const Duration(seconds: 120),
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(
            msg: e.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            textColor: Theme.of(context).colorScheme.onPrimary,
            fontSize: 16.0,
          );
        },
        codeSent: (String verificationId, int? resendToken) async {
          setState(() {
            otpSent = true;
            isLoading = false;
          });
          this.verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }
  }

  void otpFilled(String smsCode) async {
    try {
      setState(() {
        isLoading = true;
      });
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);

      await auth.signInWithCredential(credential);

      if (mounted) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
            msg: 'Амжилттай баталгаажлаа.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            textColor: Theme.of(context).colorScheme.onPrimary,
            fontSize: 12.0);

        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Register(
              phoneNumber: phonenumberController!.value.text,
            ),
          ),
        );
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        Fluttertoast.showToast(
            msg: error.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            textColor: Theme.of(context).colorScheme.onPrimary,
            fontSize: 12.0);
      }
    }
  }

  String? formValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Заавал бөглөх талбар.';
    }
    return null;
  }
}
