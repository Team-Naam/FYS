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
    ArrayList<Object> objects = objectHandler.entries;
    for (int i = 0; i < objects.size(); i++) {
      Object gameObject = objects.get(i);
      if (gameObject.objectId == ObjectID.PLAYER) {
        pX = gameObject.x;
      }
    }
    return pX;
  }

  //Position crawler voor de player Y
  float getPlayerY() {
    float pY = 0;
    ArrayList<Object> objects = objectHandler.entries;
    for (int i = 0; i < objects.size(); i++) {
      Object gameObject = objects.get(i);
      if (gameObject.objectId == ObjectID.PLAYER) {
        pY = gameObject.y;
      }
    }
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
    ArrayList<Object> objects = objectHandler.entries;
    for (int i = 0; i < objects.size(); i++) {
      Object gameObject = objects.get(i);
      if (!gameObject.equals(this) && intersection(gameObject) && gameObject.objectId != ObjectID.BOMB && gameObject.objectId != ObjectID.GHOST && gameObject.objectId != ObjectID.OILB) {
        return true;
      }
    }
    return false;
  }

  boolean rockCollisionDetection() {
    ArrayList<Object> objects = objectHandler.entries;
    for (int i = 0; i < objects.size(); i++) {
      Object gameObject = objects.get(i);
      if (!gameObject.equals(this) && intersection(gameObject) && gameObject.objectId == ObjectID.ROCK) {
        return true;
      }
    }
    return false;
  }
}
