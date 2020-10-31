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
      if (explosionOpacity <= 0) {
        objectHandler.removeEntry(this);
      }
    }
  }

  void enemyOverlapsLandmine() {
    for (Object enemy : objectHandler.entries) {
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
