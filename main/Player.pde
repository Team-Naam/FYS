public class Player {
  float posX,posY;
  float playerWidth, playerHeight;
  
  Player() {
    posX = 500;
    posY = 500;
    playerWidth = 64;
    playerHeight = 64;
  }
  
  void update() {
    if (keyPressed) {
      if (keyCode == UP) {
        posY = posY - 1;
      } else if (keyCode == DOWN) {
        posY = posY + 1;
      } else if (keyCode == LEFT) {
        posX = posX - 1;
      } else if (keyCode == RIGHT) {
        posX = posX + 1;
      }
    }
  }
  
  void draw() {
    rectMode(CENTER);
    rect(posX,posY,playerWidth,playerHeight);
    fill(0);
  }
  
}
