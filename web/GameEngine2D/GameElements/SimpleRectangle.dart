part of GameEngine2D;

class SimpleRectangle extends GameElement{
  
  String style = '';
  
  double width;
  double height;
  
  Rectangle<double> get bounds =>
      new Rectangle<double>(pos.x, pos.y, width, height);
  
  SimpleRectangle(double top, double left, double width, double height){
    pos.x = top;
    pos.y = left;
    
    this.width = width;
    this.height = height;
  }
  
  SimpleRectangle.fromRectangle(Rectangle other){
    pos.x = other.top;
    pos.y = other.left;
    
    width = other.width;
    height = other.height;
  }
  
  void draw(CanvasRenderingContext2D context){
    context.fillStyle = style;
    context.fillRect(drawPos.x, drawPos.y, width, height);
  }
  
}