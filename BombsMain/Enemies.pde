//Code credit Jordy Post, Winand Metz, Ruben Verheul

class Ghost extends Entity {

  Ghost(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.entityId = EntityID.GHOST;
    savedTime = millis();
    health = GHOST_HEALTH;
    attack = GHOST_ATTACK;
    roamingTimer = GHOST_ROAMING;
    velX = GHOST_MOVEMENT_SPEED;
    velY = GHOST_MOVEMENT_SPEED;
  }

  @Override
    void update() {
    bombDamage();
    movement();
    attack();

    x = x + speedX;
    y = y + speedY;

    if (rockCollisionDetection()) {
      x = oldX - game.mapHandler.mapScrollSpeed;
      y = oldY;
    }

    oldX = x;
    oldY = y;
  }

  void draw() {
    image(sprites.getEntity(0, 0), x, y);
  }
}

//-----------------------------Special ghost---------------------------------

//Code credit Ruben Verheul
class Poltergeist extends Entity {


  Poltergeist(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.entityId = EntityID.POLTERGEIST;
    savedTime = millis();
    health = POLTERGEIST_HEALTH;
    attack = POLTERGEIST_ATTACK;
    roamingTimer = POLTERGEIST_ROAMING;
    velX = POLTERGEIST_MOVEMENT_SPEED;
    velY = POLTERGEIST_MOVEMENT_SPEED;
  }

  @Override
    void update() {
    bombDamage();
    movement();
    attack();

    x = x + speedX;
    y = y + speedY;

    if (rockCollisionDetection()) {
      x = oldX - game.mapHandler.mapScrollSpeed;
      y = oldY;
    }

    oldX = x;
    oldY = y;
  }

  void attack() {
    ArrayList<Object> entityObjects = objectHandler.entities;
    Object playerEntity = entityObjects.get(0);
    if (intersection(playerEntity)) {
      ((Player)playerEntity).attackDamage = attack;
      ((Player)playerEntity).gettingAttacked = true;
      cloakBonus = false;
      undefeatabaleBonus = false;
      speedBonus = false;
      sparklerBonus = false;
      println("slash");
    }
  }

  void draw() {
    image(sprites.getEntity(0, 0), x, y);
  }
}

//-----------------------------Mummy---------------------------------

class Mummy extends Entity {

  Mummy(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.entityId = EntityID.MUMMY;
    savedTime = millis();

    health = MUMMY_HEALTH;
    attack = MUMMY_ATTACK;
    roamingTimer = MUMMY_ROAMING;
    velX = MUMMY_MOVEMENT_SPEED;
    velY = MUMMY_MOVEMENT_SPEED;
  }

  @Override
    void update() {
    super.update();
  }

  void draw() {
    image(sprites.getEntity(1, 0), x, y);
  }
}

//-----------------------------Special mummy---------------------------------

//Code credit Jordy Post
class SMummy extends Mummy {

  int shield;

  SMummy(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.entityId = EntityID.SMUMMY;
    savedTime = millis();
    health = SMUMMY_HEALTH;
    shield = SMUMMY_SHIELD;
    attack = SMUMMY_ATTACK;
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
    image(sprites.getEntity(1, 0), x, y);
  }
}

//-----------------------------Spider---------------------------------

class Spider extends Entity {

  Spider(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.entityId = EntityID.SPIDER;
    savedTime = millis();
    health = SPIDER_HEALTH;
    attack = SPIDER_ATTACK;
    roamingTimer = SPIDER_ROAMING;
    velX = SPIDER_MOVEMENT_SPEED ;
    velY = SPIDER_MOVEMENT_SPEED ;
  }

  @Override
    void update() {
    super.update();
  }

  void draw() {
    image(sprites.getEntity(0, 1), x, y);
  }
}

//-----------------------------Special spider---------------------------------

class ExplosiveSpider extends Entity {



  ExplosiveSpider(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.entityId = EntityID.EXPLOSIVE_SPIDER;
    savedTime = millis();
    health = EXPLOSIVE_SPIDER_HEALTH;
    attack = EXPLOSIVE_SPIDER_ATTACK;
    roamingTimer = EXPLOSIVE_SPIDER_ROAMING;
    velX = EXPLOSIVE_SPIDER_MOVEMENT_SPEED;
    velY = EXPLOSIVE_SPIDER_MOVEMENT_SPEED;
  }

  @Override
    void update() {
    super.update();
  }

  void draw() {
    image(sprites.getEntity(0, 1), x, y);
  }
}
