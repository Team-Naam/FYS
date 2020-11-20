//Code credit Jordy Post, Winand Metz, Ruben Verheul, Ole Neuman

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
