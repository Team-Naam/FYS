class Enemies {
  float posX, posY;
  float speedX, speedY;
  float sizeX, sizeY;
  int HP;
  int hitTimer;
  
  Enemies() {
    posX = random(width / 2, 600);
    posY = random(height);
    speedX = 0.8;  //0.8 * bombermanspeed
    speedY = 0.8;
    sizeX = 50;
    sizeY = 100;
    HP = (int)random(2, 4);
    hitTimer = 0;
  }

  void update() {

    hitTimer++;

    if (collision(player.posX, player.posY, player.playerWidth, player.playerHeight, posX, posY, sizeX, sizeY)) {
      speedY = 0;
      speedX = 0;
      if (hitTimer > 60) {
        //haal hp van bomberman eraf
        hitTimer = 0;
      }
    } else {
      speedY = 0.8;
      speedX = 0.8;
    }
  }
  
  
  void blockCollision(Block block){

    if (collision(posX, posY, sizeX, sizeY, block.x, block.y, block.w, block.h)) {
      if (posX + sizeX <= block.x +1) {
        posX = block.x - sizeX;

        if (player.posX < posX)
          posX -= speedX;

        moveY();
      }

      if (posX >= block.x + block.w -1) {
        posX = block.x + block.w;

        if (player.posX < posX);
        else posX += speedX;

        moveY();
      }

      if (posY + sizeY <= block.y +1) {
        posY = block.y - sizeY;

        moveX();

        if (player.posY < posY)
          posY -= speedY;
      }

      if (posY >= block.y + block.h -1) {
        posY = block.y + block.h;

        moveX();

        if (player.posY < posY);
        else posY += speedY;
      }
    } else {
      moveX();
      moveY();
    }
    }
  


  void draw() {
    fill(255);
    rectMode(CORNER);
    rect(posX, posY, sizeX, sizeY);
  }
  
  void moveX(){
    if (player.posX < posX)
      posX -= speedX;
    else posX += speedX;
  }
  
  void moveY(){
    if (player.posY < posY)
      posY -= speedY;
    else posY += speedY;
  }
  
  
  boolean collision(float firstX, float firstY, float firstSizeX, float firstSizeY, float otherX, float otherY, float otherSizeX, float otherSizeY) {
    return (((firstX >= otherX && firstX <= (otherX + otherSizeX)) || ((firstX + firstSizeX >= otherX) && (firstX + firstSizeX) <= (otherX + otherSizeX))) && ((firstY >= otherY && firstY <= otherY + otherSizeY) || ((firstY + firstSizeY >= otherY) && (firstY + firstSizeY) <= (otherY + otherSizeY))));
  }
}
