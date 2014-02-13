part of TowerDefense;

class TowerDefenseMap{
  Rectangle<int> _viewportBackground = new Rectangle<int>(0,0,0,0);
  Rectangle<int> get viewportBackgound => _viewportBackground;
                 set viewportBackgound(Rectangle<int> viewport){
                   _viewportBackground = viewport;
                   needUpdate = true;
                 }
                 
  Rectangle<int> _viewportBuildable = new Rectangle<int>(0,0,0,0);
  Rectangle<int> get viewportBuildable => _viewportBuildable;
                 set viewportBuildable(Rectangle<int> viewport){
                   _viewportBuildable = viewport;
                   needUpdate = true;
                 }
  
  bool needUpdate = true;
  
  double scale = 1.0;
  
  StreamController<double>  _onScaleChangeController = new StreamController<double>.broadcast();
  Stream<double> get onScaleChange => _onScaleChangeController.stream;
  
  ImageElement image;
  Rectangle<int> imageBuildable;
  
  CanvasElement canvas = new CanvasElement();
  
  TowerDefenseMap(this.image, this.imageBuildable){
    
  }
 
  void draw(){
    if(needUpdate){
      canvas.width = viewportBackgound.width;
      canvas.height = viewportBackgound.height;
      
      CanvasRenderingContext2D context = canvas.context2D;
      
      context.clearRect(0, 0, canvas.width, canvas.height);
      
      MutableRectangle drawRec = new MutableRectangle(0,0,0,0);
      
      // Buildable Scale
      
      double widthScale = viewportBuildable.width / imageBuildable.width;
      double heightScale = viewportBuildable.height / imageBuildable.height;
      
      double buildableScale = min(widthScale, heightScale);
      
      // Background Scale
      widthScale = viewportBackgound.width / image.width;
      heightScale = viewportBackgound.height / image.height;
      
      double backgroundScale = min(widthScale, heightScale);
      
      scale = 1.0;
      
      if(backgroundScale > 1){
        scale = backgroundScale;
        
      }else if(buildableScale < 1){
        scale = buildableScale;
      }
      
      
      
    }
  }
}