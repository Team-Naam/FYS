/*  Project FYS BombRunner Winand Metz 500851135, Ole Neuman 500827044, 
 Ruben Verheul 500855129, Jordy Post 500846919, Alex Tarnòki 500798826
 
 Controls: pijltjes toetsen voor lopen, z voor plaatsen dynamiet, s voor C4 plaatsen en x voor exploderen, a voor landmine plaatsen en esc voor exit */

//Code credit Winand Metz, Ole Neuman
import samuelal.squelized.*;
import processing.sound.*;

//Voor main menu etc
Game game;
InputHandler input;
MainMenu mainMenu;
GameOver gameOver;
PauseMenu pauseMenu;
AchievementMenu achievementMenu;
HighscoreMenu highscoreMenu;
SettingsMenu settingsMenu;
TextureAssets textureAssets;
SoundAssets soundAssets;
ServerHandler serverHandler;

PFont bits;

int gameState;
int userID;

boolean escapePressed;
boolean isPlaying;
boolean inMainMenu;
boolean playAsGuest;

final int KEY_LIMIT = 1024;
boolean[] keysPressed = new boolean[KEY_LIMIT];

void setup() {
  fullScreen(P2D);
  //size(1920, 1080, P2D);
  frameRate(FRAMERATE);

  bits = createFont("data/font/8bitlim.ttf", 48, true);
  textFont(bits);

  input = new InputHandler();
  soundAssets = new SoundAssets(this);
  textureAssets = new TextureAssets(TILE_SIZE);
  serverHandler = new ServerHandler();
  serverHandler.getSoundVol();
  settingsMenu = new SettingsMenu(textureAssets);
  soundAssets.update();
  game = new Game(TILE_SIZE, width, height, textureAssets, soundAssets, serverHandler);
  mainMenu = new MainMenu(textureAssets, soundAssets);
  gameOver = new GameOver(textureAssets);
  pauseMenu = new PauseMenu(textureAssets);
  highscoreMenu = new HighscoreMenu(textureAssets, serverHandler);
  achievementMenu = new AchievementMenu(textureAssets, serverHandler);

  gameState = 0; //gameState for the main menu
}

//Code credit Jordy Post
void toMainMenu() {
  gameState = 0;
  game = new Game(TILE_SIZE, width, height, textureAssets, soundAssets, serverHandler);
  
  //update alle highscore tabellen
  highscoreMenu.topHighscores = serverHandler.getTopHighscores(HIGHSCORE_TABLE_LIMIT);
  highscoreMenu.topPlayers = serverHandler.getTopPlayers(HIGHSCORE_TABLE_LIMIT);
  highscoreMenu.topHighscoresUser = serverHandler.getTopHighscoresUser(HIGHSCORE_TABLE_LIMIT);
}

//-----------------------------Draw & Key functies---------------------------------

void draw() {
  instructionPicker();
}

//this method calls certain other methods based on the current gameState
void instructionPicker() {     
  switch(gameState) {
  case 0:
    mainMenu.update();
    mainMenu.draw();
    break;

  case 1:
    if (isPlaying) {
      game.update();
    }

    game.draw();

    if (!isPlaying) {
      pauseMenu.update();
      pauseMenu.draw();
    }
    break;

  case 2:
    gameOver.update(game.highscore);
    gameOver.draw();
    break;

    // Highscore
  case 3:
    highscoreMenu.update();
    highscoreMenu.draw();
    break;

    // Achievements
  case 4:
    achievementMenu.update();
    achievementMenu.draw();
    break;

    // Settings
  case 5:
    settingsMenu.update();
    settingsMenu.draw();
    break;

  default:
    mainMenu.update();
    mainMenu.draw();
    break;
  }
}

void keyPressed() {  
  if (keyCode >= KEY_LIMIT) return;
  keysPressed[keyCode] = true;

  //rebind van escape
  if (key == ESC) {
    key = 0;
    escapePressed = true;
  }
}

void keyReleased() {
  if (keyCode >= KEY_LIMIT) return;
  keysPressed[keyCode] = false;
  escapePressed = false;
}
