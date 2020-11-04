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
      if (explosionOpacity <= 0) {
        objectHandler.removeEntry(this);
      }
    }
    if (input.xDown())
    {
      bombActivated = true;
    }
  }
}
