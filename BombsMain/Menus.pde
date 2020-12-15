//all code that has to do with the Main Menu of the game
//code credit Ole Neuman

class MainMenu {

  TextureAssets sprites;
  SoundAssets soundAssets;
  Timer timer;

  MenuBox[] boxArray = new MenuBox[MENUBOX_AMOUNT];

  int boxSelected;
  int moveCooldown;

  PImage logo;

  MainMenu(TextureAssets textureLoader, SoundAssets soundAssets) {
    for (int i = 0; i < MENUBOX_AMOUNT; i++) {
      boxArray[i] = new MenuBox(1520, height / 2 + i * (height / 6), 200, height / 8, 40, textureLoader);
    }

    timer = new Timer("menuTimer");

    boxArray[0].boxText = "Start";
    boxArray[1].boxText = "Quit";

    boxSelected = 0;

    moveCooldown = 0;
    this.sprites = textureLoader;
    this.soundAssets = soundAssets;
  }

  void draw() {
    background(MENU_BACKGROUND_COLOUR);
    image(sprites.getMenuBackground(), 0, 0);
    image(sprites.getLogo(), 20, height - 131, 200, 111);

    textSize(48);

    fill(128);
    text("BombRunner", 1562, 402);

    fill(255);
    text("BombRunner", 1560, 400);
    for (MenuBox menuBox : boxArray) {
      menuBox.draw();
    }
  }

  void update() {
    for (MenuBox menuBox : boxArray) {
      menuBox.selected = false;
    }

    boxArray[boxSelected].selected = true;


    if (input.upDown() && moveCooldown == 0) {
      if (boxSelected == 0) boxSelected = MENUBOX_AMOUNT - 1;
      else boxSelected--;
      moveCooldown = MENU_MOVE_COOLDOWN;
      soundAssets.getMenuHover();
    }

    if (input.downDown() && moveCooldown == 0) {
      if (boxSelected == MENUBOX_AMOUNT - 1) boxSelected = 0;
      else boxSelected++;
      moveCooldown = MENU_MOVE_COOLDOWN;
      soundAssets.getMenuHover();
    }

    if (moveCooldown > 0) moveCooldown--;

    if (input.xDown() && timer.startTimer(100)) {
      soundAssets.getMenuSelect();
      switch(boxSelected) {

      case 0:
        gameState = 1;
        break;

      case 1:
        exit();
        return;

      default:
        gameState = 1;
      }
    }
  }
}

class MenuBox {
  TextureAssets sprites;
  SpriteSheetAnim keyX;

  float posX, posY;
  int boxWidth, boxHeight, textSize;

  color textColour;

  String boxText;

  boolean selected;

  MenuBox(float positionX, float positionY, int Width, int Height, int size, TextureAssets textureLoader) {
    this.sprites = textureLoader;
    keyX = new SpriteSheetAnim(sprites.itemsBombsUI, 3, 2, 6);
    posX = positionX;
    posY = positionY;
    boxWidth = Width;
    boxHeight = Height;
    textColour = BOX_TEXT_COLOUR;
    boxText = "";
    textSize = size;
    selected = false;
  }

  void draw() {
    update();
    fill(textColour);
    textSize(textSize);
    text(boxText, posX + boxWidth / 2, posY + boxHeight / 2);
    if (selected) {
      keyX.draw();
    }
  }

  void update() {
    keyX.update(posX, posY + 45);
    if (selected) {
      textColour = BOX_TEXT_COLOUR;
    } else {
      textColour = 128;
    }
  }
}

//code credit Jordy
//gameOver scherm
class GameOver {
  TextureAssets sprites;
  Highscore highscore;

  GameOver(TextureAssets textureLoader) {
    this.sprites = textureLoader;
  }

  void update(Highscore highscore) {
    this.highscore = highscore;
    if (input.escapeDown()) {
      toMainMenu();
    }
  }

  void draw() {
    background(MENU_BACKGROUND_COLOUR);
    image(sprites.getLogo(), 20, height - 131, 200, 111);
    fill(0);
    textSize(50);
    text("GAME OVER", width / 2 -150, height / 4);
    textSize(40);
    text("SCORE: " + highscore.score, width / 2 -125, height / 4 + 100);
  }
}

class HighscoreMenu {
  TextureAssets sprites;
  ServerHandler serverHandler;
  Table highscores;
  
  HighscoreMenu(TextureAssets textureLoader, ServerHandler serverHandler) {
    this.sprites = textureLoader;
    this.serverHandler = serverHandler;
    highscores = serverHandler.getHighscores(10);
  }

  void update() {
    if (input.escapeDown()) {
      toMainMenu();
    }
  }

  void draw() {
    background(MENU_BACKGROUND_COLOUR);
    image(sprites.getLogo(), 20, height - 131, 200, 111);
    
    fill(20);
    rect(width /2 - 250, 100, 550, 810);

    fill(255);
    //print de headers
    text("username", width / 2 -190, 200);
    text("score", width / 2 +110, 200);
    textSize(50);
    
    //print de table
    textSize(40);
    for (int i = 0; i < highscores.getRowCount(); i++) {
      TableRow row = highscores.getRow(i);
      for (int j = 0; j < row.getColumnCount(); j++) {
        text(row.getString(j), width / 2 -170 + 300 * j, 300 + 60 * i);
      }
    }
  }
}

class PauseMenu {
  MenuBox[] boxArray = new MenuBox[3];
  Timer timer;
  TextureAssets sprites;

  int boxxSelected;
  int moveCooldown;

  PauseMenu(TextureAssets textureLoader) {
    this.sprites = textureLoader;
    for (int i = 0; i < 3; i++) {
      boxArray[i] = new MenuBox(width / 2 - 225, height / 8 * i + 350, 200, height / 8, 32, textureLoader);
    }

    boxArray[0].boxText = "Resume";
    boxArray[1].boxText = "Settings";
    boxArray[2].boxText = "Exit to Main Menu";

    timer = new Timer("pauseMenuTimer");

    boxxSelected = 0;

    moveCooldown = 0;
  }

  void update() {
    if (input.escapeDown() && timer.startTimer(200)) {
      isPlaying = true;
    }

    for (MenuBox menuBox : boxArray) {
      menuBox.selected = false;
    }

    boxArray[boxxSelected].selected = true;


    if (input.upDown() && moveCooldown == 0) {
      if (boxxSelected == 0) {
        boxxSelected = 3 - 1;
      } else {
        boxxSelected--;
      }
      moveCooldown = MENU_MOVE_COOLDOWN;
      soundAssets.getMenuHover();
    }

    if (input.downDown() && moveCooldown == 0) {
      if (boxxSelected == 3 - 1) {
        boxxSelected = 0;
      } else {
        boxxSelected++;
      }
      moveCooldown = MENU_MOVE_COOLDOWN;
      soundAssets.getMenuHover();
    }

    if (moveCooldown > 0) {
      moveCooldown--;
    }

    if (input.xDown()) {
      soundAssets.getMenuSelect();
      switch(boxxSelected) {

      case 0:
        isPlaying = true;
        break;

      case 1:
        break;

      case 2:
        toMainMenu();
        break;

      default:
        isPlaying = true;
      }
    }
  }

  void draw() {
    fill(128);
    rect(width / 2 - 200, height / 4, 400, 600);

    fill(0, 200);
    rect(0, 0, width, height);

    for (MenuBox menuBox : boxArray) {
      menuBox.draw();
    }
  }
}

class SettingsMenu {
  TextureAssets sprites;

  SettingsMenu(TextureAssets textureLoader) {
    this.sprites = textureLoader;
  }

  void update() {
  }

  void draw() {
  }
}
