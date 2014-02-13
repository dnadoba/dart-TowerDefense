part of TowerDefense;



class TowerList{
  DivElement div = new DivElement();
  Container utili;
  
  num distanceForStart = 32;
  
  StreamController<Map> _onBuyController = new StreamController<Map>();
  Stream<Map> get onBuy => _onBuyController.stream; 
  
   TowerList(List<Map> config, this.utili){
     div.id = "towerList";
     
     this.config(config);
   }
   void config(List<Map> config){
     for(Map<String, dynamic> towerConfig in config){
       add(towerConfig);
     }
   }
   void add(Map<String, dynamic> config){
     ImageElement img = config['assets']['bitmap'].get();
     img = img.clone(false);
     
     DivElement div = new DivElement()
       ..classes.add('tower')
       ..append(img);
     Stream mouseDown = mergeStreams(div.onMouseDown, div.onTouchStart);
    
     mouseDown.listen((e) => onMouseDown(e, config));
     
     // Prevent Default
     Stream mouseMove = mergeStreams(div.onMouseMove, div.onTouchMove);
     mouseMove.listen((e){
       e.preventDefault();
       return false;
     });
     
     this.div.append(div);
   }
   bool onMouseDown(e, Map<String, dynamic> target){
     e.preventDefault();
     
     Point startMousePos = getMousePos(e);
     
     Stream mouseMove = mergeStreams(window.onMouseMove, window.onTouchMove);
     StreamSubscription mouseMoveSub;
     mouseMoveSub = mouseMove.listen((e){
        e.preventDefault();
        Point crtMousePos = getMousePos(e);
        if(startMousePos.distanceTo(crtMousePos) >= distanceForStart){
          startMouseMove(e, target);
          mouseMoveSub.cancel();
        }
     });
     
     Stream mouseUp = mergeStreams(window.onMouseUp, window.onTouchEnd);
    
     mouseUp.first.then((e){
       e.preventDefault();
       mouseMoveSub.cancel();
       
     });
     
   }
   void startMouseMove(e, Map<String, dynamic> target){
     Container tower = new Container();
     
     SimpleCircle towerRange = new SimpleCircle(target['range']);
     towerRange.reg.setValues(32.0, 32.0);
     towerRange.fillStyle = 'rgba(69, 229, 48, 0.2)';
     towerRange.strockeStyle = 'rgba(69, 229, 48, 0.8)';
     
     
     Bitmap towerBitmap = new Bitmap(target['assets']['bitmap'].get());
     
     tower.add(towerRange);
     tower.add(towerBitmap);
     utili.add(tower);
     
     Stream mouseMove = mergeStreams(window.onMouseMove, window.onTouchMove);
     
     StreamSubscription mouseMoveSub = mouseMove.listen((e) => onMouseMove(e, target, tower));
     
     Stream mouseUp = mergeStreams(window.onMouseUp, window.onTouchEnd);
    
     mouseUp.first.then((e){
       mouseMoveSub.cancel();
       return onMouseUp(e, target, tower); 
     });
     
     onMouseMove(e, target, tower);
   }
   bool onMouseMove(e, Map<String, dynamic> target, Container tower){
     e.preventDefault();
     Point mousePos = getMousePos(e);
     Vector2 pos = TowerDefense.getPos(TowerDefense.getTilePos(new Vector2(mousePos.x.toDouble(), mousePos.y.toDouble())));
     tower.pos.setFrom(pos);
     return false;
   }
   bool onMouseUp(e, Map<String, dynamic> target, Container tower){
     e.preventDefault();
     Point mousePos = getMousePos(e);
     tower.remove();
     _onBuyController.add({
       "config" : target,
       "startPos" : TowerDefense.getTilePos(new Vector2(mousePos.x.toDouble(), mousePos.y.toDouble()))
     });
     return false;
   }
}