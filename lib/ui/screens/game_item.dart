import 'package:caro2/common/game_const.dart';
import 'package:flutter/material.dart';

class GameItem extends StatelessWidget{
  final id;
  String text;
  Color bg;
  bool enabled;
  Widget image;
  var activePlayer;
  GameItem(
      {this.id, this.text = "", this.bg = Colors.grey, this.enabled = true, this.image, this.activePlayer});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: image,
    );
  }
}
