part of GameEngine2D;


abstract class GameElement{
  /// position
  Vector2 pos = new Vector2.zero();
  
  /// registration point
  Vector2 reg = new Vector2.zero();
  
  /// rotation in degre
  double rotation = 0.0;
  
  /// scale
  Vector2 scale = new Vector2(1.0, 1.0);
  
  /// parent element
  Container parent;
  
  /// if the Element is visible the draw method will be called, otherwise not
  bool visible = true;
  
  Rectangle<double> get bounds;
  
  // Cache
  /// cacheable
  bool cacheable = false;
  /// cached
  bool cached = false;
  /// cache canvas
  CanvasElement cacheCanvas;
  
  bool removed = false;
  
  Vector2 get drawPos{
      if(cacheable){
        Rectangle myBounds = bounds;
        Vector2 drawPos = new Vector2(myBounds.top, myBounds.left);
        return drawPos.negate();
      }else{
        return reg;
      }
  }
  /// Test Komentar
  GameElement(){
    
  }
  
  void update(num deltaTime){
    
  }
  
  bool needDraw(){
    return !removed && visible;
  }
  
  void drawBefor(CanvasRenderingContext2D context){
    // save the current transform and more from the canvas
    context.save();
    // translate, rotate and scale the context
    context.translate(pos.x, pos.y);
    context.rotate(rotation * degrees2radians);
    context.scale(scale.x, scale.y);
  }
  
  void drawCall(CanvasRenderingContext2D context){
    if(cacheable && !cached){
      resetCache();
      draw(cacheCanvas.getContext('2d'));
      cached = true;
    }
    if(cacheable && cached){
      drawCache(context);
    }else{
      draw(context);
    }
  }
  
  void drawCache(CanvasRenderingContext2D context){
    context.drawImage(cacheCanvas, reg.x, reg.y);
  }
  
  void resetCache(){
    if(cacheCanvas == null){
      cacheCanvas = new CanvasElement();
    }else{
      CanvasRenderingContext2D context = cacheCanvas.getContext('2d');
      context.clearRect(0, 0, cacheCanvas.width, cacheCanvas.height);
    }
    Rectangle<double> crtBounds = bounds;
    cacheCanvas..width = crtBounds.width.ceil()
               ..height = crtBounds.height.ceil();
  }
  
  void draw(CanvasRenderingContext2D context){
    
  }
  
  void drawAfter(CanvasRenderingContext2D context){
    // restore the old tranform and more from the canvas stack
    context.restore();
  }
  
  // remove itself frome it's parent
  void remove(){
    removed = true;
    if(parent != null){
      parent.removeChild(this);
      parent = null;
    }
  }
  
  void setToTop(){
    if(parent != null){
      parent.add(this);
    }
  }
  
}