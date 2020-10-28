class Poltergeist extends Enemy {
  int heath = POLTERGEIST_HEALTH;
  int roamingTimer = POLTERGEIST_ROAMING;
  int velX = POLTERGEIST_MOVEMENT_SPEED;
  int velY = POLTERGEIST_MOVEMENT_SPEED;
  
  Poltergeist(float x, float y, int w, int h, ObjectHandler objectHandler, Sprites sprites){
    super(x, y, w, h, objectHandler, sprites);
    this.objectId = ObjectID.POLTERGEIST;
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
    fill(200);
    rect(x, y, w, h);
  }
}
