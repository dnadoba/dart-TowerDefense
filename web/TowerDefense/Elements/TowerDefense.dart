part of TowerDefense;

class TowerDefense extends Szene{
  static int tileSizePow = 6;
  static int tileSize = 1 << tileSizePow;
  
  static Point<int> getTilePos(Vector2 pos){
    return new Point((pos.x / tileSize).floor(), (pos.y / tileSize).floor());
  }
  
  static Vector2 getPos(Point<int> pos){
    return new Vector2(
        (pos.x << tileSizePow).toDouble(), 
        (pos.y << tileSizePow).toDouble()
      );
  }
  
  static Vector2 getCenterPos(Point<int> pos){
    Vector2 centerPos = getPos(pos)
                     ..add(new Vector2(
                         (tileSize >> 1).toDouble(), 
                         (tileSize >> 1).toDouble()
                       ));
    return centerPos;
  }
  // Clear some global arrays
  static void reset(){
    Enemy.all.clear();
  }
  
  GUI gui;
  
  Map<String, dynamic> config;
  Level level;
  
  HtmlElement DOMContainer;
  
  Container enemyContainer = new Container();
  Container towerContainer = new Container();
  Container bulletContainer = new Container();
  Container utiliContainer = new Container();
  
  bool doubleSpeed = false;
  
  bool resized = true;
  
  TowerList towerList;
  
  Tower focusedTower;
  
  TowerDefense({this.DOMContainer, CanvasElement canvas, this.config,  this.level}) : super(canvas){
    add(enemyContainer);
    add(towerContainer); 
    add(bulletContainer);
    add(utiliContainer);
    
    onUpdate.listen((deltaTime){
      level.update(deltaTime);
    });
    
    towerList = new TowerList(level.towers, utiliContainer);
    towerList.onBuy.listen((Map<String, dynamic> e){
      Map<String, dynamic> config = e['config'];
      Point<int> startPos = e['startPos'];
      
      Tower tower = level.buyTower(config, startPos);
      if(tower != null){
        towerContainer.add(tower);
      }
      
    });
    DOMContainer.append(towerList.div);
    
    window.onResize.listen((e) => resized = true);
    
    initTowerMenue();
    initGUI();
  }
  
  void frame(Timer timer){
    double deltaTime = (new DateTime.now()).millisecond.toDouble();
    if(doubleSpeed){
      update(deltaTime);
    }
    super.frame(timer);
  }
  
  void clear(){
    super.clear();
    if(resized){
      canvas.width = window.innerWidth;
      canvas.height = window.innerHeight;
    }
    
  }
  
  void initGUI(){
    gui = new GUI();
    DOMContainer.append(gui.div);
    gui.onDoubleSpeedChange.listen((doubleSpeed){ 
      this.doubleSpeed = doubleSpeed; 
    });
    add(gui);
    
    gui.onMoneyChangeController.add(level.money);
    level.onMoneyChange.listen((money) => gui.onMoneyChangeController.add(money));
    
    level.onRoundFinished.listen((roundIdx){
      gui.showStartRoundButton();
    });
    level.onRoundStarted.listen((roundIdx){
      gui.hideStartRoundButton();
    });
    
    gui.onStartNextRound.listen((_) => level.startRound(enemyContainer));
  }
  
  void initTowerMenue(){
    Stream mouseDown = mergeStreams(canvas.onMouseDown, canvas.onTouchStart);
    
    mouseDown.listen((e){
      Point mousePos = getMousePos(e);
      Tower tower = level.getTowerAtPos(getTilePos(new Vector2(mousePos.x.toDouble(), mousePos.y.toDouble())));
      if(tower != null && tower == focusedTower){
        focusedTower.hideMenue();
        focusedTower = null;
      }else{
        if(focusedTower != null){
          focusedTower.hideMenue();
          focusedTower = null;
        }
        if(tower != null){
          tower.showMenue(DOMContainer);
          focusedTower = tower;
        }
      }
    });
    
  }
  
}