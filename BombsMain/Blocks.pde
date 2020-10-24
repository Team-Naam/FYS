//Code credit Winand Metz

//Muren, moet nog collision op
class Wall extends Object {
  Wall(float x, float y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super(x, y, w, h, ObjectID.WALL, objectHandler, sprites);
  }

  void ifTouching(Object crate) {
  }

  void update() {
    if(x < 0 - w) objectHandler.removeEntry(this);
  }

  //Inladen van de texture voor de muur en plaatsing
  void draw() {
    image(sprites.getWall(), x, y);
  }
}

//Breekbare blocks, alles moet nog 
class BreakableBlocks extends Object {
  BreakableBlocks(float x, float y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super(x, y, w, h, ObjectID.BBLOCKS, objectHandler, sprites);
  }

  void ifTouching(Object crate) {
  }

  void update() {
  }

  void draw() {
  }
}

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
    image(sprites.getWall(), x, y);
  }
}
