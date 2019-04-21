import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String userID;
  final String userName;
  final String email;
  final String profilePictureURL;
  final String photoUrl;
  final String pushId;
  List<int> playerList;
  User({
    this.userID,
    this.userName,
    this.email,
    this.profilePictureURL,this.photoUrl,this.pushId
  });

  Map<String, Object> toJson() {
    return {
      'userID': userID,
      'firstName': userName,
      'email': email == null ? '' : email,
      'profilePictureURL': profilePictureURL,
      'appIdentifier': 'flutter-onboarding'
    };
  }

  factory User.fromJson(Map<String, Object> doc) {
    User user = new User(
      userID: doc['userID'],
      userName: doc['firstName'],
      email: doc['email'],
      profilePictureURL: doc['profilePictureURL'],
    );
    return user;
  }

  factory User.fromDocument(DocumentSnapshot doc) {
    return User.fromJson(doc.data);
  }
}
