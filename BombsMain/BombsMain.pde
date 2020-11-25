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
int gameState;

final int KEY_LIMIT = 1024;
boolean[] keysPressed = new boolean[KEY_LIMIT];

void setup() {
  fullScreen(P2D);
  //size(1920, 1080, P2D);
  frameRate(FRAMERATE);
  game = new Game(TILE_SIZE, width, height);
  input = new InputHandler();
  mainMenu = new MainMenu();
  gameOver = new GameOver();
  gameState = 0; //gameState for the main menu
}

//-----------------------------Draw & Key functies---------------------------------

void draw() {
  instructionPicker();
}

//this method calls certain other methods based on the current gameState
void instructionPicker(){     
  switch(gameState){
   case 0:
   mainMenu.update();
   mainMenu.draw();
   break;
   
   case 1:
   game.update();
   game.draw();
   break;
   
   case 2:
   gameOver.draw();
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
}

void keyReleased() {
  if (keyCode >= KEY_LIMIT) return;
  keysPressed[keyCode] = false;
}
