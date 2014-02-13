part of GameEngine2D;

class Text2D extends GameElement{
  /// text to draw
  String get text => _text;
         set text(String text){
      mesuredSize = null;
      cached = false;
      _text = text;
  }
  
  String _text = '';
  /// font size and family
  String font = '12pt Arial';
  /// font fill color
  var fillStyle = '#000';
  /// font stroke color
  var strokeStyle = '';
  /// posible values: top, bottom, middle
  String baseline = 'top';
  
  /// posible values left, right, center
  String align = 'left';
  
  ///  the maximum width to draw
  double maxWidth;
  /// Width of lines. Default 1.0
  num lineWidth = 1.0;
  /// shadow for the text
  Shadow shadow;
  
  
  
  Text2D([this._text, this.font, this.fillStyle, this.strokeStyle]){
    
  }
  
  Rectangle get bounds{
    if(mesuredSize == null){
      mesuredSize = mesureSize(_text);
    }
    MutableRectangle<double> bounds = new MutableRectangle<double>(mesuredSize.top, mesuredSize.left, mesuredSize.width, mesuredSize.height);
    
    // add shadow
    if(shadow != null){
      shadow.bounds(bounds);
    }
    
    // add baseline
    if(baseline == 'bottom'){
      bounds.top -= mesuredSize.height;
    }else if(baseline == 'middle'){
      bounds.top -= mesuredSize.height / 2;
    }
    
    // add align
    if(align == 'right'){
      bounds.left = -bounds.left;
    }else if(align == 'center'){
      bounds.left -= mesuredSize.width / 2;
    }
    
    return bounds;
  }
  
  Rectangle mesuredSize;
  
  
  Rectangle<double> mesureSize(String text){
    // Mesure width
    CanvasElement canvas = new CanvasElement();
    CanvasRenderingContext2D context = canvas.getContext("2d");
    context.font = font;
    double width = context.measureText(text).width;
    
    // mesure height, workaround from HTML5Rocks http://www.html5rocks.com/en/tutorials/canvas/texteffects/#toc-text-shadow-clipping
    SpanElement span = new SpanElement();
    span.style.font = font;
    span.style.visibility = "hidden";
    span.text = text;
    document.body.append(span);
    
    double height = span.offsetHeight.toDouble();
    
    span.remove();
    
    return new Rectangle<double>(0.0, 0.0, width, height);
  }
  
  void draw(CanvasRenderingContext2D context){
    // apply shadow
    if(shadow != null){
      shadow.apply(context);
    }
    
    context..font = font
           ..strokeStyle = strokeStyle
           ..fillStyle = fillStyle
           ..textBaseline = baseline
           ..textAlign = align
           ..lineWidth = lineWidth;
    if(strokeStyle != ''){
      context.strokeText(text, drawPos.x, drawPos.y, maxWidth);
    }
    if(fillStyle != ''){
      context.fillText(text, drawPos.x, drawPos.y, maxWidth);
    }
  }
  
}