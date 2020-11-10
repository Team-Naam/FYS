//Code credit Jordy Post, Winand Metz, Ruben Verheul, Ole Neuman

class Spider extends Entity {

  int health = SPIDER_HEALTH;
  int roamingTimer = SPIDER_ROAMING;
  int velX = SPIDER_MOVEMENT_SPEED ;
  int velY = SPIDER_MOVEMENT_SPEED ;

  Spider(float x, float y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.objectId = ObjectID.SPIDER;
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

//-----------------------------Special spider---------------------------------

class ExplosiveSpider extends Entity{
  
  int health = EXPLOSIVE_SPIDER_HEALTH;
  int roamingTimer = EXPLOSIVE_SPIDER_ROAMING;
  int velX = EXPLOSIVE_SPIDER_MOVEMENT_SPEED;
  int velY = EXPLOSIVE_SPIDER_MOVEMENT_SPEED;
  
  ExplosiveSpider(float x, float y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.objectId = ObjectID.EXPLOSIVE_SPIDER;
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
  
  void bombDamage() {
    if (insideExplosion) {
      health -= BOMB_DAMAGE;
      insideExplosion = false;
    }
    if (health <= 0) {
      objectHandler.addSpiderBomb(x + w / 4, y + h / 4, BOMB_SIZE, BOMB_SIZE);
      objectHandler.removeEntity(this);
    }
  }
  
  void movement() {
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
      speedY = velY;
    }
    if (getPlayerX() < x && getPlayerY() > y) {
      speedX = -velX;
      speedY = velY;
    }
  }
  
  void draw() {
    fill(174);
    rect(x, y, w, h);
  }
}
