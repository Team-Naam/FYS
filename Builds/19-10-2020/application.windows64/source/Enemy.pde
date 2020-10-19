//Code credit Jordy Post, Winand Metz, Ruben Verheul, Ole Neuman

//Main Enemy class voor Ghost, Spider, Mummy
class Enemy extends Object {

  int health;
  int roamingTimer;
  int speedX;
  int speedY;
  int velX;
  int velY;
  int savedTime;
  int oldX, oldY;

  boolean touching = false;

  Enemy(int x, int y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super(x, y, w, h, ObjectID.ENEMY, objectHandler, sprites);
    savedTime = millis();
  }

  //Nieuw collision system waarbij hij terug wordt gezet naar de oude positie
  void update() {
    //println(randomSignum());
    movement();

    x = x + speedX;
    y = y + speedY;

    if (collisionDetection()) {
      x = oldX;
      y = oldY;
    }

    oldX = x;
    oldY = y;
  }

  void movement() {
    //Timer voor basic willekeurig ronddwalen over speelveld elke twe seconden gaat hij andere kant op
    //Zodra hij binnen 400 pixels van de player komt gaat hij achter de player aan
    //Moet nog in dat hij om muren heen navigeert ipv tegenaanstoot en stil staat
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

  //Method voor basic volgen van de player
  //Moet nog in dat hij om muren heen navigeert (of je niet ziet achter de muren?)
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

  void hit() {
    health -= 1;
    if (health <= 0) {
      objectHandler.removeEntry(this);
    }
  }

  void ifTouching(Object crate) {
  }

  void draw() {
    fill(20);
    rect(x, y, w, h);
  }

  //Damage method
}
