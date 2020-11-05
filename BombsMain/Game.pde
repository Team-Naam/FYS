//Code credit Winand Metz

//Alles game gerelateerd
class Game {
  ObjectHandler objectHandler;
  MapHandler mapHandler;
  Sprites sprites;
  Player player;
  GraphicsEngine graphicsEngine;

  final int width, height;

  //Inladen van alle assets voor de game en level creation dmv inladen van een png map, op basis van pixels plaatsing van objecten
  //TileSize is grote van de blokken in het plaatsingsgrid (tegelgrote)
  Game(int tileSize, int width, int height) {
    this.width =  width;
    this.height = height;
    sprites = new Sprites("data/text/textures.png", tileSize);
    objectHandler = new ObjectHandler(this.sprites);
    mapHandler = new MapHandler(tileSize);
    objectHandler.addPlayer();
    graphicsEngine = new GraphicsEngine();
  }

  //Oproepen van objecten in de game zodat ze worden getekend
  void update() {
    mapHandler.update();
    objectHandler.update();
    graphicsEngine.update();
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

    PGraphics wallLightMap;
    PGraphics wallInvShadowMap;

    PImage invLight;
    PImage shadowLight;

    PVector playerPos;

    GraphicsEngine() {
      emitterPlayer = new Emitter(objectHandler);
      playerPos = new PVector();
      invLight = loadImage("data/lightmaps/invlightmap_test.png");
      shadowLight = loadImage("data/lightmaps/shadowmap_test.png");
      floorInvShadowMap = createGraphics(1920, 1080, P2D);
      floorShadowMap = createGraphics(1920, 1080, P2D);
      floorLightMap = createGraphics(1920, 1080, P2D);
      floorTorchLight = createGraphics(1920, 1080, P2D);
      floorShadowMask = createGraphics(1920, 1080, P2D);
      floorInvShadowMask = createGraphics(1920, 1080, P2D);
      wallLightMap = createGraphics(1920, 1080, P2D);
      wallInvShadowMap = createGraphics(1920, 1080, P2D);
    }

    void update() {
      for (Object object : objectHandler.entries) {
        if (object.objectId == ObjectID.PLAYER) {
          playerPos.set(object.x, object.y);
        }
      }
      emitterPlayer.update(playerPos.x, playerPos.y);
      emitterPlayer.cast(objectHandler.entries);
    }

    void drawFloorLighting() {
      floorLightMap.beginDraw();
      floorLightMap.clear();
      floorLightMap.background(0);
      floorLightMap.shape(emitterPlayer.getShape(255));
      floorLightMap.endDraw();

      floorTorchLight.beginDraw();
      floorTorchLight.clear();
      floorTorchLight.background(0);
      floorTorchLight.imageMode(CENTER);
      floorTorchLight.image(invLight, playerPos.x, playerPos.y);
      floorTorchLight.endDraw();

      floorLightMap.mask(floorTorchLight);

      floorInvShadowMask.beginDraw();
      floorInvShadowMask.clear();
      floorInvShadowMask.background(0);
      floorInvShadowMask.image(floorLightMap, 0, 0);
      floorInvShadowMask.endDraw();

      floorInvShadowMap.beginDraw();
      floorInvShadowMap.clear();
      floorInvShadowMap.background(0);
      floorInvShadowMap.endDraw();

      floorInvShadowMap.mask(floorInvShadowMask);

      floorShadowMask.beginDraw();
      floorShadowMask.clear();
      floorShadowMask.background(230);
      floorShadowMask.image(floorInvShadowMap, 0, 0);
      floorShadowMask.endDraw();

      floorShadowMap.beginDraw();
      floorShadowMap.clear();
      floorShadowMap.background(0);
      floorShadowMap.endDraw();

      floorShadowMap.mask(floorShadowMask);

      //image(lightMap, 0, 0);
      //image(lightMapOutput, 0, 0);
      //image(shadowMask, 0, 0);
      //image(shadowMap, 0, 0);
      //image(lightMask, 0, 0);
      image(floorShadowMap, 0, 0);
    }

    void draw() {
      wallLightMap.beginDraw();
      wallLightMap.clear();
      wallLightMap.background(230);
      wallLightMap.imageMode(CENTER);
      wallLightMap.image(shadowLight, playerPos.x, playerPos.y);
      wallLightMap.endDraw();
      
      wallInvShadowMap.beginDraw();
      wallInvShadowMap.clear();
      wallInvShadowMap.background(0);
      wallInvShadowMap.endDraw();
      
      wallInvShadowMap.mask(wallLightMap);

      //image(wallLightMap, 0, 0);
      image(wallInvShadowMap, 0 ,0);
    }
  }
}

//-----------------------------Highscore---------------------------------

class HighScore {
  int score, timeScore;
  int timer, time;

  HighScore() {
    score = 0;
    timeScore = TIME_SCORE;
    timer = FRAMERATE * TIME_SCORE_TIMER;
    time = 0;
  }

  //iedere sec komt er score bij
  void update() {
    time += 1;
    if (time == timer) {
      score += timeScore;
      time = 0;
    }
  }
  //als je buiten deze class score wilt toevoegen
  void addScore(int amount) {
    score += amount;
  }
}
