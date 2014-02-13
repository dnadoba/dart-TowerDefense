part of TowerDefense;

class GUI extends Container{
  static List<String> assets = [
    'images/gui/doubleSpeed.png', 
    'images/gui/doubleSpeedAktiv.png',
    'images/gui/money.png',
    'images/gui/startButton.png'
  ];
  
  StreamController<bool> onDoubleSpeedChangeController = new StreamController<bool>.broadcast();
  Stream<bool> get onDoubleSpeedChange => onDoubleSpeedChangeController.stream;
  
  StreamController<int> onMoneyChangeController = new StreamController<int>.broadcast();
  Stream<int> get onMoneyChange => onMoneyChangeController.stream;
  
  StreamController _onStartNextRound = new StreamController.broadcast();
  Stream get onStartNextRound => _onStartNextRound.stream;
  
  HtmlElement div;
  
  double crtMoney = 0.0;
  double toMoney = 0.0;
  Text2D money;
  
  HtmlElement startButton;
  
  GUI(){
    div = new DivElement()
      ..classes.add("gui bottom");
    
    initDoubleSpeed();
    initMoney();
    initStartRoundButton();
  }
  
  void update(num deltaTime){
    if(crtMoney.round() != toMoney.round()){
      double dif = toMoney - crtMoney;
      
      crtMoney += dif/15;

      money.text = "${crtMoney.round()}";
    }
  }
  
  void initDoubleSpeed(){
    
    DivElement doubleSpeed = new DivElement()
      ..classes.add("doubleSpeed");
    
    Stream mouseDown = mergeStreams(doubleSpeed.onMouseDown, doubleSpeed.onTouchStart);
    
    bool doubleSpeedStat = false;
    
    mouseDown.listen((e){
      e.preventDefault();
      doubleSpeedStat = !doubleSpeedStat;
      onDoubleSpeedChangeController.add(doubleSpeedStat);
    });
    
    onDoubleSpeedChange.listen((doubleSpeedStat){
      if(doubleSpeedStat){
        doubleSpeed.classes.add("aktive");
      }else{
        doubleSpeed.classes.remove("aktive");
      }
    });
    div.append(doubleSpeed);
  }
  
  void initMoney(){
    
    CanvasRenderingContext2D ctx = (new CanvasElement()).getContext("2d");
    
    ImageAsset moneyAsset = AssetManager.get('images/gui/money.png');
    Bitmap bitmap = new Bitmap(moneyAsset.get())
      ..pos.setValues(16.0, 16.0);
    
    add(bitmap);
    
    CanvasGradient fillGradient = ctx.createLinearGradient(0, 0, 5, 32)
      ..addColorStop(0, "#f5e277")
      ..addColorStop(1, "#e3b31e");
    
    CanvasGradient strokeGradient = ctx.createLinearGradient(0, 0, 5, 32)
      ..addColorStop(0, "#faf0ad")
      ..addColorStop(1, "#cc7e03");
    
    
    
    money = new Text2D("600", "26px Comic Sans MS")
      ..fillStyle = fillGradient
      ..strokeStyle = strokeGradient
      ..lineWidth = 3.0
      ..pos.setValues(52.0,  15.0);
    
    add(money);
    
    onMoneyChange.listen((money){
      toMoney = money.toDouble();
    }); 
  }
  
  void initStartRoundButton(){
    startButton = new DivElement()
      ..classes.add("startButton animate");
    
    div.append(startButton);
    
    Stream mouseDown = mergeStreams(startButton.onMouseDown, startButton.onTouchStart);
    mouseDown.listen((e){
      e.preventDefault();
      _onStartNextRound.add(true);
    });
  }
  
  void showStartRoundButton(){
    startButton.style.display = 'block';
  }
  
  void hideStartRoundButton(){
    startButton.style.display = 'none';  
  }
}