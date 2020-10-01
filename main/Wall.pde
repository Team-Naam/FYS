class Wall extends Entity {

  Wall(float x, float y, int w, int h, ObjectHandler objectHandler) {
    super(x, y, w, h, ObjectID.WALL, objectHandler);
  }

  void update() {
  }

  void draw() {
    fill(244);
    rect(x, y, w, h);
  }
}
