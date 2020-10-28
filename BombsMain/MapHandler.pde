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
    mapScrollSpeed = MAP_SCROLL_SPEED; 
    offSet = MAP_OFFSET; 
    mapAmount = LEVELS; 
  } 
 
  void update() { 
    mapPositionTracker -= mapScrollSpeed; 
    if (mapPositionTracker <= 0) {  
      generateMap(game.objectHandler); 
      //println("Generating new map"); 
    } 
  } 
 
  void generateMap(ObjectHandler objectHandler) { 
    loadMapImage(); 
    loadMap(newMap.pixels, newMap.width, newMap.height, tileSize, tileSize, objectHandler, offSet);
    mapPositionTracker += offSet; 
    //println("mapWidth = " + newMap.width); 
    offSet = newMap.width * tileSize; 
    //println("offSet = " + offSet); 
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

//Code credit Winand Metz
//Het bepalen van de plaatsing van objecten in het level dmv aflezen pixel colorcodes(android graphics color) en dit omzetten in een grid van 15 bij 8
void loadMap(int[] pixels, int w, int h, int tw, int th, ObjectHandler objectHandler, float offSet) {
  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++ ) {
      int loc = x + y * w;
      float c = pixels[loc];
      //Hexcode = 7f0622
      if (c == 0xFF7F0622) {
        objectHandler.addWall(x * tw + offSet, y * th, tw, th);
      }
      //Hexode = 000000
      if (c == 0xFF000000) {
        objectHandler.addSpider(x * tw + offSet, y * th, tw, th);
      }
      //Hexode = 00a0c8
      if (c == 0xFF00a0c8) {
        objectHandler.addGhost(x * tw + offSet, y * th, tw, th);
      }
      //Hexcode = ffdf8f
      if (c == 0xFFffdf8f) {
        objectHandler.addMummy(x * tw + offSet, y * th, tw, th);
      }
      //Hexcode = E4B6AD
      if (c == 0xFFE4B6AD) {
        objectHandler.addPoltergeist(x * tw + offSet, y * th, tw, th);
      }
      //Hexcode = 515151
      if (c == 0xFF515151) {
        objectHandler.addRock(x * tw + offSet, y * th, tw, th);
      }
    }
  }
}
