part of TowerDefense;

class Level{
  int _money = 0;
  int get money => _money;
      set money (money){
        _money = money;
        onMoneyChangeController.add(money);
      }
  int life = 0;
  
  int mapID = 0;
  int levelID = 0;
  
  Round crtRound;
  int crtRoundIdx = -1;
  
  
  bool inRound = false;
  
  List<Round> rounds = new List<Round>();
  List<Map> towers = new List<Map>();
  
  Map<String, Tower> boughtTowers = new Map<String, Tower>();
  
  StreamController<int> onMoneyChangeController = new StreamController<int>.broadcast();
  Stream<int> get onMoneyChange => onMoneyChangeController.stream;
  
  StreamController<int> _onRoundStartedController = new StreamController<int>.broadcast();
  Stream<int> get onRoundStarted => _onRoundStartedController.stream;
  
  StreamController<int> _onRoundFinishedController = new StreamController<int>.broadcast();
  Stream<int> get onRoundFinished => _onRoundFinishedController.stream;
  
  
  Completer completer = new Completer();
  Future get finished => completer.future;
  
  Level.fromJSON(Map<String, dynamic> config){
    money = config['startMoney'];
    life = config['life'];
    for(Map<String, dynamic> roundConfig in config['rounds']){
      addRound(roundConfig);
    }
    for(String towerKey in config['towers']){
      Map<String, dynamic> towerConfig = GameManager.towersConfig[towerKey];
      if(towerConfig != null){
        addTower(towerConfig);
      }else{
        print("tower key '$towerKey' can't found in the towers config");
      }
    }
  }
  
  void addRound(Map<String, dynamic> config){
    Round round = new Round.fromJSON(config);
    rounds.add(round);
  }
  
  void addTower(Map<String, dynamic> config){
    Map<String, dynamic> assets = config['assets'];
    assets.forEach((key, src){
      if(src is String){
        config['assets'][key] = AssetManager.add(src);
      }
    });
    towers.add(config);
  }
  
  bool startRound(Container container){
    if(!inRound){
      crtRoundIdx++;
      if(crtRoundIdx < rounds.length){
        crtRound = rounds[crtRoundIdx];
        crtRound.start(container);
        crtRound.onEnemyDie.listen((addMoney){
          money += addMoney;
        });
        _onRoundStartedController.add(crtRoundIdx);
        crtRound.finished.then((_){
          _onRoundFinishedController.add(crtRoundIdx);
          inRound = false;
          if((crtRoundIdx+1) >= rounds.length){
            crtRound = null;
            completer.complete();
          }
        });
        inRound = true;
      }
      return true;
    }else{
      return false;
    }
  }
  
  void update(num deltaTime){
    if(inRound){
      crtRound.update(deltaTime);
    }
  }
  
  Tower _createTower(String className, Map<String, dynamic> config, Point<int> startPos){
    switch(className){
      case 'FastTower':
        return new FastTower.fromJSON(startPos, config);
      case 'MissileTower':
        return new MissileTower.fromJSON(startPos, config);
    }
  }
  
/// return a tower at the give position or null if it's not exists
  Tower getTowerAtPos(Point<int> pos){
    String hash = "$pos.x-$pos.y";
    return boughtTowers[hash];
  }
  
  Tower setTowerToPos(Point<int> pos, Tower tower){
    String hash = "$pos.x-$pos.y";
    boughtTowers[hash] = tower;
  }
  
  Tower buyTower(Map<String, dynamic> towerConfig, Point<int> startPos){
    
    Tower exisitsTower = getTowerAtPos(startPos);
    if(exisitsTower != null){
      return null;
    }
    
    int cost = towerConfig['cost'];
    if(cost > money){
      return null;
    }
    
    money -= cost;
    
    String className = towerConfig['class'];
    
    Tower tower = _createTower(className, towerConfig, startPos);
    
    setTowerToPos(startPos, tower);
    
    return tower;
  }
  
  
  
}