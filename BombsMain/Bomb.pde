class Bomb extends Object {

  int bombTimer = 5000;
  int bombOpacity = 255;
  int startTime;
  int explosionOpacity = 255;
  int explosionRadius = 0;
  int damage = 5;


  Bomb(float x, float y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super (x, y, w, h, ObjectID.BOMB, objectHandler, sprites);
    startTime = millis();
  }

  void ifTouching(Object crate) {
  }

  void update() {
    if ( bombExploded()) {
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

  void enemyDetection() {

    for (Object enemy : objectHandler.entries) {
      if ( !enemy.equals(this) && enemy.objectId == ObjectID.ENEMY) {
        if (circleRectangleOverlap(enemy.x, enemy.y, enemy.w, enemy.h)) {
          ((Enemy)enemy).insideExplosion = true;
        }
      }
    }
  }

  boolean circleRectangleOverlap(float rectX, float rectY, int rectW, int rectH) {
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
  
  boolean bombExploded() {
    if ( millis() > startTime + bombTimer) return true;
    return false;
  }
}
