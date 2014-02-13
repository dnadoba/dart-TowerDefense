part of GameEngine2D;

class Shadow{
  /// color for the  Default #000
  String color = '#000';
  
  /// offset of the shadow
  Vector2 offset = new Vector2(0.0, 0.0);
  
  /// blur for the shadow
  num blur = 0;
  
  Shadow([this.color = '#000', double offsetX = 0.0, double offsetY = 0.0, this.blur = 0]){
    offset.x = offsetX;
    offset.y = offsetY;
  }
  
  void bounds(MutableRectangle bounds){
    bounds.top -= blur;
    if(offset.x < 0){
      bounds.top += offset.x;
    }
    
    bounds.left -= blur;
    if(offset.y < 0){
      bounds.left += offset.y;
    }
    
    bounds.width += blur;
    if(offset.x > 0){
      bounds.width += offset.x;
    }
    
    bounds.height += blur;
    if(offset.y > 0){
      bounds.height = offset.y;
    }
  }
  
  void apply(CanvasRenderingContext2D context){
    context..shadowColor = color
           ..shadowOffsetX = offset.x
           ..shadowOffsetY = offset.y
           ..shadowBlur = blur;
  }
  
}