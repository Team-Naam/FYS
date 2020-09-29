class Entity {
  float x, y, xVel, yVel;
  int w, h;
  ObjectID objectId;
  ObjectHandler objectHandler;

  Entity(float x, float y, int w, int h, ObjectID objectId, ObjectHandler objectHandler) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.objectId = objectId;
    this.objectHandler = objectHandler;
  }

  void update() {
  }

  void draw() {
  }
}
