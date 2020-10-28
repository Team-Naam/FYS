class SMummy extends Mummy {

  int shield;

  SMummy(int x, int y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.objectId = ObjectID.SMUMMY;
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
      objectHandler.removeEntry(this);
    }
  }

  void draw() {
    fill(158);
    rect(x, y, w, h);
  }
}
