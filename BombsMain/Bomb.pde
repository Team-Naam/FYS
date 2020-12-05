//Code credit Alex Tarnòki, Ole Neuman //<>//

class Bomb extends Object {

  int bombTimer = EXPLOSION_TIMER;
  int bombOpacity = BOMB_START_OPACITY;
  int startTime;
  int explosionOpacity = EXPLOSION_START_OPACITY;
  int explosionRadius = EXPLOSION_START_RADIUS;

  boolean bombAnimation = false;

  Bomb(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, ObjectID.BOMB, objectHandler, sprites, soundAssets);
    this.bombId = BombID.DYNAMITE;
    startTime = millis();
  }

  //Wanneer dynamiet explodeerd kijk hij of er enemy in de blastradius zit en paast dit door naar de enemy class
  //Explosie begint fel en neemt daarna af in opacity, wanneer deze nul is wordt hij verwijdert
  void update() {
    selfDestruct();

    if (bombExploded()) {
      bombAnimation = true;
      
      soundAssets.getBombExploded();
      enemyDetection();
      
      if (explosionRadius < 400) {
        explosionRadius += 25;
      }
      if (explosionRadius >= 400) {
        explosionOpacity -=6;
        bombOpacity = 0;
      }
    }
  }

  void draw() {
    if (!bombAnimation) {
      image(sprites.getBombItem(1, 0), x, y);
    }
    if (bombAnimation) {
      sprites.getExplosion(0, x, y);
    }
    //fill(235, 109, 30, explosionOpacity);
    //noStroke();
    //circle(x + w, y + h, explosionRadius);
    //stroke(1);
    if (explosionOpacity <= 0) {
      objectHandler.removeEntity(this);
    }
  }

  //Kijkt of object een enemy is
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
  boolean bombActivated;

  C4(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.bombId = BombID.CFOUR;
    bombActivated = false;
  }

  void draw() {
    fill(0, bombOpacity);
    if (bombOpacity == 0) noStroke();
    image(sprites.getBombItem(2, 0), x, y);
    //rect(x, y, w, h);
    fill(235, 109, 30, explosionOpacity);
    noStroke();
    circle(x + w, y + h, explosionRadius);
    stroke(1);
    if (explosionOpacity <= 0) {
      objectHandler.removeEntity(this);
    }
  }

  void update() {
    selfDestruct();

    if ( bombActivated) {
      enemyDetection();
      if (explosionRadius < 400) {
        explosionRadius += 25;
      }
      if (explosionRadius >= 400) {
        explosionOpacity -=5;
        bombOpacity = 0;
      }
    }
    if (input.xDown())
    {
      bombActivated = true;
    }
  }
}

//-----------------------------Landmine---------------------------------

class Landmine extends Bomb
{
  boolean enemyOverlaps;

  Landmine(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.bombId = BombID.LANDMINE;
    enemyOverlaps = false;
  }

  void draw() {
    fill(0, bombOpacity);
    if (bombOpacity == 0) noStroke();
    image(sprites.getBombItem(0, 0), x, y);
    //rect(x, y, w, h);
    fill(235, 109, 30, explosionOpacity);
    noStroke();
    circle(x + w, y + h, explosionRadius);
    stroke(1);
    if (explosionOpacity <= 0) {
      objectHandler.removeEntity(this);
    }
  }
  void update() {
    selfDestruct();

    if (enemyOverlaps == false)
    {
      enemyOverlapsLandmine();
    }
    if (enemyOverlaps) {
      enemyDetection();
      if (explosionRadius < 400) {
        explosionRadius += 25;
      }
      if (explosionRadius >= 400) {
        explosionOpacity -=5;
        bombOpacity = 0;
      }
    }
  }

  void enemyOverlapsLandmine() {
    for (Object entity : objectHandler.entities) {
      if ( !entity.equals(this) && entity.objectId == ObjectID.ENTITY ) {
        if (circleRectangleOverlap(entity.x, entity.y, entity.w, entity.h)) {
          enemyOverlaps = true;
        }
      }
    }
  }

  boolean rectRect(float r2x, float r2y, float r2w, float r2h) {

    // are the sides of one rectangle touching the other?

    if (x + w >= r2x &&    // r1 right edge past r2 left
      x <= r2x + r2w &&    // r1 left edge past r2 right
      y + h >= r2y &&    // r1 top edge past r2 bottom
      y <= r2y + r2h) {    // r1 bottom edge past r2 top
      return true;
    }
    return false;
  }
}

//-----------------------------Spiderbombs---------------------------------

//class voor de Bomb die de ExplosiveSpider maakt
//code credit Alex Tarnoki, Ole Neuman, Ruben Verheul
class SpiderBomb extends Bomb {

  int bombTimer = EXPLOSION_TIMER;
  int bombOpacity = BOMB_START_OPACITY;
  int startTime;
  int explosionOpacity = EXPLOSION_START_OPACITY;
  int explosionRadius = EXPLOSION_START_RADIUS;


  SpiderBomb(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.bombId = BombID.SPIDER_BOMB;
    startTime = millis();
  }

  //Wanneer dynamiet explodeerd kijk hij of er enemy in de blastradius zit en paast dit door naar de enemy class
  //Explosie begint fel en neemt daarna af in opacity, wanneer deze nul is wordt hij verwijdert
  void update() {
    selfDestruct();

    if ( bombExploded()) {
      playerDetection();
      if (explosionRadius < 400) {
        explosionRadius += 25;
      }
      if (explosionRadius >= 400) {
        explosionOpacity -=5;
        bombOpacity = 0;
      }
    }
  }

  void draw() {
    fill(0, bombOpacity);
    if (bombOpacity == 0) noStroke();
    rect(x, y, w, h);
    fill(235, 109, 30, explosionOpacity);
    noStroke();
    circle(x + w, y + h, explosionRadius);
    stroke(1);
    if (explosionOpacity <= 0) {
      objectHandler.removeEntity(this);
    }
  }

  //Kijkt of object een player is
  void playerDetection() {
    for (Object player : objectHandler.entities) {
      if ( !player.equals(this) && player.objectId == ObjectID.PLAYER ) {
        if (circleRectangleOverlap(player.x, player.y, player.w, player.h)) {
          ((Player)player).insideExplosion = true;
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
    if ( millis() > startTime + bombTimer) return true;
    return false;
  }
}
