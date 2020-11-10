//Code credit Winand Metz

//Alles game gerelateerd
class Game {
  ObjectHandler objectHandler;
  MapHandler mapHandler;
  Sprites sprites;
  Player player;
  GraphicsEngine graphicsEngine;
  Highscore highscore;

  final int width, height;

  //Inladen van alle assets voor de game en level creation dmv inladen van een png map, op basis van pixels plaatsing van objecten
  //TileSize is grote van de blokken in het plaatsingsgrid (tegelgrote)
  Game(int tileSize, int width, int height) {
    this.width =  width;
    this.height = height;
    sprites = new Sprites("data/text/textures.png", tileSize);
    objectHandler = new ObjectHandler(this.sprites);
    objectHandler.addPlayer();
    mapHandler = new MapHandler(tileSize);
    graphicsEngine = new GraphicsEngine();
    highscore = new Highscore();
  }

  //Oproepen van objecten in de game zodat ze worden getekend
  void update() {
    mapHandler.update();
    objectHandler.update();
    graphicsEngine.update();
    highscore.update();
  }

  void draw() {
    background(128);
    graphicsEngine.drawFloorLighting();
    objectHandler.draw();
    graphicsEngine.draw();
  }

  //-----------------------------Graphics engine---------------------------------

  class GraphicsEngine {

    Emitter emitterPlayer;

    PGraphics floorLightMap;
    PGraphics floorTorchLight;
    PGraphics floorShadowMask;
    PGraphics floorInvShadowMask;
    PGraphics floorInvShadowMap;
    PGraphics floorShadowMap;

    PGraphics wallLightMask;
    PGraphics wallLightMap;

    PImage torchLight;
    PImage invTorchLight;

    PVector playerPos;

    GraphicsEngine() {
      emitterPlayer = new Emitter(objectHandler);
      playerPos = new PVector();
      torchLight = loadImage("data/lightmaps/torch.png");
      invTorchLight = loadImage("data/lightmaps/inv_torch.png");
      floorInvShadowMap = createGraphics(1920, 1080, P2D);
      floorShadowMap = createGraphics(1920, 1080, P2D);
      floorLightMap = createGraphics(1920, 1080, P2D);
      floorTorchLight = createGraphics(1920, 1080, P2D);
      floorShadowMask = createGraphics(1920, 1080, P2D);
      floorInvShadowMask = createGraphics(1920, 1080, P2D);
      wallLightMask = createGraphics(1920, 1080, P2D);
      wallLightMap = createGraphics(1920, 1080, P2D);
    }

    void update() {
      ArrayList<Object> entityObjects = objectHandler.entities;
      Object playerEntity = entityObjects.get(0);
      playerPos.set(playerEntity.x, playerEntity.y);
      emitterPlayer.update(playerPos.x, playerPos.y);
      emitterPlayer.cast(objectHandler.walls);
    }

    //Tekent de bewegende shaduwen op de vloer
    void drawFloorLighting() {
      //Bepaald hoe het licht op de vloer valt op basis van een variant van path tracing
      floorLightMap.beginDraw();
      floorLightMap.clear();
      floorLightMap.background(0);
      floorLightMap.shape(emitterPlayer.getShape(255));
      floorLightMap.endDraw();

      //Bepaald de grote van het fakkel licht van de player dmv een png
      floorTorchLight.beginDraw();
      floorTorchLight.clear();
      floorTorchLight.background(0);
      floorTorchLight.imageMode(CENTER);
      floorTorchLight.image(torchLight, playerPos.x, playerPos.y);
      floorTorchLight.endDraw();

      //Zorgt ervoor dat path tracing alleen voordoet binnen het fakkel licht
      floorLightMap.mask(floorTorchLight);

      //Maakt een mask van de floorLightMap die inverted is, oftwel de inverted shadow mask
      floorInvShadowMask.beginDraw();
      floorInvShadowMask.clear();
      floorInvShadowMask.background(0);
      floorInvShadowMask.image(floorLightMap, 0, 0);
      floorInvShadowMask.endDraw();

      //Basis layer voor de inverted shadow map
      floorInvShadowMap.beginDraw();
      floorInvShadowMap.clear();
      floorInvShadowMap.background(0);
      floorInvShadowMap.endDraw();

      //Zet de inverted shadow mask om in de inverted shadow map
      floorInvShadowMap.mask(floorInvShadowMask);

      //Tekend de shadow mask, dit bepaald waar de schaduwen komen en hoe sterk ze zijn
      floorShadowMask.beginDraw();
      floorShadowMask.clear();
      floorShadowMask.background(FLOOR_SHADOW_STRENGTH);
      floorShadowMask.image(floorInvShadowMap, 0, 0);
      floorShadowMask.endDraw();

      //Tekend de shadow map, dit is wat uiteindelijk te zien is op het scherm
      floorShadowMap.beginDraw();
      floorShadowMap.clear();
      floorShadowMap.background(0);
      floorShadowMap.endDraw();

      //Zet de shadow mask om in de shadow map die geprojecteerd wordt
      floorShadowMap.mask(floorShadowMask);

      //Aantal check functies
      //image(lightMap, 0, 0);
      //image(lightMapOutput, 0, 0);
      //image(shadowMask, 0, 0);
      //image(shadowMap, 0, 0);
      //image(lightMask, 0, 0);
      image(floorShadowMap, 0, 0);
    }

    void draw() {
      //Dit is de light mask voor de muren en entities, laad de grote van het fakkel licht en de sterkte van de schaduwen in en zet dit om in een mask
      wallLightMask.beginDraw();
      wallLightMask.clear();
      wallLightMask.background(ENVIROMENT_SHADOW_STRENGHT);
      wallLightMask.imageMode(CENTER);
      wallLightMask.image(invTorchLight, playerPos.x, playerPos.y);
      wallLightMask.endDraw();

      //De uiteindelijke light map die te zien is op het scherm
      wallLightMap.beginDraw();
      wallLightMap.clear();
      wallLightMap.background(0);
      wallLightMap.endDraw();

      //Zet de mask om in een light map
      wallLightMap.mask(wallLightMask);

      //Check functie
      //image(wallLightMap, 0, 0);
      image(wallLightMap, 0, 0);
    }
  }
}

//-----------------------------Highscore---------------------------------

class Highscore {
  int score, timeScore;
  int timer, time;
  boolean tempGameOver;
  int[] highscoreList;
  boolean scoreAdded;

  Highscore() {
    score = 0;
    highscoreList = new int[HIGHSCORE_LIST_LENGTH];
    timeScore = TIME_SCORE;
    timer = FRAMERATE * TIME_SCORE_TIMER;
    time = 0;
    for (int i = 0; i < highscoreList.length; i++) {
      highscoreList[i] = 0;
    }
    tempGameOver = false;
    scoreAdded = false;
  }

  //iedere sec komt er score bij
  void update() {
    if (tempGameOver == false) {
      time += 1;
      if (time == timer) {
        score += timeScore;
        time = 0;
      }
      //om te kunnen testen zonder een echte gameover te hebben
      if (score >= 200) {
        tempGameOver = true;
      }
    } else {
      // als gameover true is en de highscores nog niet geupdate zijn worden de scores geupdate
      if (scoreAdded == false) {
        updateHighscores();
      }
    }
  }
  
  void printHighscores() {
    //print de highscores in de console
    for (int i = 0; i < highscoreList.length; i++) {
      println(i+1 + " " + highscoreList[i]);
    }
  }
  //update de highscorelist
  void updateHighscores() {
    //als het een nieuwe hoogste score is
    if (score > highscoreList[0]) {
      for (int j = highscoreList.length -1; j >= 1; j--) {
        highscoreList[j] = highscoreList[j -1];
      }
      
      highscoreList[0] = score;
      scoreAdded = true;
      score = 0;
    }
    
    for (int i = 1; i < highscoreList.length; i++) {
      if (score > highscoreList[i] && score <= highscoreList[i -1]) {
        for (int j = highscoreList.length -1; j > i; j--) {
          highscoreList[j] = highscoreList[j -1];
        }

        highscoreList[i] = score;
        scoreAdded = true;
        score = 0;
      }
    }
    printHighscores();
  }
  
  //als je buiten deze class score wilt toevoegen
  void addScore(int amount) {
    score += amount;
  }
}
