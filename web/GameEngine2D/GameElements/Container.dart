part of GameEngine2D;

class Container extends GameElement{
  /// all children
  List<GameElement> children = [];
  
  /// add an element
  void add(GameElement child){
    // if has parrent remove child from parent
    if(child.parent != null){
      child.parent.removeChild(child);
    }
    child.parent = this;
    children.add(child);
  }
  /// add all elements in the list
  void addAll(List<GameElement> otherChildren){
    for(var child in otherChildren){
      add(child);
    }
  }
  
  int indexOf(GameElement child){
    return children.indexOf(child);
  }
  void removeChild(GameElement child){
    children.remove(child);
  }
  GameElement removeAt(int index){
    return children.removeAt(index);
  }
  
  Rectangle<double> get bounds{
    double width = 0.0;
    double height = 0.0;
    for(GameElement child in children){
      Rectangle childBounds = child.bounds;
      
      width = max(width, childBounds.right);
      height = max(height, childBounds.bottom);
    }
    return new Rectangle<double>(pos.x, pos.y, width, height);
  }
  
  void update(num deltaTime){
    super.update(deltaTime);
    
    
    
    
    List<GameElement> childs = new List.from(children, growable: false);
    
    for(GameElement child in childs){
      if(child.removed){
        continue;
      }
      child.update(deltaTime);
      
    }
    
    
  }
  
  void drawCall(CanvasRenderingContext2D context){
    //Set the Relative Position
    
    for(var child in children){
      drawChild(context, child);
    }
  }
  
  void drawChild(CanvasRenderingContext2D context, GameElement child){
    if(child.needDraw()){
      child.drawBefor(context);
      child.drawCall(context);
      child.drawAfter(context);
    }
  }
  
}