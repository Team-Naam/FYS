LevelGeneration levelGeneration;
HardBlock myHardBlock;
Player player;

  startMenu startMenu = new startMenu();
  inGame inGame = new inGame();
  howToPlay howToPlay = new howToPlay();
  highScores highScores = new highScores();
  gameOver gameOver = new gameOver();

final int KEY_LIMIT = 1024;
boolean[] keysPressed = new boolean[KEY_LIMIT];

int stage;

void setup() {
  fullScreen();
  frameRate(60);
  
  stage = 0;

  player = new Player();
  levelGeneration = new LevelGeneration();
  myHardBlock = new HardBlock();

}

void updateGame() {
  levelGeneration.update();
  myHardBlock.update(64);
  player.update();
}

void drawGame() {
  background(128);

  levelGeneration.draw();
  player.draw();
  //myHardBlock.draw();
}

//-------------------------------------------------------------- 

void draw() {
  {
    switch(stage)
    {
    case 0:
      startMenu.menu();
      return; 
    case 1:
      inGame.menu();
      return;
    case 2:
      howToPlay.menu();
      return;
    case 3:
      highScores.menu();
      return;
    case 4:
      gameOver.menu();
      return;
    }
    updateGame(); // Update your game first
    drawGame();   // Draw your game after everything is updated
  }
}

// Keyboard handling...
void keyPressed() {  
  if (keyCode >= KEY_LIMIT) return; //safety: if keycode exceeds limit, exit function ('return').
  keysPressed[keyCode] = true; // set its boolean to true
}

//..and with each key Released vice versa
void keyReleased() {
  if (keyCode >= KEY_LIMIT) return;
  keysPressed[keyCode] = false;
}
