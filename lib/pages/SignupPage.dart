import 'package:chat_application/models/UIHelper.dart';
import 'package:chat_application/models/UserModel.dart';
import 'package:chat_application/pages/CompleteProfilePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cpasswordController = TextEditingController();

  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cpassword = cpasswordController.text.trim();

    if (email == "" || password == "" || cpassword == "") {
      UiHelper.showAlertDialouge(
          context, "Fields incomplete", "Please fill in all the details");
    } else if (password != cpassword) {
      UiHelper.showAlertDialouge(
          context, "Password Error", "Passwords not matched!");
    } else {
      signUp(email, password);
    }
  }

  void signUp(String email, String password) async {
    UserCredential? credentials;

    UiHelper.showLoadingDialouge(context, "Signing up..");

    try {
      credentials = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      UiHelper.showAlertDialouge(
          context, "An error occurred", ex.message.toString());
    }

    if (credentials != null) {
      String uid = credentials.user!.uid;
      UserModel newUser = UserModel(
          uid: uid, userEmail: email, fullName: "", profilePicture: "");
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(newUser.toMap())
          .then((value) {
        //New User Created!!!!

        Navigator.popUntil(context, (route) => route.isFirst);

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return CompleteProfilePage(
              userModel: newUser, firebaseUser: credentials!.user!);
        }));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text("Sign Up",
                style: TextStyle(
                    fontSize: 40,
                    color: Theme.of(context).colorScheme.secondary)),
            const SizedBox(
              height: 10.0,
            ),
            TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    labelText: "Email", hintText: "Enter Your Email")),
            const SizedBox(
              height: 10.0,
            ),
            TextField(
              obscureText: true,
              controller: passwordController,
              textCapitalization: TextCapitalization.none,
              decoration: const InputDecoration(
                  labelText: "Password", hintText: "Create a password"),
            ),
            const SizedBox(
              height: 10.0,
            ),
            TextField(
              obscureText: true,
              textCapitalization: TextCapitalization.none,
              controller: cpasswordController,
              decoration: const InputDecoration(
                labelText: "Confirm Password",
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            CupertinoButton(
              onPressed: () {
                checkValues();
                //   Navigator.push(context, MaterialPageRoute(builder: (context) {
                //     return const CompleteProfilePage();
                //   }));
                //
              },
              color: Theme.of(context).colorScheme.secondary,
              child: const Text("Sign Up"),
            ),
          ],
        ),
      )),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text("Already have an account?"),
          CupertinoButton(
              child: const Text(
                "Login",
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () {
                Navigator.pop(context);
              })
        ]),
      ),
    );
  }
}
