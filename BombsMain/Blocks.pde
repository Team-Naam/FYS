//Code credit Winand Metz

//Muren, moet nog collision op
class Wall extends Object {
  Wall(float x, float y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super(x, y, w, h, ObjectID.WALL, objectHandler, sprites);
  }

  void ifTouching(Object crate) {
  }

  void update() {
  }

  //Inladen van de texture voor de muur en plaatsing
  void draw() {
    image(sprites.getWall(), x, y);
  }
}

//-----------------------------Rock top & bottom---------------------------------

//Onder en boven muren
class Rock extends Object {
  Rock(float x, float y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super(x, y, w, h, ObjectID.ROCK, objectHandler, sprites);
  }

  void ifTouching(Object crate) {
  }

  void update() {
  }

  void draw() {
    image(sprites.getRock(), x, y);
  }
}

//-----------------------------Breakable blocks---------------------------------

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
