part of GameEngine2D;

class SimpleCircle extends GameElement{
  
  String fillStyle = '';
  String strockeStyle = '';
  
  double radius = 0.0;
  
  Rectangle<double> get bounds =>
      new Rectangle<double>(pos.x-radius, pos.y-radius, radius*2, radius*2);
  
  SimpleCircle([this.radius]){

  }
  
  void draw(CanvasRenderingContext2D context){
    context.beginPath();
    context.strokeStyle = strockeStyle;
    context.fillStyle = fillStyle;
    context.arc(drawPos.x, drawPos.y, radius, 0, 2 * PI);
    if(fillStyle != ''){
      context.fill();
    }
    if(strockeStyle != ''){
      context.stroke();
    }
  }
  
}