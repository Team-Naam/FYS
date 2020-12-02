//Code credit Winand Metz

//Kan gebruikt worden in schrijven van collision methods, maar ook andere scripting usages, eigenlijk andere manier van classes, game objecten, oproepen
enum ObjectID {
  WALL, PLAYER, ENTITY, BOMB, ROCK, BBLOCK, ITEM, SPIDER_BOMB, PATH
}

enum ItemID {
  BOOTS, SPARKLER, BPOTION, SHIELD, CLOAK, HEART, COIN
}

enum BombID {
  CFOUR, DYNAMITE, LANDMINE, SPIDER_BOMB
}

enum EntityID {
  GHOST, MUMMY, SMUMMY, SPIDER, EXPLOSIVE_SPIDER, POLTERGEIST, SPIDER_BOSS, WALL_BOSS, BOBJECT
}

//Basis class voor alle gameobjecten
abstract class Object {

  PVector lb, rb, ro, lo, or, left, right, up, down;

  boolean cloakBonus;
  boolean undefeatabaleBonus;
  boolean speedBonus;
  boolean sparklerBonus;

  float x, y;
  int w, h;
  ObjectID objectId;
  ItemID itemId;
  EntityID entityId;
  BombID bombId;
  ObjectHandler objectHandler;
  TextureAssets sprites;

  Object(float x, float y, int w, int h, ObjectID objectId, ObjectHandler objectHandler, TextureAssets sprites) {
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
    or = new PVector();
    left = new PVector();
    right = new PVector();
    up = new PVector();
    down = new PVector();
  }

  abstract void update();

  abstract void draw();

  void moveMap() { 
    x -= game.mapHandler.mapScrollSpeed;
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

  PVector getPlayerPos() {
    PVector pt = new PVector();

    ArrayList<Object> entityObjects = objectHandler.entities;
    Object player = entityObjects.get(0);

    pt.set(player.or);

    return pt;
  }

  //Geeft aan of twee objecten met elkaar kruizen, is niet echt bruikbaar buiten een crawler
  boolean intersection(Object other) {
    return other.w > 0 && other.h > 0 && w > 0 && h > 0
      && other.x < x + w && other.x + other.w > x
      && other.y < y + h && other.y + other.h > y;
  }

  //Gebruikt bovenstaande methode om te kijken of objecten elkaar doorkruizen
  boolean wallCollisionDetection() {
    for (Object wallObject : objectHandler.walls) {
      for (Object entityObject : objectHandler.entities) {
        if (!entityObject.equals(this) && intersection(wallObject) && entityObject.objectId != ObjectID.BOMB && entityObject.entityId != EntityID.GHOST) {
          return true;
        }
      }
    }
    return false;
  }


  boolean rockCollisionDetection() {
    for (Object wallObject : objectHandler.walls) {
      for (Object entityObject : objectHandler.entities) {
        if (!entityObject.equals(this) && intersection(wallObject) && wallObject.objectId == ObjectID.ROCK) {
          return true;
        }
      }
    }
    return false;
  }
}
