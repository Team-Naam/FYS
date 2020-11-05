/*  Project FYS Winand Metz 500851135, Ole Neuman 500827044, 
 Ruben Verheul 500855129, Jordy Post 500846919, Alex Tarnòki 500798826
 
 Controls: pijltjes toetsen voor lopen, z voor plaatsen dynamiet en esc voor exit */


//Code credit Winand Metz, Ole Neuman

//Voor main menu etc
Game game;
InputHandler input;

final int KEY_LIMIT = 1024;
boolean[] keysPressed = new boolean[KEY_LIMIT];

void setup() {
  fullScreen(P2D);
  //size(1920, 1080, P2D);
  frameRate(FRAMERATE);
  game = new Game(TILE_SIZE, width, height);
  input = new InputHandler();
}

//-----------------------------Draw & Key functies---------------------------------

void draw() {
  game.update();
  game.draw();
}

void keyPressed() {  
  if (keyCode >= KEY_LIMIT) return;
  keysPressed[keyCode] = true;
}

void keyReleased() {
  if (keyCode >= KEY_LIMIT) return;
  keysPressed[keyCode] = false;
}
