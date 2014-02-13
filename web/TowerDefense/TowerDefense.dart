library TowerDefense;

import 'dart:html';
import 'dart:math';
import 'dart:async';
import 'dart:convert';

import '../GameManager/GameManager.dart';
import '../GameEngine2D/GameEngine2D.dart';
import 'package:vector_math/vector_math.dart';

part 'Elements/TowerDefense.dart';
part 'Elements/GUI.dart';
part 'Elements/Map.dart';
part 'Elements/TowerList.dart';
part 'Elements/Way.dart';

part 'Elements/Level.dart';
part 'Elements/Round.dart';
part 'Elements/Wave.dart';

part 'Elements/Towers/Tower.dart';
part 'Elements/Towers/FastTower.dart';
part 'Elements/Towers/MissileTower.dart';

part 'Elements/Bullets/Bullet.dart';
part 'Elements/Bullets/FastBullet.dart';
part 'Elements/Bullets/Missile.dart';

part 'Elements/Enemys/Enemy.dart';


// Global Helper
Stream mergeStreams(Stream one, Stream two){
  StreamController controller = new StreamController(sync: true);
  one.listen(controller.add);
  two.listen(controller.add);
  
  return controller.stream;
}

// helper to get mouse position for normal mouse and touch events
Point getMousePos(e){
  if(e is MouseEvent){
    return e.client;
  }else if(e is TouchEvent){
    if(e.touches.length >= 1){
      return e.touches[0].client;
    }else if(e.changedTouches.length >= 1){
      return e.changedTouches[0].page;
    }
  }
}