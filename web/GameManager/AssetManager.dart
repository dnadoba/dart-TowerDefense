part of GameManager;



class AssetManager{
  
  static Map<String, Asset> assets = new Map<String, Asset>();
  
  static StreamController<num> onProgressController = new StreamController<num>.broadcast();
  static Stream<num> get onProgress =>
      onProgressController.stream;
  
  static Asset add(src){
    if(!assets.containsKey(src)){
      assets[src] = _createAsset(src);
    }
    return assets[src];
  }
  
  static Asset addAll(List<String> srcs){
    srcs.forEach((src) => add(src));
  }
  
  static Asset _createAsset(String src){
    String ext = extension(src).toLowerCase();
    switch(ext){
      case '.png':
      case '.jpg':
      case '.jpeg':
      case '.gif':
        return new ImageAsset(src);
    }
  }
  
  static Future load(){
    int loaded = 0;
    List<Future> assetFutures = new List<Future>();
    assets.forEach((String src, Asset asset){
      Future assetReady = asset.ready;
      assetFutures.add(assetReady);
      asset.load();
      
      assetReady.then((e){
        loaded++;
        onProgressController.add(loaded/assetFutures.length);
      });
    });
    return Future.wait(assetFutures);
  }
  
  static Asset get(String src){
    return assets[src];
  }
  
}