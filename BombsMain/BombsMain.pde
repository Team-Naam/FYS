//Voor main menu etc
Game game;
Player player;

final int KEY_LIMIT = 1024;
boolean[] keysPressed = new boolean[KEY_LIMIT];

void setup() {
  fullScreen(P2D);
  frameRate(60);
  game = new Game();
  player = new Player();
}

//-----------------------------Draw & Key functies---------------------------------

void updateGame() {
  //game.update();
  player.update();
}

void drawGame() {
  //game.draw();
  player.draw();
}

void keyPressed() {  
  if (keyCode >= KEY_LIMIT) return;
  keysPressed[keyCode] = true;
}

void keyReleased() {
  if (keyCode >= KEY_LIMIT) return;
  keysPressed[keyCode] = false;
}
