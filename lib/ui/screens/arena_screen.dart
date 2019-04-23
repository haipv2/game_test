import 'dart:math';

import 'package:caro2/models/user.dart';
import 'package:caro2/ui/screens/cell.dart';
import 'package:caro2/ui/screens/game_item.dart';
import 'package:caro2/common/game_const.dart';
import 'package:caro2/ui/widgets/game_dialog.dart';
import 'package:flutter/material.dart';
import 'package:caro2/business/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ArenaScreen extends StatefulWidget {
  final FirebaseUser firebaseUser;
  User player1 = User(userID: '1',userName: 'player1Name');
  User player2 = User(userID: '2',userName: 'player2Name');
  ArenaScreen(this.firebaseUser);

  @override
  _ArenaScreenState createState() => _ArenaScreenState();
}

class _ArenaScreenState extends State<ArenaScreen> {
  List<GameItem> itemlist;
  List<int> player1List;
  List<int> player2List;
  var activePlayer;

  @override
  void initState() {
    super.initState();
    itemlist = doInit();
  }

  List<GameItem> doInit() {
    player1List = new List();
    player2List = new List();
    activePlayer = 1;

    List<GameItem> gameItems = new List();
    for (var i = 0; i < SUM; i++) {
      gameItems.add(new GameItem(id: i));
    }
    return gameItems;
  }

  @override
  Widget build(BuildContext context) {
    Widget playerInfo = Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildPlayer(widget.player1),
        _buildText('VS'),
        _buildPlayer(widget.player2),
      ],
    ));

    return new Scaffold(
        appBar: AppBar(

        ),
        body: Container(
          decoration: BoxDecoration(color: Colors.red),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              playerInfo,
              new Expanded(
                child: new GridView.builder(
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: COLUMNS,
                        childAspectRatio: 1,
                        crossAxisSpacing: 1.5,
                        mainAxisSpacing: 0.5),
                    itemCount: itemlist.length,
                    itemBuilder: (context, i) => new SizedBox(
                          width: 20.0,
                          height: 20.0,
                          child: new RaisedButton(
                            padding: const EdgeInsets.all(1.0),
                            onPressed: itemlist[i].enabled
                                ? () => playGame(itemlist[i], i)
                                : null,
                            child: itemlist[i],
                            color: itemlist[i].bg,
                            disabledColor: itemlist[i].bg,
                          ),
                        )),
              ),
//              new RaisedButton(
//                child: new Text(
//                  'Reset',
//                  style: new TextStyle(color: Colors.white, fontSize: 20.0),
//                ),
//                color: Colors.red,
//                padding: const EdgeInsets.all(20.0),
//                onPressed: resetGame,
//              )
            ],
          ),
        ));
  }

  Widget buildCell(BuildContext context, int i, activePlayer) {
    return Cell(context, i, activePlayer, null);
  }

  void resetGame() {
    if (Navigator.canPop(context)) Navigator.pop(context);
    setState(() {
      itemlist = doInit();
    });
  }

  void playGame(GameItem item, int i) {
    setState(() {
//      var imageUrl = '${GameConst.ASSETS_IMAGE}''${activePlayer}.png';
      var imageUrl = 'assets/images/p$activePlayer.png';
      var newGameItem = [GameItem(id: i, image: Image.asset(imageUrl))];
      if (activePlayer == 1) {
        item.text = "${item.id}";
        item.bg = Colors.red;
        itemlist.replaceRange(i, i + 1, newGameItem);
//        item.icon = Icons.ac_unit;
        activePlayer = 2;
        player1List.add(item.id);
      } else {
        item.text = '${item.id}';
        itemlist.replaceRange(i, i + 1, newGameItem);
//        item.icon = Icons.insert_emoticon;
//        item.bg = Colors.black;
        activePlayer = 1;
        player2List.add(item.id);
      }
      item.enabled = false;
      if (player1List.length > 4 || player2List.length > 4) {
        int winner = checkWinner(item.id);
        if (winner == 0) {
          if (itemlist.every((p) => p.text != "")) {
            showDialog(
                context: context,
                builder: (_) =>
                    new WinnerDialog('Game title', 'Reset game', resetGame));
          }
          /*else {
          activePlayer == 2 ? autoPlay() : null;
        }*/
        }
      }
    });
  }

  int checkWinner(id) {
    var winner = 0;
    player1List.sort((i1, i2) => i1 - i2);
    player2List.sort((i1, i2) => i1 - i2);
    //check user 1 win
    if (activePlayer == 2) {
      winner = doReferee(player1List, 1, id);
      //check user 2 win
    } else {
      winner = doReferee(player2List, 2, id);
    }

    if (winner != 0) {
      if (winner == 1) {
        showDialog(
            context: context,
            builder: (_) => new WinnerDialog("Player 1 Won",
                "Press the reset button to start again.", resetGame));
      } else {
        showDialog(
            context: context,
            builder: (_) => new WinnerDialog("Player 2 Won",
                "Press the reset button to start again.", resetGame));
      }
    }

    return winner;
  }

  autoPlay() {
    var emptyCells = new List();
    var list = new List.generate(SUM, (i) => i + 1);
    for (var cellId in list) {
      if (!(player1List.contains(cellId) || player2List.contains(cellId))) {
        emptyCells.add(cellId);
      }
    }
    var r = new Random();
    var randIndex = r.nextInt(emptyCells.length - 1);
    var cellId = emptyCells[randIndex];
    int i = itemlist.indexWhere((p) => p.id == cellId);
    playGame(itemlist[i], i);
  }

  /// detect winner
  int doReferee(List<int> players, int winner, int currentCell) {
    // check vertically
    for (var i = 0; i < players.length; i++) {
      var player = players[i];
      var vertically = players.contains(player + COLUMNS) &&
          players.contains(player + COLUMNS * 2) &&
          players.contains(player + COLUMNS * 3) &&
          players.contains(player + COLUMNS * 4);
      if (vertically) return winner;
      var horizontally = players.contains(player + 1) &&
          players.contains(player + 2) &&
          players.contains(player + 3) &&
          players.contains(player + 4);
      if (horizontally) return winner;
      var crossRight = players.contains(player + COLUMNS * 4 + 4) &&
          players.contains(player + COLUMNS * 3 + 3) &&
          players.contains(player + COLUMNS * 2 + 2) &&
          players.contains(player + COLUMNS + 1);
      if (crossRight) return winner;
      var crossLeft = players.contains(player + COLUMNS * 4 - 4) &&
          players.contains(player + COLUMNS * 3 - 3) &&
          players.contains(player + COLUMNS * 2 - 2) &&
          players.contains(player + COLUMNS - 1);
      if (crossLeft) return winner;
    }
    return 0;
  }

  Column _buildPlayer(User player) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(Icons.ac_unit),
        Container(
          margin: const EdgeInsets.only(top: 1),
          child: Text(player.userName),
        )
      ],
    );
  }

  Text _buildText(String s) {
    return Text(s,
        style: TextStyle(
            color: Colors.red, fontSize: 30.0, fontWeight: FontWeight.w600));
  }
}
