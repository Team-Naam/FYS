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
    // kijkt waar bomberman is en gaat naar die locatie
    if (bomberman.posX < posX)
      posX -= speedX;
    else posX += speedX;
    if (bomberman.posY < posY)
      posY -= speedY;
    else posY += speedY;

    hitTimer++;

    if (collision.corner(bomberman.posX, bomberman.posY, bomberman.playerWidth, bomberman.playerHeight, posX, posY, sizeX, sizeY)) {
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
    fill(255);
    rectMode(CORNER);
    rect(posX, posY, sizeX, sizeY);
  }
}
