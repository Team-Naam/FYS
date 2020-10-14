//Classes for de muren en breekbare blokken
abstract class Object {
  int x, y, w, h;
  ObjectID objectId;
  ObjectHandler objectHandler;
  Sprites sprites;

  Object(int x, int y, int w, int h, ObjectID objectId, ObjectHandler objectHandler, Sprites sprites) {
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

  boolean intersection(Object other) {
    return other.w > 0 && other.h > 0 && w > 0 && h > 0
      && other.x < x + w && other.x + other.w > x
      && other.y < y + h && other.y + other.h > y;
  }

  boolean collisionDetection() {
    ArrayList<Object> objects = this.objectHandler.entries;
    for (int i = 0; i < objects.size(); i++) {
      Object gameObject = objects.get(i);
      if (!gameObject.equals(this) && intersection(gameObject)) {
        return true;
      }
    }
    return false;
  }
}
