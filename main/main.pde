LevelGeneration levelGeneration;
Player player;

final int KEY_LIMIT = 1024;
boolean[] keysPressed = new boolean[KEY_LIMIT];

int x, y, w, h;

void setup() {
  fullScreen();
  frameRate(60);

  player = new Player();
  levelGeneration = new LevelGeneration(128, width, height);
}

void updateGame() {
  levelGeneration.update();
  //myHardBlock.update(64);
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
  updateGame(); // Update your game first
  drawGame();   // Draw your game after everything is updated
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
