//Code credit Winand Metz

//Muren, moet nog collision op
class Wall extends Object {

  PVector lb, rb, ro, lo;

  Wall(float x, float y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super(x, y, w, h, ObjectID.WALL, objectHandler, sprites);
  }

  void ifTouching(Object crate) {
  }

  void update() {
    lb = new PVector(x, y);
    rb = new PVector(x + w, y);
    ro = new PVector(x + w, y + h);
    lo = new PVector(x, y + h);
  }

  //Inladen van de texture voor de muur en plaatsing
  void draw() {
    image(sprites.getWall(), x, y);
  }
}

//-----------------------------Rock top & bottom---------------------------------

//Onder en boven muren
class Rock extends Object {

  PVector lb, rb, ro, lo;

  Rock(float x, float y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super(x, y, w, h, ObjectID.ROCK, objectHandler, sprites);
  }

  void ifTouching(Object crate) {
  }

  void update() {
    lb = new PVector(x, y);
    rb = new PVector(x + w, y);
    ro = new PVector(x + w, y + h);
    lo = new PVector(x, y + h);
  }
  
  void draw() {
    image(sprites.getRock(), x, y);
  }
}

//-----------------------------Breakable blocks---------------------------------

class BreakableBlock extends Entity {

  int health = BBLOCK_HEALTH;

  //PVector lb, rb, ro, lo;

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
      objectHandler.removeWall(this);
      objectHandler.addOilBottle(x, y, 64, 64);
    }
  }

  void draw() {
    fill(128, 24, 78);
    rect(x, y, w, h);
  }
}
