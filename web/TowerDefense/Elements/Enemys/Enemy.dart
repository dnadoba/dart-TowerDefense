part of TowerDefense;

class Enemy extends Container{
  static List<Enemy> all = new List<Enemy>();
  
  static Enemy getNearest(GameElement elm){
    double smallestDistance = double.MAX_FINITE;
    Enemy nearest;
    for(Enemy enemy in all){
      if(enemy.dead){
        continue;
      }
      double distance = enemy.pos.distanceTo(elm.pos);
      if(distance < smallestDistance){
        smallestDistance = distance;
        nearest = enemy;
      }
    }
    return nearest;
  }
  static Enemy getInRange(GameElement elm, double range){
    for(Enemy enemy in all){
      if(!enemy.dead && enemy.inRange(elm, range)){
        return enemy;
      }
    }
    return null;
  }
  
  
  int width = 64;
  int height = 64;
  
  double fullLife = 300.0;
  double life = 300.0;
  double speed;
  int money;
  int damage;
  
  bool dead = false;
  
  Way way;
  
  Map<String, Asset> assets;
  
  Bitmap bitmap;
  
  Completer _dieCompleter = new Completer();
  Future get die => _dieCompleter.future;
  
  Enemy(){
    bitmap = new Bitmap();
    bitmap.reg.setValues(-width/2, -height/2);
    add(bitmap);
    
    all.add(this);
  }
  
  Enemy.fromJSON(Map<String, dynamic> config){
    fullLife = config['life'];
    life = fullLife;
    speed = config['speed'];
    damage = config['damage'];
    money = config['money'];
    
    assets = config['assets'];
    bitmap = new Bitmap(assets['bitmap'].get());
    bitmap.reg.setValues(-width/2, -height/2);
    add(bitmap);
    
    all.add(this);
  }
  
  void update(deltaTime){
    pos.x += 1;
    pos.y += 0.5;
    if(dead){
      remove();
    }
    super.update(deltaTime);
  }
  
  bool hit(double damage){
    if(dead){
      return false;
    }
    life -= damage;
    if(life <= 0){
      kill();
      return true;
    }
    return false;
  }
  void kill(){
    life = 0.0;
    _dieCompleter.complete(money);
    dead = true;
  }
  
  void remove(){
    super.remove();
    all.remove(this);
  }
  bool inRange(GameElement elm, double range){
    num distance = pos.distanceTo(elm.pos);
    return distance < range;
  }
}