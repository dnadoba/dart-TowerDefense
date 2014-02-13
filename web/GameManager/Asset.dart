part of GameManager;

abstract class Asset<T>{
  String src;
  Completer completer = new Completer();
  Future get ready => completer.future;
  
  Asset(this.src){
    
  }
  
  T get();
  void load(){
    if(completer.isCompleted){
      return;
    }
    _load(src, true)
      .then(
        completer.complete, 
        onError: completer.completeError
      );
  }
  Future _load(String src, [bool retryOnError = true]);
}

class ImageAsset extends Asset<ImageElement>{
  
  ImageElement image;
  
  ImageAsset(String src) : super(src){
    
  }
  
  ImageElement get(){
    return image;
  }
  
  Future _load(String src, [bool retryOnError = true]){    
    Completer completer = new Completer();
    
    image = new ImageElement();
    image.onLoad.first.then((e){
      completer.complete();
    });
    image.onError.first.then((e){
      if(retryOnError){
        _load(src, false).then(completer.complete, onError: completer.completeError);
      }else{
        completer.completeError(e);
      }
    });
    image.src = src;
    
    return completer.future;
  }
}