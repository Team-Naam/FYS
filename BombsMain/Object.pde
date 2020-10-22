//Code credit Winand Metz

//Basis class voor alle gameobjecten
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

  abstract void ifTouching(Object crate);

  //Position crawler voor de player X
  //Gaat door de objecthandler z'n list heen en zoekt naar object met het ID player om vervolgens x op te vragen
  int getPlayerX() {
    int pX = 0;
    ArrayList<Object> objects = this.objectHandler.entries;
    for (int i = 0; i < objects.size(); i++) {
      Object gameObject = objects.get(i);
      if (gameObject.objectId == ObjectID.PLAYER) {
        pX = gameObject.x;
      }
    }
    return pX;
  }

  //Position crawler voor de player Y
  int getPlayerY() {
    int pY = 0;
    ArrayList<Object> objects = this.objectHandler.entries;
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
    ArrayList<Object> objects = this.objectHandler.entries;
    for (int i = 0; i < objects.size(); i++) {
      Object gameObject = objects.get(i);
      if (!gameObject.equals(this) && intersection(gameObject) && gameObject.objectId != ObjectID.BOMB && gameObject.objectId != ObjectID.GHOST) {
        return true;
      }
    }
    return false;
  }
  
  boolean rockCollisionDetection() {
    ArrayList<Object> objects = this.objectHandler.entries;
    for (int i = 0; i < objects.size(); i++) {
      Object gameObject = objects.get(i);
      if (!gameObject.equals(this) && intersection(gameObject) && gameObject.objectId == ObjectID.ROCK) {
        return true;
      }
    }
    return false;
  }
}
