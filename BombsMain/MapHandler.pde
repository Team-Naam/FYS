//Code Credit Ole Neuman 
//This class handles everything that has to do with the map 
class MapHandler { 
 
  IntList mapList; 
  Queue<Integer> mapQueue;
  PImage newMap; 
  int tileSize; 
  float mapScrollSpeed; 
  float mapPositionTracker; 
  float offSet; 
  int mapAmount; 
 
  MapHandler(int sizeOfTiles) { 
    mapList = new IntList();
    mapQueue = new ArrayDeque<Integer>(50);
    for (int i = 0; i < LEVEL_AMOUNT; i++) {
      mapList.append(i);
    }
    addTutorial();
    mapPositionTracker = 0; 
    tileSize = sizeOfTiles; 
    mapScrollSpeed = MAP_SCROLL_SPEED; 
    offSet = MAP_OFFSET; 
    mapAmount = LEVEL_AMOUNT;
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
    offSet = floor(newMap.width * tileSize); 
    //println("offSet = " + offSet); 
  } 
 
  void loadMapImage() { 
    if (mapQueue.peek() != null) {
      int mapFileNumber = mapQueue.remove();
      if (mapFileNumber >= 0) {
        newMap = loadImage("data/maps/main/map" + mapFileNumber + ".png"); 
        newMap.loadPixels();
      } else {
        newMap = loadImage("data/maps/start/tutorial" + (-mapFileNumber - 1) + ".png"); 
        newMap.loadPixels();
      }
    } else {
      generateQueue();
    }
  }

  void generateQueue() {
    IntList maps = mapList;
    while (maps.size() > 0) {
      int randomMapIndex = int(random(0, maps.size()));
      mapQueue.add(maps.get(randomMapIndex));
      maps.remove(randomMapIndex);
    }
    loadMapImage();
  }

  void addTutorial() {
    mapQueue.add(-1);
    mapQueue.add(-2);
  }
}



//Code credit Winand Metz
//Het bepalen van de plaatsing van objecten in het level dmv aflezen pixel colorcodes(android graphics color) en dit omzetten in een grid van 15 bij 8
void loadMap(int[] pixels, int w, int h, int tw, int th, ObjectHandler objectHandler, float offSet) {
  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++ ) {
      int loc = x + y * w;
      float c = pixels[loc];
      //Hexcode = 595652
      if (c == 0xFF595652) {
        objectHandler.addWall(x * tw + offSet, y * th, tw, th);
      }
      //Hexode = ac3232
      if (c == 0xFFac3232) {
        //objectHandler.addEntity(x * tw + offSet, y * th, tw, th);
        objectHandler.addEnemy(x * tw + offSet, y * th, tw, th);
      }
      //Hexode = 00a0c8
      if (c == 0xFF00a0c8) {

      }
      //Hexcode = 76428a
      if (c == 0xFF76428a) {
        objectHandler.addBreakableWall(x * tw + offSet, y * th, tw, th);
      }
      //Hexcode = E4B6AD
      if (c == 0xFFE4B6AD) {

      }
      //Hexcode = 696a6a
      if (c == 0xFF696a6a) {
        objectHandler.addRock(x * tw + offSet, y * th, tw, th);
      }
    }
  }
}
