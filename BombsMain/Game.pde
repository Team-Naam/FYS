//Page code credit Winand Metz, Jordy Post

//Code credit Winand Metz
class Game {
  Timer timer;
  Timer musicTimer;
  ObjectHandler objectHandler;
  MapHandler mapHandler;
  TextureAssets textureLoader;
  Highscore highscore;
  GraphicsEngine graphicsEngine;
  UserInterface userInterface;
  Background background;
  SoundAssets soundLoader;
  ServerHandler serverHandler;

  final int width, height;

  boolean playMusic, playAmbience;

  Game(int tileSize, int width, int height, TextureAssets textureAssets, SoundAssets soundAssets, ServerHandler databaseLoader) {
    this.width = width;
    this.height = height;
    this.serverHandler = databaseLoader;
    textureLoader = textureAssets;
    soundLoader = soundAssets;
    highscore = new Highscore(serverHandler);
    objectHandler = new ObjectHandler(this.textureLoader, this.soundLoader);
    objectHandler.addPlayer(this.highscore);
    objectHandler.addFix();
    background = new Background(textureLoader, tileSize);
    mapHandler = new MapHandler(tileSize);
    graphicsEngine = new GraphicsEngine();
    userInterface = new UserInterface(this.textureLoader, this.highscore, this.objectHandler);
    timer = new Timer("gameTimer");
    playMusic();
    musicTimer = new Timer("musicTimer");
    isPlaying = true;
  }

  //Eerst worden alle updates uitgevoerd, voordat de draw wordt uitgevoerd
  void update() {
    //Boolean voor het settings menu, zodat het de correcte tekst laat zien van return to game i.p.v. main menu
    inMainMenu = false;

    if (!soundAssets.ambient_track.isPlaying() && !inMainMenu) {
      playAmbience();
    }

    if (musicTimer.startTimer(240000)) {
      playMusic();
    }

    soundAssets.stopMainMenuMusic();

    mapHandler.update();
    background.update();
    objectHandler.update();
    highscore.update();
    graphicsEngine.update();
    userInterface.update();

    /* Als op escape wordt gedrukt ingame, wordt het spel op pauze gezet
     De timer is bedoeld zodat er niet een glitch ontstaat van een oneindige pause menu loop */
    if (input.escapeDown() && timer.startTimer(ESC_SELECT_TIMER)) {
      isPlaying = false;
    }
  }

  void draw() {
    background(BACKGROUND_COLOR);

    if (playAmbience) {
      soundAssets.getAmbientTrack();
      playAmbience = false;
    }

    if (playMusic) {
      soundAssets.getGameTrack();
      playMusic = false;
    }

    //In het pauze menu is de achtergrond de game zelf, om resources te besparen worden de berekeningen voor de lighting engine stop gezet
    if (!isPlaying) {
      graphicsEngine.update();
    }

    background.draw();
    graphicsEngine.drawFloorLighting();
    objectHandler.draw();
    graphicsEngine.draw();
    userInterface.draw();
  }

  void playMusic() {
    playMusic = true;
  }

  void playAmbience() {
    playAmbience = true;
  }

  //-----------------------------Graphics engine---------------------------------

  class GraphicsEngine {
    final int GE_WHITE_MASK = 255;

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
      //Neemt de locatie van de speler
      ArrayList<Object> entityObjects = objectHandler.entities;
      Object playerEntity = entityObjects.get(0);
      playerPos.set(playerEntity.x, playerEntity.y);

      //Updates de positie van de emitter en schiet de rays richting de muren
      emitterPlayer.update(playerPos.x, playerPos.y);
      emitterPlayer.cast(objectHandler.walls);
    }

    //Tekent de bewegende shaduwen op de vloer
    void drawFloorLighting() {
      //Bepaald hoe het licht op de vloer valt op basis van een variant van path tracing
      floorLightMap.beginDraw();
      floorLightMap.clear();
      floorLightMap.background(0);
      floorLightMap.shape(emitterPlayer.getShape(GE_WHITE_MASK));
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

  //-----------------------------Paths & Background---------------------------------

  class Background {
    final int BG_AMOUNT = 170;
    final int BG_COLS = 17;
    final int BG_ROWS = 10;

    //De path objecten array voor een continuerende hergebruik van de objecten 
    Path[] backgrounds = new Path[BG_AMOUNT];

    float x, y;
    int cols = BG_COLS;
    int rows = BG_ROWS;
    int amount = BG_AMOUNT;

    Background(TextureAssets sprites, int tileSize) {
      //Array wordt gevuld met path objecten zodat het hele scherm belegd is
      int k = 0;
      for (int i = 0; i < cols; i++) {
        for (int j = 0; j < rows; j++) {
          backgrounds[k] = new Path(i * tileSize, j * tileSize - OBJECT_Y_OFFSET, tileSize, tileSize, objectHandler, sprites, soundAssets);

          k++;
        }
      }
    }

    //De update en movement worden eerst uitgevoerd voordat ze worden getekend 
    void update() {
      for (int i = 0; i < backgrounds.length; i++) {
        backgrounds[i].moveMap();
        backgrounds[i].update();
      }
    }

    void draw() {
      for (int i = 0; i < backgrounds.length; i++) {
        backgrounds[i].draw();
      }
    }
  }
}

//-----------------------------Highscore---------------------------------

//Code credit Jordy Post
class Highscore {
  int score, timeScore, timer;
  boolean scoreAdded;
  ServerHandler serverHandler;

  Highscore(ServerHandler serverHandler) {
    this.serverHandler = serverHandler;
    score = 0; 
    timeScore = TIME_SCORE;
    timer = TIME_SCORE_TIMER;
    scoreAdded = false;
  }

  //iedere sec komt er score bij
  void update() {
    switch(gameState) {
    case 1:
      timer --;
      if (timer == 0) {
        score += timeScore;
        timer = TIME_SCORE_TIMER;
      }
      break;
    case 2:
      //als gameState gameover is en de highscores nog niet geupdate zijn worden de scores geupdate
      if (scoreAdded == false) {
        updateHighscores();
      }
      break;
    }
  }

  //update de highscorelist
  void updateHighscores() {
    //zet de highscore in de tabel
    serverHandler.updateHighscores(score);
    scoreAdded = true;
  }

  //als je buiten deze class score wilt toevoegen
  void addScore(int amount) {
    score += amount;
  }
}
