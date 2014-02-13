part of TowerDefense;

class Round{
  int successMoney = 0;
  
  int waveIndex = -1;
  
  Wave crtWave;
  List<Wave> waves = new List<Wave>();
  
  StreamController<int> _onEnemyDieController = new StreamController<int>.broadcast();
  Stream get onEnemyDie => _onEnemyDieController.stream;
  
  Completer completer = new Completer();
  Future get finished => completer.future;
  
  Container container;
  
  Round.fromJSON(Map<String, dynamic> config){
    successMoney = config['successMoney'];
    for(Map<String, dynamic> wave in config['waves']){
      addWave(wave);
    }
  }
  
  void start(Container container){
    this.container = container;
    spawnWave();
  }
  
  void update(num deltaTime){
    if(crtWave != null){
      crtWave.update(deltaTime);
    }
  }
  
  void addWave(Map<String, dynamic> wave){
    waves.add(new Wave.fromJSON(wave));
  }
  
  Future spawnWave(){
    waveIndex++;
    if(waveIndex < waves.length){
      crtWave = waves[waveIndex];
      crtWave.start(container);
      crtWave.finished.then((_) => spawnWave());
      crtWave.onEnemyDie.listen(_onEnemyDieController.add);
    }else{
      crtWave = null;
      completer.complete();
    }
  }
  
}