library GameManager;

import 'dart:html';
import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'package:path/path.dart';

import '../GameEngine2D/GameEngine2D.dart';
import '../TowerDefense/TowerDefense.dart';

import 'package:vector_math/vector_math.dart';

part 'Asset.dart';
part 'AssetManager.dart';

class GameManager{
  static const String configDir = 'config';
  
  static Map towersConfig;
  static List mapsConfig;
  static Map enemysConfig;
  
  Future<List> configsLoaded;
  
  TowerDefense game;
  HtmlElement DOMElm;
  
  GameManager(){
    DOMElm = querySelector('body');
    
    Future towers = loadTowersConfig();
    Future maps = loadMapsConfig();
    Future enemys = loadEnemysConfig();
    configsLoaded = Future.wait([towers, maps, enemys]);
    
    disableTouchScroll();
  }
  
  Future<dynamic> loadConfig(String configName){
    Completer<dynamic> completer = new Completer<dynamic>();
    
    String url = "$configDir/$configName.json";
    
    HttpRequest.getString(url).then((jsonString){
      var config = JSON.decode(jsonString);
      completer.complete(config);
    });
    
    return completer.future;
  }
  
  Future loadTowersConfig(){
    return loadConfig("towers").then((config){
      towersConfig = config;
    });
  }
  
  Future loadMapsConfig(){
    return loadConfig("maps").then((config){
      mapsConfig = config;
    });
  }
  
  Future loadEnemysConfig(){
    return loadConfig("enemys").then((config){
      enemysConfig = config;
    });
  }
  
  Future loadLevelConfig(String mapClass, int levelID){
    return loadConfig("$mapClass/level_$levelID");
  }
  
  Future loadGame(int mapID, int levelID){
    Completer completer = new Completer();
    
    Map mapConfig = mapsConfig[mapID];
    loadLevelConfig(mapConfig["class"], levelID).then((config){
      Level level = new Level.fromJSON(config);
      level.mapID = mapID;
      level.levelID = levelID;
      
      //Add Assets from GUI
      AssetManager.addAll(GUI.assets);
      
      AssetManager.load().then((_){
        initGame(mapConfig, level);
        completer.complete();
      });
    });
    
    return completer.future;
  }
  
  List<String> getExisitingEnemys(List rounds){
    
  }
  
  void disableTouchScroll(){
    window.onTouchStart.listen((e) => e.preventDefault());
    window.onTouchMove.listen((e) => e.preventDefault());
  }
  
  
  void initGame(mapConfig, Level level){
    TowerDefense.reset();
    game = new TowerDefense(
        DOMContainer : DOMElm,
        canvas : DOMElm.querySelector("#towerDefense"),
        config : mapConfig, 
        level : level
      );
    game.start();
  }
  
}

