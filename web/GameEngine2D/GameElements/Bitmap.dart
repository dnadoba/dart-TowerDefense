part of GameEngine2D;

class Bitmap extends GameElement{
  
  ImageElement image;
  
  Bitmap([this.image]){
    
  }

  
  Rectangle<double> get bounds{
      double width = image == null ? 0.0 : image.width.toDouble();
      double height = image == null ? 0.0 : image.height.toDouble();
      return new Rectangle<double>(0.0, 0.0, width, height);
    }
  
  bool needDraw(){
    return super.needDraw() &&
           image != null &&
           // image loaded
           image.complete &&
           // without error
           image.naturalWidth > 0 &&
           image.naturalHeight > 0;
  }
  
  void draw(CanvasRenderingContext2D context){
    context.drawImage(image, drawPos.x, drawPos.y);
  }
  
  void center(){
    reg.x = -image.width/2;
    reg.y = -image.height/2;
  }
}