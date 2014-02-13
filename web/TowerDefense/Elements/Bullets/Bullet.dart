part of TowerDefense;

abstract class Bullet extends Bitmap{
  
  double damage = 50.0;
  double speed = 5.0;
  double range = 20.0;
  
  Bullet.fromJSON(Asset<ImageElement> asset, Map<String, dynamic> config){
    image = asset.get();
    center();
    
    damage = config['damage'];
    speed = config['speed'];
    range = config['range'];
  }
  
  double getAngle(GameElement enemy){
    double x = (enemy.pos.x - pos.x);
    double y = (enemy.pos.y - pos.y);
    
    return atan2(y , x);
  }
  
  bool inRange(enemy){
    num distance = pos.distanceTo(enemy.pos);
    return distance < range;
  }
  
  static const int CLOCKWISE = -1;
  static const int COUNTER_CLOCKWISE = 1;
  static const double PI2 = PI * 2;


  int determineSmallestAngle(GameElement from, GameElement to)
  {
    double a1 = atan2(to.pos.y - from.pos.y, to.pos.x - from.pos.x);
    double a2 = from.rotation * PI / 180;

    a2 -= (a2 / PI2).floor() * PI2;

    if(a2 > PI) a2 -= PI2;

    a2 -= a1;

    if (a2 > PI) a2 -= PI2;
    if (a2 < -1 * PI) a2 += PI2;

    return (a2 > 0) ? CLOCKWISE : COUNTER_CLOCKWISE;
  }
  
  void moveForward(double distance){
    double angle = rotation * degrees2radians;
    Vector2 velocity = new Vector2(cos(angle), sin(angle));
    velocity.normalize();
    velocity *= distance;
    
    pos.add(velocity);
  }
  
  void destroy(){
    remove();
  }
}