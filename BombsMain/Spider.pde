class Spider extends Enemies {

  Spider(int x, int y, int w, int h, ObjectHandler objectHandler, Sprites sprites, Object player) {
    super(x, y, w, h, objectHandler, sprites, player);
    bSpeedX = 1.3;
    bSpeedY = 1.3;
    HP = 1;
    w = 50;
    h = 50;
  }
}
