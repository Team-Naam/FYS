//Code credit Jordy Post, Winand Metz, Ruben Verheul

class Ghost extends Enemy {

  int health = GHOST_HEALTH;
  int roamingTimer = GHOST_ROAMING;
  int velX = GHOST_MOVEMENT_SPEED;
  int velY = GHOST_MOVEMENT_SPEED;

  Ghost(float x, float y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.objectId = ObjectID.GHOST;
    savedTime = millis();
  }

  void update() {
    bombDamage();
    movement();

    x = x + speedX;
    y = y + speedY;

    if (rockCollisionDetection()) {
      x = oldX;
      y = oldY;
    }

    oldX = x;
    oldY = y;
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
        speedX = velX * randomOnes();
        speedY = velY * randomOnes();
        savedTime = millis();
      }
    }
  }

  //Method voor destruction
  void bombDamage() {
    if (insideExplosion) {
      health -= BOMB_DAMAGE;
      insideExplosion = false;
    }
    if (health <= 0) {
      objectHandler.removeEntry(this);
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
    fill(225);
    rect(x, y, w, h);
  }
}
