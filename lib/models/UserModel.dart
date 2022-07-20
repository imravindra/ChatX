class UserModel {
  String? uid;
  String? fullName;
  String? userEmail;
  String? profilePicture;

  UserModel({this.uid, this.fullName, this.userEmail, this.profilePicture});

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map["userID"];
    fullName = map["fullName"];
    userEmail = map['userEmail'];
    profilePicture = map["profilePicture"];
  }

  Map<String, dynamic> toMap() {
    return {
      "userID": uid,
      "fullName": fullName,
      "userEmail": userEmail,
      "profilePicture": profilePicture
    };
  }
}
