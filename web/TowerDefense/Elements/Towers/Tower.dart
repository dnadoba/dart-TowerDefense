part of TowerDefense;

abstract class Tower extends Container{
  double range = 200.0;
  double damage = 50.0;
  
  int reloadTime = 60;
  int _reloadStep = 0;
  int get reloadStep => _reloadStep;
      set reloadStep(int reloadStep){
        _reloadStep = reloadStep;
        double perc = reloadStep/reloadTime;
        
        reloadBar.width = (perc * reloadBarMaxWidth);
      }
  bool reloading = false;
  
  Bitmap bitmap;
  SimpleRectangle reloadBar;
  String reloadBarStyle = 'rgba(35, 255, 35, 0.4)';
  
  int reloadBarMaxWidth = 33;
  
  Map<String, Asset> assets;
  
  SimpleCircle displayRange;
  
  DivElement upgradeButton;
  DivElement sellButton;
  
  Tower.fromJSON(Point<int> startPos, Map<String, dynamic>config){
    // get real possion of the Tower
    pos = TowerDefense.getCenterPos(startPos);
    
    assets = config["assets"];
    range = config['range'];
    damage = config['damage'];
    reloadTime = config['reloadTime'];
    
    // create and add the circle for the tower range
    displayRange = new SimpleCircle(range);
    displayRange.fillStyle = 'rgba(69, 229, 48, 0.2)';
    displayRange.strockeStyle = 'rgba(69, 229, 48, 0.8)';
    displayRange.visible = false;
    add(displayRange);
    
    // creat and add the tower image
    bitmap = new Bitmap()
          ..image = assets['bitmap'].get()
          ..center();
    add(bitmap);
    
    // creat and add the reload bar
    reloadBar = new SimpleRectangle(0.0, 0.0, reloadBarMaxWidth.toDouble(), 0.0)
             ..style = reloadBarStyle;
    add(reloadBar);
  }
  
  bool reload(){
    reloadStep++;
    if(reloadStep >= reloadTime){
      reloadStep = reloadTime;
      reloading = false; 
    }
  }
  
  void attacke(Enemy enemy){
    reloading = true;
    reloadStep = 0;
  }
  void showMenue(HtmlElement container){
    displayRange.visible = true;
    upgradeButton = new DivElement()
      ..classes.add("towerButton towerUpgrade")
      ..style.left = "${pos.x}px"
      ..style.top = "${pos.y}px";
    container.append(upgradeButton);
    
    sellButton = new DivElement()
      ..classes.add("towerButton towerSell")
      ..style.left = "${pos.x}px"
      ..style.top = "${pos.y}px";
    container.append(sellButton);
  }
  void hideMenue(){
    displayRange.visible = false;
    if(upgradeButton != null){
      upgradeButton.remove();
      upgradeButton = null;
    }
    if(sellButton != null){
      sellButton.remove();
      sellButton = null;
    }
  }
  void remove(){
    super.remove();
  }
  double getAngle(GameElement enemy){
    double x = (enemy.pos.x - pos.x);
    double y = (enemy.pos.y - pos.y);
    
    return atan2(y , x);
  }
}