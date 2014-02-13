part of TowerDefense;

class FastBullet extends Bullet{
  Enemy target;
  
  double speed = 10.0;
  double damage = 30.0;
  
  FastBullet.fromJSON(Asset<ImageElement> asset, this.target, Map<String, dynamic> config) : super.fromJSON(asset, config){
    
  }
  void update(deltaTime){
    if(target == null || target.dead){
      destroy();
    }else{
      if(inRange(target)){
        target.hit(damage);
        destroy();
      }else{
        double angle = getAngle(target);

        rotation = angle * radians2degrees;
        
        moveForward(speed);
      }
    }
  }
}