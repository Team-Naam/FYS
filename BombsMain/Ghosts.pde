class Ghosts extends Enemies {
  
  Ghosts(int x, int y, int w, int h, ObjectHandler objectHandler, Sprites sprites, Object player) {
    super(x, y, w, h, objectHandler, sprites, player);
  }
  
  void draw() {
    super.draw();
    fill(224,255,255);
  }
}
