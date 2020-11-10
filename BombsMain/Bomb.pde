//Code credit Alex Tarnòki, Ole Neuman

class Bomb extends Object {

  int bombTimer = EXPLOSION_TIMER;
  int bombOpacity = BOMB_START_OPACITY;
  int startTime;
  int explosionOpacity = EXPLOSION_START_OPACITY;
  int explosionRadius = EXPLOSION_START_RADIUS;


  Bomb(float x, float y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super(x, y, w, h, ObjectID.BOMB, objectHandler, sprites);
    startTime = millis();
  }

  void ifTouching(Object crate) {
  }

  //Wanneer dynamiet explodeerd kijk hij of er enemy in de blastradius zit en paast dit door naar de enemy class
  //Explosie begint fel en neemt daarna af in opacity, wanneer deze nul is wordt hij verwijdert
  void update() {
    if ( bombExploded()) {
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

  void draw() {
    fill(0, bombOpacity);
    if (bombOpacity == 0) {
      noStroke();
    }
    rect(x, y, w, h);
    fill(235, 109, 30, explosionOpacity);
    noStroke();
    circle(x + w, y + h, explosionRadius);
    stroke(1);
    if (explosionOpacity <= 0) {
      objectHandler.removeEntity(this);
    }
  }

  //Kijkt of object een enemy is
  void enemyDetection() {
    for (Object enemy : objectHandler.entities) {
      if ( !enemy.equals(this) && enemy.objectId == ObjectID.ENEMY 
        || enemy.objectId == ObjectID.GHOST 
        || enemy.objectId == ObjectID.MUMMY 
        || enemy.objectId == ObjectID.SPIDER
        || enemy.objectId == ObjectID.POLTERGEIST
        || enemy.objectId == ObjectID.SMUMMY
        || enemy.objectId == ObjectID.SPIDER
        || enemy.objectId == ObjectID.EXPLOSIVE_SPIDER
        || enemy.objectId == ObjectID.BBLOCK) {
        if (circleRectangleOverlap(enemy.x, enemy.y, enemy.w, enemy.h)) {
          ((Entity)enemy).insideExplosion = true;
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

//-----------------------------C4 bomb---------------------------------

class C4 extends Bomb
{
  boolean bombActivated;

  C4(float x, float y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super(x, y, w, h, objectHandler, sprites);
    bombActivated = false;
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

  void update() {
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

  Landmine(float x, float y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super(x, y, w, h, objectHandler, sprites);
    enemyOverlaps = false;
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
  void update() {
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
    for (Object enemy : objectHandler.entities) {
      if ( !enemy.equals(this) && enemy.objectId == ObjectID.ENEMY 
        || enemy.objectId == ObjectID.GHOST 
        || enemy.objectId == ObjectID.MUMMY 
        || enemy.objectId == ObjectID.SPIDER
        || enemy.objectId == ObjectID.POLTERGEIST
        || enemy.objectId == ObjectID.SMUMMY
        || enemy.objectId == ObjectID.SPIDER) {
        if (rectRect(enemy.x, enemy.y, enemy.w, enemy.h)) {
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
class SpiderBomb extends Object {

  int bombTimer = EXPLOSION_TIMER;
  int bombOpacity = BOMB_START_OPACITY;
  int startTime;
  int explosionOpacity = EXPLOSION_START_OPACITY;
  int explosionRadius = EXPLOSION_START_RADIUS;


  SpiderBomb(float x, float y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super(x, y, w, h, ObjectID.SPIDER_BOMB, objectHandler, sprites);
    startTime = millis();
  }

  void ifTouching(Object crate) {
  }

  //Wanneer dynamiet explodeerd kijk hij of er enemy in de blastradius zit en paast dit door naar de enemy class
  //Explosie begint fel en neemt daarna af in opacity, wanneer deze nul is wordt hij verwijdert
  void update() {
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
          ((Entity)player).insideExplosion = true;
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
