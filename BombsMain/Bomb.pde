//Code credit Alex Tarnòki, Ole Neuman, Ruben Verheul, Winand Metz


class Bomb extends Object {
  SpriteSheetAnim explosionAnim;

  final int FPS = 12;

  int explosionStopTimer = EXPLOSION_STOP_TIMER;
  int bombTimer = EXPLOSION_TIMER;

  int startTime, bombType, explosionRadius;

  Timer explosionTimer;

  boolean bombAnimation = false;
  boolean bombActivated;

  Bomb(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, ObjectID.BOMB, objectHandler, sprites, soundAssets);
    this.bombId = BombID.DYNAMITE;

    startTime = millis();
    explosionAnim = new SpriteSheetAnim(sprites.explosion, 0, 12, FPS);
    explosionAnim.playOnce();
    explosionAnim.setCenter();
    bombActivated = true;
    explosionTimer = new Timer ("explosionTimer");
    bombType = 1;
    explosionRadius = DYNAMITE_EXPLOSION_RADIUS;
  }

  //Wanneer dynamiet explodeerd kijk hij of er enemy in de blastradius zit en paast dit door naar de enemy class
  //Explosie begint fel en neemt daarna af in opacity, wanneer deze nul is wordt hij verwijdert
  void update() {
    selfDestruct();

    if (bombExploded() && bombActivated) {
      bombAnimation = true;

      explosionAnim.update(x, y);

      enemyDetection();

      if (explosionTimer.startTimer(explosionStopTimer)) {
        explosionRadius = 0;
      }
    }
  }

  void draw() {
    if (!bombAnimation) {
      image(sprites.getBombItem(bombType, 0), x, y);
    }
    if (bombAnimation) {
      explosionAnim.draw();
    }
    if (explosionAnim.index > 11) {
      objectHandler.removeEntity(this);
    }
    //ellipse(x, y, explosionRadius, explosionRadius);
  }

  //Kijkt of object een entity is
  void enemyDetection() {
    for (Object entity : objectHandler.entities) {
      if (!entity.equals(this) && entity.objectId == ObjectID.ENTITY ) {
        if (circleRectangleOverlap(entity.x, entity.y, entity.w, entity.h)) {
          ((Entity)entity).insideExplosion = true;
        }
      } else if (!entity.equals(this) && entity.objectId == ObjectID.PLAYER) {
        if (circleRectangleOverlap(entity.x, entity.y, entity.w, entity.h)) {
          ((Player)entity).insideExplosion = true;
        }
      }        
      for (Object wall : objectHandler.walls) {
        if (!wall.equals(this) && wall.objectId == ObjectID.BBLOCK ) {
          if (circleRectangleOverlap(wall.x, wall.y, wall.w, wall.h)) {
            ((Entity)wall).insideExplosion = true;
          }
        }
      }
    }
  }

  //Kijk of de enemy in de circle zit van de blast radius
  boolean circleRectangleOverlap(float rectX, float rectY, int rectW, int rectH) {
    //println("bombX = " + x + ", bombY = " + y + ", explosionRadius = " + explosionRadius);
    //println("enemyX = " + rectX + "enemyY = " + rectY);
    float distanceX = abs(x - rectX - rectW / 4);
    float distanceY = abs(y - rectY - rectH / 4);

    if (distanceX > rectW / 2 + explosionRadius/2) return false; 
    if (distanceY > rectH / 2 + explosionRadius/2) return false; 

    if (distanceX <= rectW / 2) return true;  
    if (distanceY <= rectH / 2) return true; 

    float dx = distanceX-rectW / 2;
    float dy = distanceY-rectH / 2;
    return (dx*dx+dy*dy<=((explosionRadius/2)*(explosionRadius/2)));
  }

  //Explosie timer
  boolean bombExploded() {
    if ( millis() > startTime + bombTimer) {
      return true;
    }
    return false;
  }
}

//-----------------------------C4 bomb---------------------------------

class C4 extends Bomb
{

  C4(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.bombId = BombID.CFOUR;
    bombActivated = false;
    bombType = 2;
    explosionRadius = CFOUR_EXPLOSION_RADIUS;
  }

  void draw() {
    super.draw();
  }

  void update() {
    super.update();

    if (input.xDown())
    {
      bombActivated = true;
    }
  }
}

//-----------------------------Landmine---------------------------------

class Landmine extends Bomb {
  boolean enemyOverlaps;

  Landmine(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.bombId = BombID.LANDMINE;
    bombActivated = true;
    enemyOverlaps = false;
    bombType = 0;
    explosionRadius = LANDMINE_EXPLOSION_RADIUS;
  }

  void draw() {
    super.draw();
  }

  void update() {
    selfDestruct();

    if (enemyOverlapsLandmine()) {
      enemyOverlaps = true;
    }

    if (enemyOverlaps) {
      super.update();
    }
  }

  boolean enemyOverlapsLandmine() {
    for (Object entity : objectHandler.entities) {
      if (!entity.equals(this) && entity.objectId == ObjectID.ENTITY) {
        return intersection(entity);
      }
    }
    return false;
  }
}

//-----------------------------Spiderbombs---------------------------------

//class voor de Bomb die de ExplosiveSpider maakt
class SpiderBomb extends Bomb {

  SpiderBomb(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.bombId = BombID.SPIDER_BOMB;
    startTime = millis();
    bombType = 1;
    explosionRadius = SPIDER_EXPLOSION_RADIUS;
  }

  //Wanneer dynamiet explodeerd kijk hij of er enemy in de blastradius zit en paast dit door naar de enemy class
  //Explosie begint fel en neemt daarna af in opacity, wanneer deze nul is wordt hij verwijdert
  void update() {
    super.update();
  }

  void draw() {
    super.draw();
  }
}
