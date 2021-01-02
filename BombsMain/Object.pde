//Code credit Winand Metz

//Enum ID's voor gebruik in bepaalde filter doeleindes b.v. is er collision, is het opblaasbaar 
enum ObjectID {
  WALL, PLAYER, ENTITY, BOMB, ROCK, BBLOCK, ITEM, SPIDER_BOMB, PATH, FIX, BULLET
}

enum ItemID {
  BOOTS, SPARKLER, BPOTION, SHIELD, CLOAK, HEART, COIN
}

enum BombID {
  CFOUR, DYNAMITE, LANDMINE, SPIDER_BOMB
}

enum EntityID {
  GHOST, MUMMY, SMUMMY, SPIDER, EXPLOSIVE_SPIDER, MINI_SPIDER, POLTERGEIST, SPIDER_BOSS, WALL_BOSS, HALF_WALL, BOBJECT
}

//Basis class voor alle gameobjecten
abstract class Object {

  PVector lb, rb, ro, lo, or, left, right, up, down;

  boolean cloakBonus;
  boolean undefeatabaleBonus;
  boolean speedBonus;
  boolean sparklerBonus;

  float x, y;
  float playerSpeed = PLAYER_SPEED;
  int w, h;
  ObjectID objectId;
  ItemID itemId;
  EntityID entityId;
  BombID bombId;
  ObjectHandler objectHandler;
  TextureAssets sprites;
  SoundAssets soundAssets;

  Object(float x, float y, int w, int h, ObjectID objectId, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.objectId = objectId;
    this.objectHandler = objectHandler;
    this.sprites = sprites;
    this.soundAssets = soundAssets;

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

  //Elk game object moet een update en draw bevatten 
  abstract void update();

  abstract void draw();

  //Alle objecten moeten, zodra de map gaat bewegen, worden verplaatst van rechts naar links
  void moveMap() { 
    x -= game.mapHandler.mapScrollSpeed;
  } 

  /* Alle objecten worden verwijderd zodra ze te ver buiten eht scherm vallen
   Dit wordt gedaan om ervoor te zorgen dat de rescources niet vollopen */
  void selfDestruct() {
    if (x < -256) {
      if (objectId == ObjectID.WALL || objectId == ObjectID.BBLOCK ||objectId == ObjectID.ROCK) {
        objectHandler.removeWall(this);
      } 
      objectHandler.removeEntity(this);
    }
  }

  //Alle game objecten hebben een simpele schaduw onder hun 
  void dropShadow() {
    noStroke();
    fill(0, 112);
    ellipse(x + w / 2, y + h * 0.9, w, w * 0.9);
  }

  /* Position crawler voor de player X
   Gaat door de objecthandler z'n list heen en zoekt naar object met het ID player om vervolgens x op te vragen */
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

  //Geeft aan of twee objecten met elkaar kruizen
  boolean intersection(Object other) {
    return other.w > 0 && other.h > 0 && w > 0 && h > 0
      && other.x < x + w && other.x + other.w > x
      && other.y < y + h && other.y + other.h > y;
  }

  //Gebruikt bovenstaande methode om te kijken of entities wall objecten proberen te doorkruizen
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

  //Gebruikt bovenstaande methode om te kijken of ghost entities rock objecten proberen te doorkruizen
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
