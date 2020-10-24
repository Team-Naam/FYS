//Code Credit Ole Neuman
//This class handles everything that has to do with the map
class MapHandler {

  PImage newMap;
  int tileSize;
  float mapScrollSpeed;
  float mapPositionTracker;
  float offSet;
  int mapAmount;

  MapHandler(int sizeOfTiles) {
    mapPositionTracker = 0;
    tileSize = sizeOfTiles;
    mapScrollSpeed = 1;
    offSet = 0;
    mapAmount = 3;
  }

  void update() {
    mapPositionTracker -= mapScrollSpeed;
    if (mapPositionTracker <= 0) { 
      generateMap(game.objectHandler);
      println("Generating new map");
    }
  }

  void generateMap(ObjectHandler objectHandler) {
    loadMapImage();
    loadMap(newMap.pixels, newMap.width, newMap.height, tileSize, tileSize, objectHandler, offSet);
    mapPositionTracker += offSet;
    println("mapWidth = " + newMap.width);
    offSet = newMap.width * tileSize;
    println("offSet = " + offSet);
  }

  void loadMapImage() {
    int mapFileNumber = int(random(1, mapAmount));
    newMap = loadImage("data/maps/map" + mapFileNumber + ".png");
    newMap.loadPixels();
  }

  void moveMap(Object object) {
    object.x -= mapScrollSpeed;
  }
}
