class Item extends Object {

  Item(float x, float y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super(x, y, w, h, ObjectID.ITEM, objectHandler, sprites);
  }

  void update() {
  }

  void draw() {
  }

  void ifTouching(Object crate) {
  }
}

class OilBottle extends Item {

  OilBottle(float x, float y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.objectId = ObjectID.OILB;
  }

  void update() {
  }

  void draw() {
    fill(128, 128, 0);
    rect(x, y, w, h);
  }
}
