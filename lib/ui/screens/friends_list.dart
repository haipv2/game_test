import 'package:caro2/common/game_const.dart';
import 'package:caro2/models/user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FriendList extends StatefulWidget {
  @override
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  List<User> _listUser = List<User>();

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void fetchUsers() async {
    var snapshot =
        await FirebaseDatabase.instance.reference().child(USERS).once();

    Map<String, dynamic> users = snapshot.value.cast<String, dynamic>();
    users.forEach((userId, userMap) {
      User user = parseUser(userId, userMap);
      setState(() {
        _listUser.add(user);
      });
    });
  }

  User parseUser(String userId, Map<dynamic, dynamic> user) {
    String name, photoUrl, pushId, email;
    user.forEach((key, value) {
      if (key == NAME) {
        name = value as String;
      }
      if (key == PHOTO_URL) {
        photoUrl = value as String;
      }
      if (key == PUSH_ID) {
        pushId = value as String;
      }
      if (key == EMAIL) {
        email = value as String;
      }
    });
    return User(
        userID: userId, email: email, photoUrl: photoUrl, pushId: pushId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact list'),
      ),
      body: ListView.builder(
        itemCount: _listUser.length,
        itemBuilder: _buildListContact,
      ),
    );
  }

  Widget _buildListContact(BuildContext context, int index) {
    return Container(
      height: 50.0,
      child: InkWell(
        onTap: () {
          Scaffold.of(context).showSnackBar(SnackBar(
              content:
                  Text('Sent an invitation to ${_listUser[index].userName}')));
          invite(_listUser[index]);
        },
        child: Container(
          padding: EdgeInsets.all(16.0),
          alignment: Alignment.centerLeft,
          child: Text(
            '${_listUser[index].userName}',
            style: TextStyle(fontSize: 14.0),
          ),
        ),
      ),
    );
  }

  void invite(User user) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userName = preferences.getString(USER_NAME);
    var pushId = preferences.getString(PUSH_ID);
    var userId = preferences.getString(USER_ID);
    var base = BASE_ICLUOD_FUNC_URL;
    String dataURL =
        '$base/sendNotification2?to=${user.pushId}&fromPushId=$pushId&fromId=$userId&fromName=$userName&type=invite';
    print(dataURL);
    String gameId = '$userId-${user.userID}';
    FirebaseDatabase.instance
        .reference()
        .child(GAME_TABLE)
        .child(gameId)
        .set(null);
    http.Response response = await http.get(dataURL);
  }
}
