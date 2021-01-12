//Page code credit Ole Neuman, Winand Metz

//Code credit Ole Neuman
import java.util.Queue;
import java.util.ArrayDeque;

//This class handles everything that has to do with the map 
class MapHandler { 

  IntList mapList; 
  Queue<Integer> mapQueue;
  PImage newMap; 
  int tileSize; 
  float mapScrollSpeed; 
  float baseScrollSpeed;
  float mapPositionTracker; 
  float fastforwardWidth;
  float offSet; 
  int mapAmount; 
  int numberOfMapsLoaded;
  boolean mapScrolling;
  boolean mapEvent;

  String bossToBeSpawned;

  MapHandler(int sizeOfTiles) { 
    mapList = new IntList();
    mapQueue = new ArrayDeque<Integer>(50);
    for (int i = 0; i < LEVEL_AMOUNT; i++) {
      mapList.append(i);
    }
    addTutorial();
    mapPositionTracker = 0; 
    tileSize = sizeOfTiles; 
    baseScrollSpeed = MAP_SCROLL_SPEED; 
    mapScrollSpeed = baseScrollSpeed;
    offSet = MAP_OFFSET; 
    mapAmount = LEVEL_AMOUNT;
    mapScrolling = false;
    mapEvent = false;
    fastforwardWidth = 0.60;
    numberOfMapsLoaded = 0;
    bossToBeSpawned = "";
  } 

  void update() { 
    mapScrollSpeed = baseScrollSpeed;
    if (!mapScrolling) mapScrollSpeed = 0;
    fastMapForward();
    mapPositionTracker -= mapScrollSpeed; 
    if (mapPositionTracker <= 0) { 
      mapEventHandler();
      if (mapEvent == false) {
        loadNormalMap(); 
        //println("Generating new map");
      } 
      
      if (mapEvent == true && mapPositionTracker <= -128) {
        mapScrolling = false;
        fastforwardWidth = 1;
        spawnBoss();
        mapEvent = false;
        offSet -= 128;
      }
    }
  }

  void fastMapForward() {
    if (game.objectHandler.entities.get(0).x > width * fastforwardWidth) {
      if (fastforwardWidth != 0.75) {
        mapScrolling = true;
        fastforwardWidth = 0.75;
      }
      mapScrollSpeed += 0.5;
    }
  }

  void generateMap(ObjectHandler objectHandler) { 
    loadMap(newMap.pixels, newMap.width, newMap.height, tileSize, tileSize, objectHandler, offSet);
    mapPositionTracker += offSet; 
    offSet = floor(newMap.width * tileSize); 
    numberOfMapsLoaded += 1;
  } 

  void mapEventHandler() {
    //switch(numberOfMapsLoaded) {
    //}
    //if (mapEvent) {
    //}

    if (numberOfMapsLoaded % 5 == 0 && numberOfMapsLoaded != 0 && !mapEvent) {
      generateBossMap();
      mapEvent = true;
    }
  }


  void loadNormalMap() {
    if (mapQueue.peek() != null) {
      int mapFileNumber = mapQueue.remove();
      loadNormalMapImage(mapFileNumber);
    } else {
      generateQueue();
    }
  }

  void loadNormalMapImage(int mapFileNumber) { 
    if (mapFileNumber >= 0) {
      newMap = loadImage("data/maps/main/map" + mapFileNumber + ".png"); 
      newMap.loadPixels();
    } else {
      newMap = loadImage("data/maps/start/tutorial" + (-mapFileNumber - 1) + ".png"); 
      newMap.loadPixels();
    }
    generateMap(game.objectHandler);
  }

  void generateQueue() {
    IntList maps = mapList;
    while (maps.size() > 0) {
      int randomMapIndex = int(random(0, maps.size()));
      mapQueue.add(maps.get(randomMapIndex));
      maps.remove(randomMapIndex);
    }
  }

  void generateBossMap() {
    bossToBeSpawned = randomBoss();
    newMap = loadImage("data/maps/bosses/" + bossToBeSpawned + "_map.png");
    newMap.loadPixels();
    generateMap(game.objectHandler);
    numberOfMapsLoaded += 1;
  }

  void addTutorial() {
    mapQueue.add(-1);
    mapQueue.add(-2);
  }

  void spawnBoss() {
    switch(bossToBeSpawned) {
    case "spider":
      game.objectHandler.addSpiderQueen(1200, 540, tileSize, tileSize);
      break;

    case "wall":
      game.objectHandler.addMovingWall(1200, 540, tileSize, tileSize);
      break;
    }
  }

  String randomBoss() {
    int boss = int(random(1, 3));
    switch(boss) {
    case 1:
      return "spider";

    case 2:
      return "wall";

    default:
      return "spider";
    }
  }
}

//-----------------------------Maploader---------------------------------

/* Code credit Winand Metz
 Het bepalen van de plaatsing van objecten in het level dmv aflezen pixel colorcodes(android graphics color) en dit omzetten in een grid van 15 bij 8
 Orginele bron, afgeleid van: https://github.com/jarlah/WizardGame/blob/master/MapLoader.pde*/
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
        objectHandler.addEnemy(x * tw + offSet, y * th, tw, th);
      }
      //Hexode = 00a0c8
      if (c == 0xFF000000) {
        objectHandler.addSpider(x * tw + offSet, y * th, tw, th);
      }
      //Hexcode = 76428a
      if (c == 0xFF76428a) {
        objectHandler.addBreakableWall(x * tw + offSet, y * th, tw, th);
      }
      //Hexcode = 222034
      if (c == 0xFF222034) {
        objectHandler.addSpiderQueen(x * tw + offSet, y * th, tw, th);
      }
      //Hexcode = 45283c
      if (c == 0xFF45283c) {
        objectHandler.addMovingWall(x * tw + offSet, y * th, tw, th);
      }
      //Hexcode = 696a6a
      if (c == 0xFF696a6a) {
        objectHandler.addRock(x * tw + offSet, y * th, tw, th);
      }
      //Hexcode = 6abe30
      if (c == 0xFF6abe30) {
        objectHandler.addBreakableObject(x * tw + offSet, y * th, tw, th);
      }
    }
  }
}
