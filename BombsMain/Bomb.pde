class Bomb extends Object {

  int bombTimer = 5000;
  int bombOpacity = 255;
  int startTime;
  int explosionOpacity = 255;
  int explosionRadius = 0;
  int damage = 5;


  Bomb(int x, int y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
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
      if (explosionRadius >= 200) {
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

  boolean bombExploded() {
    if ( millis() > startTime + bombTimer) return true;
    return false;
  }
}
