//Muren, moet nog collision op
class Wall extends Object {
  Wall(int x, int y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super(x, y, w, h, ObjectID.WALL, objectHandler, sprites);
  }

  void update() {
  }

  //Inladen van de texture voor de muur en plaatsing
  void draw() {
    image(sprites.getWall(), x, y);
  }
}

//Breekbare blocks, alles moet nog 
class BreakableBlocks extends Object {
  BreakableBlocks(int x, int y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super(x, y, w, h, ObjectID.BBLOCKS, objectHandler, sprites);
  }

  void update() {
  }

  void draw() {
  }
}
