class SpiderQueen extends Entity {

  SpiderQueen(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.entityId = EntityID.SPIDER_BOSS;
  }

  void update() {
  }

  void draw() {
  }
}

class MovingWall extends Entity {

  MovingWall(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.entityId = EntityID.WALL_BOSS;
  }

  void update() {
  }

  void draw() {
  }
}
