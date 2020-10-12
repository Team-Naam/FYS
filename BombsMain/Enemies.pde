class Enemies {
  float posX, posY;
  float speedX, speedY;
  float sizeX, sizeY;
  int HP;
  int hitTimer;
  int collision;

  Enemies(float posX, float posY) {
    //beginwaarden
    this.posX = posX;
    this.posY = posY;
    speedX = 0.8;  //0.8 * bombermanspeed
    speedY = 0.8;
    sizeX = 50;
    sizeY = 100;
    HP = (int)random(2, 4);
    hitTimer = 0;
    collision = 0;
  }

  void update() {
    // kijkt waar bomberman is en gaat naar die locatie is ook een deel voor de collision tussen enemies
    switch(collision) {
    case 0:
      moveX();
      moveY();
      break;
      
    case 1:
      if (player.posX < posX) posX -= speedX;
      moveY();
      break;
      
    case 2:
      if (player.posX < posX);
      else posX += speedX;
      moveY();
      break;
      
    case 3:
      moveX();
      if (player.posY < posY) posY -= speedY;
      break;
      
    case 4:
      moveX();
      if (player.posY < posY);
      else posY += speedY;
      break;
    }

    hitTimer++;

    //kijkt of er collision is met bomberman, zo ja haalt hij iedere seconde hp van bomberman eraf
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

  void draw() {
    //tekent de enemie
    fill(255);
    rectMode(CORNER);
    rect(posX, posY, sizeX, sizeY);
  }

  void enemieCollision(Enemies other) {
    // kijkt of er collision is met een andere enemie en slaat dat op
    if (collision(posX, posY, sizeX, sizeY, other.posX, other.posY, other.sizeX, other.sizeY)) {
      if (posX + sizeX <= other.posX +1) {
        posX = other.posX - sizeX;
        collision = 1;
      }

      if (posX >= other.posX + other.sizeX -1) {
        posX = other.posX + other.sizeX;
        collision = 2;
      }

      if (posY + sizeY <= other.posY +1) {
        posY = other.posY - sizeY;
        collision = 3;
      }

      if (posY >= other.posY + other.sizeY -1) {
        posY = other.posY + other.sizeY;
        collision = 4;
      }
    } else {
      collision = 0;
    }
  }


//kijkt waar de player is en gaat daar naartoe
  void moveX() {
    if (player.posX < posX)
      posX -= speedX;
    else posX += speedX;
  }

  void moveY() {
    if (player.posY < posY)
      posY -= speedY;
    else posY += speedY;
  }

//om te kijken of er collision is tussen 2 rechthoeken
  boolean collision(float firstX, float firstY, float firstSizeX, float firstSizeY, float otherX, float otherY, float otherSizeX, float otherSizeY) {
    boolean collide = false;
    if ((((firstX >= otherX && firstX <= (otherX + otherSizeX)) || ((firstX + firstSizeX >= otherX) && (firstX + firstSizeX) <= (otherX + otherSizeX))) && ((firstY >= otherY && firstY <= otherY + otherSizeY) || ((firstY + firstSizeY >= otherY) && (firstY + firstSizeY) <= (otherY + otherSizeY))))) collide = true;
    return collide;
  }
}
