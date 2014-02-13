part of TowerDefense;

class Missile extends Bullet{
  Enemy target;
  
  double angleStep = 5.0 * degrees2radians;
  double damage = 90.0;
  
  Missile.fromJSON(Asset<ImageElement> asset, this.target, Map<String, dynamic> config) : super.fromJSON(asset, config){
    
  }
  
  void update(num deltaTime){
    if(target == null){
      destroy();
    }else if(target.dead){
      Enemy newTarget = Enemy.getNearest(this);
      if(newTarget == null){
        destroy();
      }else{
        target = newTarget;
      }
    }
    if(target != null){
      
      if(inRange(target)){
        target.hit(damage);
        destroy();
      }else{
        
        int dir = determineSmallestAngle(this, target);
        double addAngle = angleStep * dir;

        rotation += addAngle * radians2degrees;
        
        moveForward(speed);
      }
    }
  }
}