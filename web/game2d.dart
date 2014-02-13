import 'dart:html';
import 'dart:math';
import 'dart:async';
import 'dart:convert';

//import 'package:bootjack/bootjack.dart';
import 'package:vector_math/vector_math.dart';

import 'GameEngine2D/GameEngine2D.dart';
import 'TowerDefense/TowerDefense.dart';
import 'GameManager/GameManager.dart';



//import 'package:color/color.dart';
TowerDefense game;
void main() {
  //initBootstrap();
  
  GameManager gameManager = new GameManager();
  gameManager.configsLoaded.then((_){
    gameManager.loadGame(0, 1).then((_){
      //gameManager.game.level.startRound(gameManager.game.enemyContainer);
    });
  });
}