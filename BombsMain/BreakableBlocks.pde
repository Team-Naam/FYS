//Code credit Winand Metz

class BreakableBlock extends Entity {

  int health = BBLOCK_HEALTH;

  BreakableBlock(float x, float y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.objectId = ObjectID.BBLOCK;
  }

  void update() {
    bombDamage();
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

  void draw() {
    rect(x, y, w, h);
  }
}
