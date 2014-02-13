part of TowerDefense;

class Wave{
  int startDelay = 0;
  int spawnDelay = 0;
  int endDelay = 0;
  
  int frame = 0;
  int endFrameSpawn = 0;
  int endFrameWave;
  int spawnIndex = 0;
  
  bool spawning = false;
  
  List<Map> enemys = new List<Map>();
  
  StreamController<int> _onEnemyDieController = new StreamController<int>.broadcast();
  Stream get onEnemyDie => _onEnemyDieController.stream;
  
  Completer completer = new Completer();
  
  Future get finished => completer.future;
  
  Container container;
  
  Wave.fromJSON(Map<String, dynamic> config){
    startDelay = config['startDelay'];
    spawnDelay = config['spawnDelay'];
    endDelay = config['endDelay'];
    List enemyList = config["enemys"];
    for(String enemyKey in enemyList){
      addEnemy(enemyKey);
    }
  }
  
  void update(num deltaTime){
    if(spawning){
      if(frame >= 0 && frame < endFrameSpawn){
        if(frame % spawnDelay == 0){
          int index = (frame/spawnDelay).round();
          spawn(enemys[index]);
        }
      }else if(frame >= endFrameWave){
        finish();
      }
      frame++;
    }
  }
  
  void start(Container container){
    this.container = container;
    frame = -startDelay;
    endFrameSpawn = spawnDelay * (enemys.length);
    endFrameWave = endFrameSpawn + endDelay;
    spawning = true;
  }
  
  void finish(){
    spawning = false;
    completer.complete();
  }
  
  void addEnemy(String enemyKey){
    Map<String, dynamic> config = GameManager.enemysConfig[enemyKey];
    if(config != null){
      add(config);
    }else{
      print("enemy with key '$enemyKey' is not in the enemys config");
    }
  }
  
  void add(Map<String, dynamic> config){
    Map<String, dynamic> assets = config['assets'];
    assets.forEach((assetName, src){
       if(src is String){
         // add to AssetManager loading list
         config['assets'][assetName] = AssetManager.add(src);
       }
    });
    enemys.add(config);
  }
  
  void spawn(Map<String, dynamic> config){
    Enemy enemy = createEnemy(config);
    enemy.die.then((money) => _onEnemyDieController.add(money));
    container.add(enemy);
  }
  
  Enemy createEnemy(Map<String, dynamic> config){
    switch(config['class']){
      case 'Enemy':
        return new Enemy.fromJSON(config);
        
    }
  }
}