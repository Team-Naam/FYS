class Enemies {
  Player player;
  
  float x, y;
  float speedX, speedY;
  float bSpeedX, bSpeedY;
  float sizeX, sizeY;
  int HP;
  int hitTimer;
  int collision;

  Enemies(float posX, float posY) {
    //beginwaarden
    this.x = posX;
    this.y = posY;
    bSpeedX = 0.8;  //0.8 * bombermanspeed
    bSpeedY = 0.8;
    speedX = bSpeedX;
    speedY = bSpeedY;
    sizeX = 50;
    sizeY = 100;
    HP = (int)random(2, 4);
    hitTimer = 0;
    collision = 0;
  }

  void update() {  
    move();
    hitPlayer();
  }

  void draw() {
    //tekent de enemie
    fill(255);
    rectMode(CORNER);
    rect(x, y, sizeX, sizeY);
  }

  void enemieCollision(Enemies other) {
    // kijkt of er collision is met een andere enemie en slaat dat op
    if (collision(x, y, sizeX, sizeY, other.x, other.y, other.sizeX, other.sizeY)) {
      if (x + sizeX <= other.x +2) {
        x = other.x - sizeX;
        collision = 1;
      }

      if (x >= other.x + other.sizeX -2) {
        x = other.x + other.sizeX;
        collision = 2;
      }

      if (y + sizeY <= other.y +2) {
        y = other.y - sizeY;
        collision = 3;
      }

      if (y >= other.y + other.sizeY -2) {
        y = other.y + other.sizeY;
        collision = 4;
      }
    } else {
      collision = 0;
    }
  }


//kijkt waar de player is en gaat daar naartoe
  void moveX() {
    if (player.x < x)
      x -= speedX;
    else x += speedX;
  }

  void moveY() {
    if (player.y < y)
      y -= speedY;
    else y += speedY;
  }
  
  void move() {
    // kijkt waar bomberman is en gaat naar die locatie is ook een deel voor de collision tussen enemies
    switch(collision) {
    case 0:
      moveX();
      moveY();
      break;
      
    case 1:
      if (player.x < x) x -= speedX;
      moveY();
      break;
      
    case 2:
      if (player.x < x);
      else x += speedX;
      moveY();
      break;
      
    case 3:
      moveX();
      if (player.y < y) y -= speedY;
      break;
      
    case 4:
      moveX();
      if (player.y < y);
      else y += speedY;
      break;
    }
  }
  
  void hitPlayer(){
    hitTimer++;


    

    //kijkt of er collision is met bomberman, zo ja haalt hij iedere seconde hp van bomberman eraf
    if (collision(player.x, player.y, player.w, player.h, x, y, sizeX, sizeY)) {

      speedY = 0;
      speedX = 0;
      if (hitTimer > 60) {
        //haal hp van bomberman eraf
        player.playerHP -= 1;
        hitTimer = 0;
      }
    } else {
      speedX = bSpeedX;
      speedY = bSpeedY;
    }
  }

//om te kijken of er collision is tussen 2 rechthoeken
  boolean collision(float firstX, float firstY, float firstSizeX, float firstSizeY, float otherX, float otherY, float otherSizeX, float otherSizeY) {
    boolean collide = false;
    if ((((firstX >= otherX && firstX <= (otherX + otherSizeX)) || ((firstX + firstSizeX >= otherX) && (firstX + firstSizeX) <= (otherX + otherSizeX))) && ((firstY >= otherY && firstY <= otherY + otherSizeY) || ((firstY + firstSizeY >= otherY) && (firstY + firstSizeY) <= (otherY + otherSizeY))))) collide = true;
    return collide;
  }
}
