//Code credit Winand Metz

//Basis class voor alle gameobjecten
abstract class Object {

  PVector lb, rb, ro, lo;

  float x, y;
  int w, h;
  ObjectID objectId;
  ObjectHandler objectHandler;
  Sprites sprites;

  Object(float x, float y, int w, int h, ObjectID objectId, ObjectHandler objectHandler, Sprites sprites) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.objectId = objectId;
    this.objectHandler = objectHandler;
    this.sprites = sprites;
    lb = new PVector();
    rb = new PVector();
    ro = new PVector();
    lo = new PVector();
  }

  abstract void update();

  abstract void draw();

  abstract void ifTouching(Object crate);

  void moveMap() { 
    x -= MAP_SCROLL_SPEED;
  } 

  void getVector() {
    lb.set(x, y);
    rb.set(x + w, y);
    ro.set(x + w, y + h);
    lo.set(x, y + h);
  }

  //Position crawler voor de player X
  //Gaat door de objecthandler z'n list heen en zoekt naar object met het ID player om vervolgens x op te vragen
  float getPlayerX() {
    float pX = 0;
    ArrayList<Object> entityObjects = objectHandler.entities;
    Object player = entityObjects.get(0);
    pX = player.x;
    return pX;
  }

  //Position crawler voor de player Y
  float getPlayerY() {
    float pY = 0;
    ArrayList<Object> entityObjects = objectHandler.entities;
    Object player = entityObjects.get(0);
    pY = player.y;
    return pY;
  }

  //Geeft aan of twee objecten met elkaar kruizen, is niet echt bruikbaar buiten een crawler
  boolean intersection(Object other) {
    return other.w > 0 && other.h > 0 && w > 0 && h > 0
      && other.x < x + w && other.x + other.w > x
      && other.y < y + h && other.y + other.h > y;
  }

  //Gebruikt bovenstaande methode om te kijken of objecten elkaar doorkruizen
  //Zal kijken of ik nog een kan schrijven die ook de objectID's erbij betrekt, zodat je specifieke collision kan vinden
  boolean collisionDetection() {
    ArrayList<Object> entityObjects = objectHandler.entities;
    ArrayList<Object> wallObjects = objectHandler.walls;
    for (int i = 0; i < entityObjects.size(); i++) {
      for (int j = 0; j < wallObjects.size(); j++) {
        Object wallObject = wallObjects.get(j);
        Object entityObject = entityObjects.get(i);
        if (!entityObject.equals(this) && intersection(wallObject) && entityObject.objectId != ObjectID.BOMB && entityObject.objectId != ObjectID.GHOST && entityObject.objectId != ObjectID.OILB) {
          return true;
        }
      }
    }
    return false;
  }

  boolean rockCollisionDetection() {
    ArrayList<Object> entityObjects = objectHandler.entities;
    ArrayList<Object> wallObjects = objectHandler.walls;
    for (int i = 0; i < entityObjects.size(); i++) {
      for (int j = 0; j < wallObjects.size(); j++) {
        Object wallObject = wallObjects.get(j);
        Object entityObject = entityObjects.get(i);
        if (!entityObject.equals(this) && intersection(wallObject) && wallObject.objectId == ObjectID.ROCK) {
          return true;
        }
      }
    }
    return false;
  }
}
