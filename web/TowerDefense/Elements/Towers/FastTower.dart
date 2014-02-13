part of TowerDefense;

class FastTower extends Tower{ 
  
  
  double range = 160.0;
  int reloadTime = 25;
  double bulletStartDistance = 25.0;
  int reloadBarMaxWidth = 33;
  
  Enemy target;
  
  Map<String, dynamic> bulletConfig;
  
  FastTower.fromJSON(Point<int> startPos, Map<String, dynamic> config) : super.fromJSON(startPos, config){
    reloadBar..height = 6.0
             ..reg.y = -reloadBar.height/2
             ..reg.x = -reloadBar.width/2
             ..pos.x = -6.0;
    
    bulletConfig = config['bullet'];
    
  }
  
  void update(num deltaTime){
    target = Enemy.getInRange(this, range);
    
    if(reloading){
      reload();
    }else{
      if(target != null){
        attacke(target);
      }
    }
  }
  
  void attacke(Enemy enemy){
    super.attacke(enemy);
    Bullet bullet = new FastBullet.fromJSON(assets['bulletImage'], enemy, bulletConfig)
          ..pos.setFrom(pos)
          ..rotation = rotation
          ..moveForward(bulletStartDistance);
    
    enemy.parent.add(bullet);
    
    reloading = true;
  }
  
  void drawCall(CanvasRenderingContext2D context){
    
    // look at the target
    if(target != null){
      rotation = getAngle(target) * radians2degrees;
    }
    super.drawCall(context);
  }
}