//Code credit Jordy Post, Winand Metz, Ruben Verheul

class Ghost extends Entity {

  Ghost(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.entityId = EntityID.GHOST;
    savedTime = millis();
    health = GHOST_HEALTH;
    roamingTimer = GHOST_ROAMING;
    velX = GHOST_MOVEMENT_SPEED;
    velY = GHOST_MOVEMENT_SPEED;
  }

  @Override
    void update() {
    bombDamage();
    movement();

    x = x + speedX;
    y = y + speedY;

    if (rockCollisionDetection()) {
      x = oldX - MAP_SCROLL_SPEED;
      y = oldY;
    }

    oldX = x;
    oldY = y;
  }

  void draw() {
    fill(225);
    rect(x, y, w, h);
  }
}

//-----------------------------Special ghost---------------------------------

//Code credit Ruben Verheul
class Poltergeist extends Entity {


  Poltergeist(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.entityId = EntityID.POLTERGEIST;
    savedTime = millis();
    health = POLTERGEIST_HEALTH;
    roamingTimer = POLTERGEIST_ROAMING;
    velX = POLTERGEIST_MOVEMENT_SPEED;
    velY = POLTERGEIST_MOVEMENT_SPEED;
  }

  @Override
    void update() {
    bombDamage();
    movement();

    x = x + speedX;
    y = y + speedY;

    if (rockCollisionDetection()) {
      x = oldX - MAP_SCROLL_SPEED;
      y = oldY;
    }
    oldX = x;
    oldY = y;
  }

  void draw() {
    fill(200, 200, 230);
    rect(x, y, w, h);
  }
}

//-----------------------------Mummy---------------------------------

class Mummy extends Entity {

  Mummy(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.entityId = EntityID.MUMMY;
    savedTime = millis();

    health = MUMMY_HEALTH;
    roamingTimer = MUMMY_ROAMING;
    velX = MUMMY_MOVEMENT_SPEED;
    velY = MUMMY_MOVEMENT_SPEED;
  }

  @Override
    void update() {
    super.update();
  }

  void draw() {
    //println(health);
    fill(128, 128, 50);
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

  @Override
    void update() {
    super.update();
  }

  //Method voor destruction
  @Override
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

//-----------------------------Spider---------------------------------

class Spider extends Entity {

  Spider(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.entityId = EntityID.SPIDER;
    savedTime = millis();
    health = SPIDER_HEALTH;
    roamingTimer = SPIDER_ROAMING;
    velX = SPIDER_MOVEMENT_SPEED ;
    velY = SPIDER_MOVEMENT_SPEED ;
  }

  @Override
  void update(){
   super.update(); 
  }

  void draw() {
    fill(32);
    rect(x, y, w, h);
  }
}

//-----------------------------Special spider---------------------------------

class ExplosiveSpider extends Entity {



  ExplosiveSpider(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.entityId = EntityID.EXPLOSIVE_SPIDER;
    savedTime = millis();
    health = EXPLOSIVE_SPIDER_HEALTH;
    roamingTimer = EXPLOSIVE_SPIDER_ROAMING;
    velX = EXPLOSIVE_SPIDER_MOVEMENT_SPEED;
    velY = EXPLOSIVE_SPIDER_MOVEMENT_SPEED;
  }

@Override
  void update(){
   super.update(); 
  }

  void draw() {
    fill(174);
    rect(x, y, w, h);
  }
}
