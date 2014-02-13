part of TowerDefense;

class MissileTower extends Tower{
  
  double range = 320.0;
  int reloadTime = 120;
  
  double missileStartDistance = 32.0;
  List<double> missileStarts = [45.0, 135.0, 225.0, 315.0];
  
  Map<String, dynamic> bulletConfig;
  
  MissileTower.fromJSON(Point<int> startPos, Map<String, dynamic> config) : super.fromJSON(startPos, config){
    reloadBar..height = 6.0
             ..reg.x = -reloadBar.width/2
             ..reg.y = -reloadBar.height/2;
    
    bulletConfig = config['bullet'];         
  }
  
  void update(num deltaTime){
    if(reloading){
      reload();
    }else{
      Enemy enemy = Enemy.getInRange(this, range);
      if(enemy != null){
        attacke(enemy);
      }
    }
  }
  
  void attacke(Enemy enemy){
    super.attacke(enemy);
    
    for(double rotation in missileStarts){
      Bullet missile = new Missile.fromJSON(assets['bulletImage'], enemy, bulletConfig)
        ..pos.setFrom(pos)
        ..rotation = rotation
        ..moveForward(missileStartDistance);
      enemy.parent.add(missile);
    }
  }
}