import 'dart:developer';
import 'dart:io';

import 'package:chat_application/models/UIHelper.dart';
import 'package:chat_application/models/UserModel.dart';
import 'package:chat_application/pages/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CompleteProfilePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const CompleteProfilePage(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  File? imageFile;
  //CroppedFile? cropImage;
  TextEditingController nameController = TextEditingController();

  void selectImage(ImageSource source) async {
    XFile? pickedImage = await ImagePicker().pickImage(source: source);

    if (pickedImage != null) {
      imageCrop(pickedImage);
    }
  }

  void imageCrop(XFile file) async {
    //File crop = await ImageCropper().cropImage(sourcePath: file.path);
    File? croppedImage = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 20);

    //File? cropped = (await ImageCropper.cropImage(sourcePath: file.path)) as File?;
    setState(() {
      imageFile = croppedImage;
    });
  }

  void showPhotoOptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Upload a picture"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.gallery);
                  },
                  leading: const Icon(Icons.browse_gallery),
                  title: const Text("Select From Gallary"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.camera);
                  },
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("Take a Picture"),
                )
              ],
            ),
          );
        });
  }

  void checkValue() {
    String fullName = nameController.text.trim();

    if (fullName == "" || imageFile == null) {
      UiHelper.showAlertDialouge(
          context, "Data Incomplete", "Please fill all the details");
    } else {
      uploadData();
    }
  }

  void uploadData() async {
    UiHelper.showLoadingDialouge(context, "Uploading Image..");
    UploadTask task = FirebaseStorage.instance
        .ref("ProfilePictures")
        .child(widget.userModel.uid.toString())
        .putFile(imageFile!);

    TaskSnapshot snapshot = await task;

    String imageUrl = await snapshot.ref.getDownloadURL();
    String fullName = nameController.text.toString().trim();

    widget.userModel.fullName = fullName;
    widget.userModel.profilePicture = imageUrl;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap())
        .then((value) {
      log("Data uploaded!");
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return HomePage(
            userModel: widget.userModel, firebaseUser: widget.firebaseUser);
      }));
    });

    // ignore: use_build_context_synchronously
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            CupertinoButton(
              onPressed: () {
                showPhotoOptions();
              },
              child: CircleAvatar(
                radius: 60,
                backgroundImage:
                    (imageFile != null) ? FileImage(imageFile!) : null,
                child:
                    (imageFile == null) ? const Icon(Icons.contact_page) : null,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextField(
                controller: nameController,
                decoration: const InputDecoration(
                    labelText: "Name", hintText: "Enter Your Full Name")),
            const SizedBox(
              height: 15.0,
            ),
            CupertinoButton(
                child: Text(
                  "Submit",
                  style: TextStyle(
                      fontSize: 20,
                      //color: Theme.of(context).colorScheme.secondary,
                      color: Theme.of(context).colorScheme.secondary),
                ),
                onPressed: () {
                  checkValue();
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: ((context) => const HomePage())));
                })
          ],
        ),
      )),
    );
  }
}
