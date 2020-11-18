//Code credit Jordy Post, Winand Metz, Ruben Verheul, Ole Neuman

class Mummy extends Entity {

  int health = MUMMY_HEALTH;
  int roamingTimer = MUMMY_ROAMING;
  int velX = MUMMY_MOVEMENT_SPEED;
  int velY = MUMMY_MOVEMENT_SPEED;

  Mummy(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.entityId = EntityID.MUMMY;
    savedTime = millis();
  }

  void update() {
    movement();
    bombDamage();

    x = x + speedX;
    y = y + speedY;

    if (collisionDetection()) {
      x = oldX - MAP_SCROLL_SPEED;
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
    if (dist(getPlayerX(), getPlayerY(), x, y) < PLAYER_DETECTION_DISTANCE) {
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
      objectHandler.removeEntity(this);
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
    //println(health);
    fill(128);
    rect(x, y, w, h);
  }
}

//-----------------------------Special mummy---------------------------------

//Code credit Jordy Post
class SMummy extends Mummy {

  int shield;

  SMummy(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.entityId = EntityID.SMUMMY;
    savedTime = millis();
    shield = SMUMMY_SHIELD;
  }

  //Method voor destruction
  void bombDamage() {
    if (insideExplosion) {
      println(insideExplosion);
      if (shield <= 0) {
        health -= BOMB_DAMAGE;
        insideExplosion = false;
      } else {
        shield -= BOMB_DAMAGE;
        insideExplosion = false;
      }
    }
    if (health <= 0) {
      objectHandler.removeEntity(this);
    }
  }

  void draw() {
    fill(158);
    rect(x, y, w, h);
  }
}
