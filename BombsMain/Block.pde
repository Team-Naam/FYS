abstract class Block {
  int x, y, w, h;
  ObjectID objectId;
  ObjectHandler objectHandler;
  Sprites sprites;

  Block(int x, int y, int w, int h, ObjectID objectId, ObjectHandler objectHandler, Sprites sprites) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.objectId = objectId;
    this.objectHandler = objectHandler;
    this.sprites = sprites;
  }

  abstract void update();

  abstract void draw();
}

class Wall extends Block {
  Wall(int x, int y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super(x, y, w, h, ObjectID.WALL, objectHandler, sprites);
  }

  void update() {
  }

  void draw() {
    image(sprites.getWall(), x, y);
  }
}

class BreakableBlocks extends Block {
  BreakableBlocks(int x, int y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super(x, y, w, h, ObjectID.BBLOCKS, objectHandler, sprites);
  }

  void update() {
  }

  void draw() {
  }
}
