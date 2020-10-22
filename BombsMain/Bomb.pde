//Code credit Alex Tarnòki, Ole Neuman

class Bomb extends Object {

  int bombTimer = EXPLOSION_TIMER;
  int bombOpacity = BOMB_START_OPACITY;
  int startTime;
  int explosionOpacity = EXPLOSION_START_OPACITY;
  int explosionRadius = EXPLOSION_START_RADIUS;


  Bomb(int x, int y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super (x, y, w, h, ObjectID.BOMB, objectHandler, sprites);
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
      if (explosionOpacity <= 0) {
        objectHandler.removeEntry(this);
      }
    }
  }

  void draw() {
    fill(0, bombOpacity);
    if (bombOpacity == 0) noStroke();
    rect(x, y, 32, 32);
    fill(235, 109, 30, explosionOpacity);
    noStroke();
    circle(x + w, y + h, explosionRadius);
    stroke(1);
  }

  //Kijkt of object een enemy is
  void enemyDetection() {
    for (Object enemy : objectHandler.entries) {
      if ( !enemy.equals(this) && enemy.objectId == ObjectID.ENEMY 
        || enemy.objectId == ObjectID.GHOST 
        || enemy.objectId == ObjectID.MUMMY 
        || enemy.objectId == ObjectID.SPIDER) {
        if (circleRectangleOverlap(enemy.x, enemy.y, enemy.w, enemy.h)) {
          ((Enemy)enemy).insideExplosion = true;
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
