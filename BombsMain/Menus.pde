//Code credit Ole Neuman
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
      boxArray[i] = new MenuBox(1500, height / 3 + i * (height / 10), 200, height / 8, 40, textureLoader);
    }

    timer = new Timer("menuTimer");

    boxArray[0].boxText = "Start";
    boxArray[1].boxText = "Highscore";
    boxArray[2].boxText = "Achievements";
    boxArray[3].boxText = "Settings";
    boxArray[4].boxText = "Quit";

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
    text("BombRunner", 1562, 302);

    fill(255);
    text("BombRunner", 1560, 300);
    for (MenuBox menuBox : boxArray) {
      menuBox.draw();
    }

    fill(255);
    textSize(28);
    text("Userid =" + userID, width / 2, height - 32);
  }

  void update() {
    inMainMenu = true;

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

    if (input.xDown() && timer.startTimer(ESC_SELECT_TIMER)) {
      soundAssets.getMenuSelect();
      switch(boxSelected) {

      case 0:
        gameState = 1;
        break;

        // Highscore
      case 1:
        gameState = 3;
        break;

        // Achievements
      case 2:
        gameState = 4;
        break;

        // Settings
      case 3:
        gameState = 5;
        break;

        // Quit
      case 4:
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

  void update() {
    keyX.update(posX, posY + 45);
    if (selected) {
      textColour = BOX_TEXT_COLOUR;
    } else {
      textColour = 128;
    }
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
}

//code credit Jordy
class GameOver {
  TextureAssets sprites;
  Highscore highscore;
  ServerHandler serverHandler;
  int bestScore;

  GameOver(TextureAssets textureLoader, ServerHandler serverHandler) {
    this.sprites = textureLoader;
    this.serverHandler = serverHandler;
    bestScore = serverHandler.getHighscoreUser();
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
    fill(BOX_TEXT_COLOUR);
    
    textSize(50);
    text("GAME OVER", width / 2 -150, height / 4);
    
    textSize(40);
    text("SCORE: " + highscore.score, width / 2 -125, height / 4 + 100);
    text("BEST: " + bestScore, width / 2 -125, height / 4 + 150);
  }
}


//code Credit Ruben
class AchievementMenu {
  TextureAssets sprites;
  ServerHandler serverHandler;
  Table achievement, unlocked, date, ID;
  MenuBox[] boxArray = new MenuBox[4];
  Timer timer;

  int selected;

  boolean justChanged;

  AchievementMenu(TextureAssets textureLoader, ServerHandler serverHandler) {
    this.sprites = textureLoader;
    this.serverHandler = serverHandler;
    timer = new Timer("AchievementSelected");
    unlocked = serverHandler.getUnlocked();
    ID = serverHandler.getUnlockedOrderedByID();
    date = serverHandler.getUnlockedOrderedByDate();
    achievement = unlocked;


    for (int i = 0; i < boxArray.length; i++) {
      boxArray[i] = new MenuBox(width/2 - 1400, 100*i  +200, 1100, 510, 30, textureLoader);
    }

    boxArray[0].boxText = "Unlocked Achievements";
    boxArray[1].boxText = "Ordered By Achievement";
    boxArray[2].boxText = "Ordered By Date";
    boxArray[3].boxText = "Quit";


    selected = 0;
    justChanged = false;
  }

  void update() {
    if (input.escapeDown()) {
      toMainMenu();
    }
    if (input.xDown() && selected == 3 && timer.startTimer(200)) {
      toMainMenu();
    }
    if (input.downDown() && !justChanged) {
      selected++;
      if (selected > 3 ) selected = 0;
      updateSelected();
      justChanged = true;
    }

    if (input.upDown() && !justChanged) {
      selected --;
      if (selected < 0) selected = 3;
      updateSelected();
      justChanged = true;
    }

    if (justChanged) {
      if (timer.startTimer(100)) justChanged = false;
    }
  }

  void draw() {
    background(MENU_BACKGROUND_COLOUR);
    noStroke();
    image(sprites.getLogo(), 20, height - 131, 200, 111);

    fill(20);
    rect(width/2 - 500, 210, 450, 850, 100);
    rect(width/2 -10, 210, 600, 850, 100);
    rect(width/2 + 650, 210, 300, 850, 100); 

    fill(255);
    textSize(50);
    text("achievements", width / 2 -425, 200);
    text("description", width / 2 +155, 200);
    text("date", width / 2 + 750, 200);

    textSize(40);
    for (int i = 0; i < achievement.getRowCount(); i++) {
      TableRow row = achievement.getRow(i);
      for (int j = 0; j < 3 /*row.getColumnCount()*/; j++) {

        if (j == 0) {
          textSize(40);
          text(row.getString(j), width / 2 - 400, 300 + 60 * i);
        }

        if (j == 1) {
          textSize(30);
          text(row.getString(j), width / 2 + 10, 300 + 60 * i);
   
        }
        textSize(40);
        if (j == 2) {
          text(row.getString(j), width / 2 + 700, 300 + 60 * i);
        }
        //text(row.getString(j), width / 2 -170 + 300 * j, 300 + 60 * i);
      }
    }

    for (MenuBox menuBox : boxArray) {
      menuBox.draw();
    }
  }

  void updateSelected() {
    switch(selected) {
    case 0:
      boxArray[0].selected = true;
      boxArray[1].selected = false;
      boxArray[2].selected = false;
      boxArray[3].selected = false;
      achievement = unlocked;
      break;
    case 1:
      boxArray[0].selected = false;
      boxArray[1].selected = true;
      boxArray[2].selected = false;
      boxArray[3].selected = false;
      achievement = ID;
      break;
      case 2:
      boxArray[0].selected = false;
      boxArray[1].selected = false;
      boxArray[2].selected = true;
      boxArray[3].selected = false;
      achievement = date;
      break;
      case 3:
      boxArray[0].selected = false;
      boxArray[1].selected = false;
      boxArray[2].selected = false;
      boxArray[3].selected = true;
      achievement = unlocked;
    default:
      break;
    }
  }
}


//code credit Jordy
class HighscoreMenu {
  TextureAssets sprites;
  ServerHandler serverHandler;
  Table highscores, topHighscores, topPlayers, topHighscoresUser;
  MenuBox[] boxArray = new MenuBox[3];
  Timer timer;

  int selected;

  boolean justChanged;

  HighscoreMenu(TextureAssets textureLoader, ServerHandler serverHandler) {
    this.sprites = textureLoader;
    this.serverHandler = serverHandler;
    topHighscores = serverHandler.getTopHighscores(HIGHSCORE_TABLE_LIMIT);
    topPlayers = serverHandler.getTopPlayers(HIGHSCORE_TABLE_LIMIT);
    topHighscoresUser = serverHandler.getTopHighscoresUser(HIGHSCORE_TABLE_LIMIT);
    highscores = topHighscores;
    timer = new Timer("HighscoreSelected");

    for (int i = 0; i < boxArray.length; i++) {
      boxArray[i] = new MenuBox(width /2 - 1005, 100*i -50, 1100, 510, 30, textureLoader);
    }

    boxArray[0].boxText = "Best Scores";
    boxArray[1].boxText = "Best Players";
    boxArray[2].boxText = "Your Best";

    selected = 0;
    justChanged = false;
  }

  void update() {
    if (input.escapeDown()) {
      toMainMenu();
    }
    //verandered de geselecteerde menubox 
    if (input.downDown() && !justChanged) {
      selected ++;
      if (selected > 2) selected = 0;
      updateSelected();
      justChanged = true;
    }

    if (input.upDown() && !justChanged) {
      selected --;
      if (selected < 0) selected = 2;
      updateSelected();
      justChanged = true;
    }
    
    //zorgt voor een cooldown van het switchen tussen tabbellen
    if (justChanged) {
      if (timer.startTimer(100)) justChanged = false;
    }
  }

  void draw() {
    background(MENU_BACKGROUND_COLOUR);
    noStroke();
    image(sprites.getLogo(), 20, height - 131, 200, 111);

    //tekent de achtergrond van de text
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
    
    //tekent de achtergrond van de text
    fill(20);
    rect(width /2 - 500, 100, 250, 410);

    //tekent de menuboxes
    for (MenuBox menuBox : boxArray) {
      menuBox.draw();
    }
  }

  void updateSelected() {
    //update welke box geselecteerd is en zet de tabel naar de geselecteerde tabel
    switch(selected) {
    case 0:
      boxArray[0].selected = true;
      boxArray[1].selected = false;
      boxArray[2].selected = false;
      highscores = topHighscores;
      break;
    case 1:
      boxArray[0].selected = false;
      boxArray[1].selected = true;
      boxArray[2].selected = false;
      highscores = topPlayers;
      break;
    case 2:
      boxArray[0].selected = false;
      boxArray[1].selected = false;
      boxArray[2].selected = true;
      highscores = topHighscoresUser;
      break;
    }
  }
}

//Code credit Winand Metz
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
    if (input.escapeDown() && timer.startTimer(ESC_SELECT_TIMER)) {
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

    if (input.xDown() && timer.startTimer(ESC_SELECT_TIMER)) {
      soundAssets.getMenuSelect();
      switch(boxxSelected) {

        // Resume
      case 0:
        isPlaying = true;
        break;

        // Settings
      case 1:
        gameState = 5;
        break;

        // Quit game
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

//Code credit Winand Metz
class SettingsMenu {
  final float VOLUME_INCREASE = 0.05;
  final int VOLUME_SCREEN_BUTTONS = 7;

  TextureAssets sprites;
  Timer timer;
  MenuBox saveButton;
  MenuBox backButton;
  VolumeButton mainVolumeComponent;
  VolumeButton fxVolumeComponent;
  VolumeButton musicVolumeComponent;
  VolumeButton entityVolumeComponent;
  VolumeButton ambientVolumeComponent;

  int selectedComponent;
  int moveCooldown;
  boolean notPressedX, finishedLoading;

  SettingsMenu(TextureAssets textureLoader) {
    this.sprites = textureLoader;
    timer = new Timer("SettingsMenu");
    mainVolumeComponent = new VolumeButton(soundAssets.MAIN_VOLUME, "Main volume", width / 2 - 100, 200);
    fxVolumeComponent = new VolumeButton(soundAssets.UNNORMALISED_FX_VOLUME, "Effects", width / 2 - 100, 300);
    musicVolumeComponent = new VolumeButton(soundAssets.UNNORMALISED_MUSIC_VOLUME, "Music", width / 2 - 100, 400);
    entityVolumeComponent = new VolumeButton(soundAssets.UNNORMALISED_ENTITY_VOLUME, "Entities", width / 2 - 100, 500);
    ambientVolumeComponent = new VolumeButton(soundAssets.UNNORMALISED_AMBIENT_VOLUME, "Ambient sounds", width / 2 - 100, 600);

    saveButton = new MenuBox(width / 2 + 200 - 100, height - 200, 200, height / 8, 32, textureLoader);
    backButton = new MenuBox(width / 2 - 400 - 100, height - 200, 200, height / 8, 32, textureLoader);

    saveButton.boxText = "Save and apply";
    moveCooldown = 0;
    selectedComponent = 0;
    finishedLoading = false;
  }

  void update() {
    if (inMainMenu) {
      backButton.boxText = "Return to main menu";
    } 
    if (!inMainMenu) {
      backButton.boxText = "Return to the game";
    }

    notPressedX = true;
    if (finishedLoading && timer.startTimer(750)) {
      finishedLoading = false;
    }

    backButton.selected = false;
    saveButton.selected = false;
    mainVolumeComponent.selected = false;
    fxVolumeComponent.selected = false;
    musicVolumeComponent.selected = false;
    entityVolumeComponent.selected = false;
    ambientVolumeComponent.selected = false;

    if (input.upDown() && moveCooldown == 0) {
      if (selectedComponent == 0) {
        selectedComponent = VOLUME_SCREEN_BUTTONS - 1;
      } else {
        selectedComponent--;
      }
      moveCooldown = MENU_MOVE_COOLDOWN;
      soundAssets.getMenuHover();
    }

    if (input.downDown() && moveCooldown == 0) {
      if (selectedComponent == VOLUME_SCREEN_BUTTONS - 1) {
        selectedComponent = 0;
      } else {
        selectedComponent++;
      }
      moveCooldown = MENU_MOVE_COOLDOWN;
      soundAssets.getMenuHover();
    }

    if (moveCooldown > 0) {
      moveCooldown--;
    }

    switch(selectedComponent) {
    case 0:
      mainVolumeComponent.selected = true;
      mainVolumeComponent.update();
      break;

    case 1:
      fxVolumeComponent.selected = true;
      fxVolumeComponent.update();
      break;

    case 2:
      musicVolumeComponent.selected = true;
      musicVolumeComponent.update();
      break;

    case 3:
      entityVolumeComponent.selected = true;
      entityVolumeComponent.update();
      break;

    case 4:
      ambientVolumeComponent.selected = true;
      ambientVolumeComponent.update();
      break;

    case 5: 
      saveButton.selected = true;
      if (input.xDown() && notPressedX) {
        soundAssets.update();
        finishedLoading = true;
        notPressedX = false;
      }
      break;

    case 6:
      backButton.selected = true;
      if (input.xDown() && notPressedX) {
        soundAssets.getMenuSelect();
        selectedComponent = 0;
        if (inMainMenu) {
          gameState = 0;
        }
        if (!inMainMenu) {
          gameState = 1;
        }
        notPressedX = false;
      }
      break;

    default: 
      mainVolumeComponent.selected = true;
      mainVolumeComponent.update();
      break;
    }
  }

  void draw() {
    background(MENU_BACKGROUND_COLOUR);
    image(sprites.getMenuBackground(), 0, 0);
    image(sprites.getLogo(), 20, height - 131, 200, 111);
    mainVolumeComponent.draw();
    fxVolumeComponent.draw();
    musicVolumeComponent.draw();
    entityVolumeComponent.draw();
    ambientVolumeComponent.draw();

    saveButton.draw();
    backButton.draw();

    if (finishedLoading) {
      fill(255, 255, 0);
      textSize(24);
      text("Settings saved!", width / 2 - 100, height - 200);
    }
  }

  class VolumeButton {
    Toggle subtract;
    Toggle add;

    float volumePercentage, x, y;
    int volume;
    boolean selected;
    String buttonName;

    VolumeButton(float volumePercentage_, String buttonName_, float x_, float y_) {
      this.volumePercentage = volumePercentage_;
      this.x = x_;
      this.y = y_;
      this.buttonName = buttonName_;
      subtract = new Toggle(5, x, y);
      add = new Toggle(6, x + 80, y);
      selected = false;
    }

    void update() {
      if (input.aDown()) {
        subtract.changeState(true);
        subtract.subtractVol();
      } else if (input.sDown()) {
        add.changeState(true);
        add.addVol();
      } else {
        subtract.changeState(false);
        add.changeState(false);
      }
    }

    float updateVolume() {
      return volumePercentage;
    }

    void draw() {
      volumePercentage = constrain(volumePercentage, 0, 1);

      if (selected) {
        fill(255);
      } else {
        subtract.changeState(true);
        add.changeState(true);
        fill(128);
      }

      volume = (int)round((volumePercentage * 100));

      textSize(22);
      text(volume, x + 42, y + 28);

      textSize(30);
      text(buttonName, x, y);

      subtract.draw();
      add.draw();
    }

    class Toggle {
      final int TOGGLE_COOLDOWN = 6;

      int sprite, pressed, cooldown;
      float x, y;

      Toggle(int sprite_, float x_, float y_) {
        this.sprite = sprite_;
        this.x = x_;
        this.y = y_;
        cooldown = 0;
      }

      void changeState(boolean state) {
        if (state) {
          pressed = 1;
        }
        if (!state) {
          pressed = 0;
        }
      }

      void subtractVol() {
        if (cooldown == 0) {
          volumePercentage -= VOLUME_INCREASE;
          cooldown = TOGGLE_COOLDOWN;
        }
      }

      void addVol() {
        if (cooldown == 0) {
          volumePercentage += VOLUME_INCREASE;
          cooldown = TOGGLE_COOLDOWN;
        }
      }

      void draw() {
        if (cooldown > 0) {
          cooldown--;
        }

        image(sprites.getBombItem(pressed, sprite), x, y);
      }
    }
  }
}
