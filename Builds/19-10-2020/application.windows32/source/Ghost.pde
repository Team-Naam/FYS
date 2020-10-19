//Code credit Jordy Post, Winand Metz, Ruben Verheul

class Ghost extends Enemy {

  int roamingTimer = 3000;
  int velX = 2;
  int velY = 2;

  Ghost(int x, int y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super(x, y, w, h, objectHandler, sprites);
    savedTime = millis();
  }

  void update() {
    movement();

    x = x + speedX;
    y = y + speedY;
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

  void draw() {
    fill(225);
    rect(x, y, w, h);
  }
}
