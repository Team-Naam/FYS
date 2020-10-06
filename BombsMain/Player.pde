public class Player {
  float posX, posY;
  int playerWidth, playerHeight;
  int speedAmountX, speedAmountY;
  float speedX, speedY;
  
  
  Player() {
    posX = 500;
    posY = 500;
    
    playerWidth = 64;
    playerHeight = 64;
    
    speedAmountX = 5;
    speedAmountY = 5;
    
    speedX = 0;
    speedY = 0;
  }
  
  void update() {    
    playerControls();
    
    posX = posX + speedX;
    posY = posY + speedY;
  }
  
  
  void draw() {
    rectMode(CENTER);
    rect(posX,posY,playerWidth,playerHeight);
    fill(0);
  }
  
  
  //When the player pressed left (or A), the player Object gains speed to the left. When they press right (or D), they gain speed to the right. Same thing for up (or W) and down (or S)
  void playerControls(){    
    speedX = 0;
    speedY = 0;
      if(keysPressed[39] || keysPressed[68] && posX < width){
       speedX += speedAmountX; 
      }
      
      if(keysPressed[37] || keysPressed[65] && posX > 0){
       speedX -= speedAmountX; 
      }
      
      if(keysPressed[40] || keysPressed[83] && posY < height){
       speedY += speedAmountY;
      }
      
      if(keysPressed[38] || keysPressed[87] && posY > 0){
       speedY -= speedAmountY; 
      }
    }
    
  
}
