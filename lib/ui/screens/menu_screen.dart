import 'package:caro2/common/game_const.dart';
import 'package:caro2/ui/widgets/custom_flat_button.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _buildListMenu = Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(top: 20.0, right: 15.0, left: 15.0),
              child: CustomFlatButton(
                title: "Find an oponent",
                fontSize: 22,
                fontWeight: FontWeight.w700,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.of(context).pushNamed(ARENA);
                },
                splashColor: Colors.black12,
                borderColor: Colors.white,
                borderWidth: 2,
                color: Colors.orangeAccent,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 20.0, right: 15.0, left: 15.0),
              child: CustomFlatButton(
                title: "Play with friends",
                fontSize: 22,
                fontWeight: FontWeight.w700,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.of(context).pushNamed(ARENA);
                },
                splashColor: Colors.black12,
                borderColor: Colors.white,
                borderWidth: 2,
                color: Colors.orangeAccent,
              ),
            ),
          ],
        ),
      ),
    );
    return MaterialApp(
      title: 'Tictac toe game',
      home: Scaffold(
        appBar: AppBar(
          title: Text('App bar'),
        ),
        body: _buildListMenu,
      ),
    );
  }
}
