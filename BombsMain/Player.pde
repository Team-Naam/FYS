class Player extends Object {

  int speedX = 0;
  int speedY = 0;
  int velX = 2;
  int velY = 2;
  int health = 3;


  Player(int x, int y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super(x, y, w, h, ObjectID.PLAYER, objectHandler, sprites);
  }

  void update() {

    playerControls();

    if (speedX != 0) {
      speedY = 0;
    } else if (speedY != 0) {
      speedX = 0;
    }

    if (collisionDetection()) {
      speedX = speedX * -1;
      speedY = speedY * -1;
    }

    x = x + speedX;
    y = y + speedY;
  }

  void playerControls() {
    speedX = 0;
    speedY = 0;
    if (input.leftDown() && x > 0) speedX += -velX;
    if (input.rightDown() && x < width) speedX += velX;
    if (input.upDown() && y > 0) speedY += -velY;
    if (input.downDown() && y < height) speedY += velY;
  }

  void ifTouching(Object crate) {
  }

  void draw() {
    //rect(x, y, w, h);
    image(sprites.getPlayer(), x, y);
  }
}
