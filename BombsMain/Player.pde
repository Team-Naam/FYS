class Player extends Object {

  int speedX = 0;
  int speedY = 0;
  int velX = 2;
  int velY = 2;
  int playerHP = 3;


  Player(int x, int y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super(x, y, w, h, ObjectID.PLAYER, objectHandler, sprites);
  }

  void update() {

    if (keyPressed == true && keyCode == UP) {
      speedY = velY * -1;
    } else if (keyPressed == true && keyCode == DOWN) {
      speedY = velY;
    } else if (keyPressed == true && keyCode == LEFT) {
      speedX = velX * -1;
    } else if (keyPressed == true && keyCode == RIGHT) {
      speedX = velX;
    } else if (keyPressed == false) {
      speedY = 0;
      speedX = 0;
    }

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

  void draw() {
    //rect(x, y, w, h);
    image(sprites.getPlayer(), x, y);
  }
}
