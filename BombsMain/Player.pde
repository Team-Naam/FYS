public class Player {
  float posX, posY;
  float playerWidth, playerHeight;
  float speedX, speedY;
  int playerHP;


  Player() {
    posX = 500;
    posY = 500;
    playerWidth = 64;
    playerHeight = 64;
    speedX = 0;
    speedY = 0;
    playerHP = 3;
  }

  void update() {
    if (keyPressed == true && keyCode == UP) {
      speedY = -1;
    } else if (keyPressed == true && keyCode == DOWN) {
      speedY = 1;
    } else if (keyPressed == true && keyCode == LEFT) {
      speedX = -1;
    } else if (keyPressed == true && keyCode == RIGHT) {
      speedX = 1;
    } else if (keyPressed == false) {
      speedY = 0;
      speedX = 0;
    }
    if (speedX != 0) {
      speedY = 0;
    } else if (speedY != 0) {
      speedX = 0;
    }
    posX = posX + speedX;
    posY = posY + speedY;
  }


  void draw() {
    rectMode(CENTER);
    fill(200);
    rect(posX, posY, playerWidth, playerHeight);
  }
}
