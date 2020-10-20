//Code credit Jordy Post, Winand Metz, Ruben Verheul, Ole Neuman

class Spider extends Enemy {

  int health = 1;
  int roamingTimer = 1000;
  int velX = 3;
  int velY = 3;

  Spider(int x, int y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super(x, y, w, h, objectHandler, sprites);
    savedTime = millis();
  }

  void update() {
    movement();
    bombDamage();
    x = x + speedX;
    y = y + speedY;

    if (collisionDetection()) {
      x = oldX;
      y = oldY;
    }

    oldX = x;
    oldY = y;
  }

  //Method voor destruction
  void bombDamage() {
    if (insideExplosion) {
      health -= 2;
      insideExplosion = false;
    }
    if (health <= 0) {
      objectHandler.removeEntry(this);
    }
  }

  void movement() {
    //Timer voor basic willekeurig ronddwalen over speelveld elke twe seconden gaat hij andere kant op
    //Zodra hij binnen 400 pixels van de player komt gaat hij achter de player aan
    //Moet nog in dat hij om muren heen navigeert ipv tegenaanstoot en stil staat
    int passedTime = millis() - savedTime;
    if (dist(getPlayerX(), getPlayerY(), x, y) < 400) {
      hunt();
    } else {
      if (passedTime > roamingTimer) {
        speedX = velX * randomSignum();
        speedY = velY * randomSignum();
        savedTime = millis();
      }
    }
  }

  void hunt() {
    if (getPlayerX() > x && getPlayerY() > y) {
      speedX = velX;
      speedY = velY;
    } 
    if (getPlayerX() < x && getPlayerY() < y) {
      speedX = -velX;
      speedY = -velY;
    } 
    if (getPlayerX() > x && getPlayerY() < y) {
      speedX = velX;
      speedY = -velY;
    } 
    if (getPlayerX() < x && getPlayerY() > y) {
      speedX = -velX;
      speedY = velY;
    }
  }

  void draw() {
    fill(32);
    rect(x, y, w, h);
  }
}
