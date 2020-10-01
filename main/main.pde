LevelGeneration levelGeneration;
//Player player;
//startMenu startMenu;
//inGame inGame;
//howToPlay howToPlay;
//highScores highScores;
//gameOver gameOver;
InputHandler inputHandler;

final int KEY_LIMIT = 1024;
boolean[] keysPressed = new boolean[KEY_LIMIT];

int stage;


void setup() {
  fullScreen();
  frameRate(60);

  inputHandler = new InputHandler();
  //startMenu = new startMenu();
  //inGame = new inGame();
  //howToPlay = new howToPlay();
  //highScores = new highScores();
  //gameOver = new gameOver();

  //  player = new Player();
  levelGeneration = new LevelGeneration(128, width, height);
  //stage = 0;
}

void updateGame() {
  levelGeneration.update();

  //  player.update();
}

void drawGame() {
  background(128);

  levelGeneration.draw();
  //  player.draw();
}

//-------------------------------------------------------------- 

void draw() {
  {
    //switch(stage)
    //{
    //case 0:
    //  startMenu.menu();
    //  return; 
    //case 1:
    //  inGame.menu();
    //  return;
    //case 2:
    //  howToPlay.menu();
    //  return;
    //case 3:
    //  highScores.menu();
    //  return;
    //case 4:
    //  gameOver.menu();
    //  return;
    //}
  }
  updateGame(); // Update your game first
  drawGame();   // Draw your game after everything is updated
}

void keyPressed(KeyEvent event) {
  inputHandler.keyPressed(event.getKeyCode(), event.getKey());
}

void keyReleased(KeyEvent event) {
  inputHandler.keyReleased(event.getKeyCode(), event.getKey());
}
