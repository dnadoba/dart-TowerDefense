part of GameEngine2D;

class Szene extends Container{
  
  CanvasElement canvas;
  CanvasRenderingContext2D context;
  
  
  
  StreamController<num> onUpdateController = new StreamController<num>.broadcast();
  Stream<num> get onUpdate =>
      onUpdateController.stream;
  
  
  double fps = 0.0;
  double _lastDeltaTime;
  
  bool get showFps => _fpsText.visible;
       set showFps (showFps) =>
           _fpsText.visible = showFps;
  
  Text2D _fpsText = new Text2D("FPS: --", "12pt Arial", "#000");
  
  Szene(this.canvas){
    context = canvas.getContext("2d");
    
    // init debug draw fps text
    _fpsText.visible = false;
    _fpsText.align = 'right';
    _fpsText.shadow = new Shadow('#FFF', 1.0, 1.0, 0);
  }
  
  void start(){
    Timer timer = new Timer.periodic(new Duration(milliseconds: 16), frame);
  }
  
  void frame(Timer timer){
    double deltaTime = (new DateTime.now()).millisecond.toDouble();
    update(deltaTime);
    draw(context);
  }
  
  /// Game Loop
  void update(num deltaTime){
    
    updateFps(deltaTime);
    super.update(deltaTime);
    // broadcast to all listeners
    onUpdateController.add(deltaTime);
  }
  
  void draw(CanvasRenderingContext2D context){
    
    // clear the Canvas
    clear();
    
    if(needDraw()){
      super.drawBefor(context);
      super.drawCall(context);
      super.drawAfter(context);
    }
  }
  
  /// clears the canvas
  void clear(){
    context.clearRect(0, 0, canvas.width, canvas.height);
  }
  
  void updateFps(num deltaTime){
    if(_lastDeltaTime != null && deltaTime != _lastDeltaTime){
      fps = mesureFps(_lastDeltaTime, deltaTime);
      _fpsText.text = 'FPS: ${fps.round()}';
      _fpsText.pos.x = canvas.width.toDouble();
      removeChild(_fpsText);
      add(_fpsText);
    }
    _lastDeltaTime = deltaTime;
    
    
    
  }
  
  /// mesures the fps
  double mesureFps(lastDeltaTime, crtDeltaTime){
    num dif = (crtDeltaTime - lastDeltaTime) as num;
    dif = dif.abs();
    double fps = 1000 / dif;
    return fps;
  }
  
}