class ObjectHandler {

  ArrayList<Block> blocks = new ArrayList<Block>();

  Sprites sprites;

  ObjectHandler(Sprites sprites) {
    this.sprites = sprites;
  }

  void addWall(int x, int y, int w, int h) {
    Wall wall = new Wall(x, y + 28, w, h, this, sprites);
    blocks.add(wall);
  }

  void removeBlock(Block block) {
    blocks.remove(block);
  }

  void update() {
    ArrayList<Block> objects = blocks;
    for (int i = 0; i < objects.size(); i++) {
      if (i >= objects.size()) {
        break;
      }
      objects.get(i).update();
    }
  }

  void draw() {
    ArrayList<Block> objects = blocks;
    for (int i = 0; i < objects.size(); i++) {
      if (i >= objects.size()) {
        break;
      }
      objects.get(i).draw();
    }
  }
}
