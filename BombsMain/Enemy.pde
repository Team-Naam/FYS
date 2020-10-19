class Enemy extends Object {

  int speedX = 0;
  int speedY = 0;
  int velX = 1;
  int velY = 1;
  int roamingTimer = 2000;
  int savedTime;

  Enemy(int x, int y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super(x, y, w, h, ObjectID.ENEMY, objectHandler, sprites);
    savedTime = millis();
  }

  void update() {
    movement();

    if (collisionDetection()) {
      speedX = speedX * -1;
      speedY = speedY * -1;
    }

    x = x + speedX;
    y = y + speedY;
  }

  void movement() {
    int passedTime = millis() - savedTime;
    if (dist(getPlayerX(), getPlayerY(), x, y) < 400) {
      hunt();
    } else {
      if (passedTime > roamingTimer) {
        speedX = velX * randomSignum();
        speedY = velY * randomSignum();
        savedTime = millis();
      }
    }
  }

  void hunt() {
    if (getPlayerX() > x && getPlayerY() > y) {
      speedX = velX;
      speedY = velY;
    } 
    if (getPlayerX() < x && getPlayerY() < y) {
      speedX = -velX;
      speedY = -velY;
    } 
    if (getPlayerX() > x && getPlayerY() < y) {
      speedX = velX;
      speedY = -velY;
    } 
    if (getPlayerX() < x && getPlayerY() > y) {
      speedX = -velX;
      speedY = velY;
    }
  }

  int randomSignum() {
    return (int) random(3) * 2 - 2;
  }

  void draw() {
    fill(20);
    rect(x, y, w, h);
  }

  void ifTouching(Object crate) {
  }
}
