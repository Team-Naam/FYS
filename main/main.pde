LevelGeneration levelGeneration;
HardBlock myHardBlock;

final int KEY_LIMIT = 1024;
boolean[] keysPressed = new boolean[KEY_LIMIT];



void setup() {
  fullScreen();
  frameRate(60);
  
  levelGeneration = new LevelGeneration();
  myHardBlock = new HardBlock();
}

void updateGame() {
  levelGeneration.update();
  myHardBlock.update(64);
}

void drawGame() {
  background(128);
  
  levelGeneration.draw();
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
