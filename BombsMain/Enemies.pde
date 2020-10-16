class Enemies extends Object {
  Object player;

  float speedX, speedY;
  float bSpeedX, bSpeedY;
  int HP;
  int hitTimer;
  int collision;

  Enemies(int x, int y, int w, int h, ObjectHandler objectHandler, Sprites sprites, Object player) {
    super(x, y, w, h, ObjectID.ENEMIE, objectHandler, sprites);
    //beginwaarden
    bSpeedX = 0.8;  //0.8 * bombermanspeed
    bSpeedY = 0.8;
    speedX = bSpeedX;
    speedY = bSpeedY;
    w = 50;
    h = 100;
    HP = (int)random(2, 4);
    hitTimer = 0;
    collision = 0;
    this.player = player;
  }

  void update() {  
    move();
    hitPlayer();
  }

  void draw() {
    //tekent de enemie
    fill(255);
    rectMode(CORNER);
    rect(x, y, w, h);
  }

  void enemieCollision(Enemies other) {
    // kijkt of er collision is met een andere enemie en slaat dat op
    if (collision(this, other)) {
      if (x + w <= other.x +2) {
        x = other.x - w;
        collision = 1;
      }

      if (x >= other.x + other.w -2) {
        x = other.x + other.w;
        collision = 2;
      }

      if (y + h <= other.y +2) {
        y = other.y - h;
        collision = 3;
      }

      if (y >= other.y + other.h -2) {
        y = other.y + other.h;
        collision = 4;
      }
    } else {
      collision = 0;
    }
  }


  //kijk waar de player is en ga daar naartoe
  void moveX() {
    if (player.x < x) {
      x -= speedX;
    } else {
      x += speedX;
    }
  }

  void moveY() {
    if (player.y < y) {
      y -= speedY;
    } else {
      y += speedY;
    }
  }

  void move() {   
    if (collisionDetection()) {
      speedX = speedX * -1;
      speedY = speedY * -1;
    }

    // kijkt waar bomberman is en gaat naar die locatie is ook een deel voor de collision tussen enemies
    switch(collision) {
    case 0:
      moveX();
      moveY();
      break;

    case 1:
      if (player.x < x) x -= speedX;
      moveY();
      break;

    case 2:
      if (player.x < x);
      else x += speedX;
      moveY();

      break;

    case 3:
      moveX();
      if (player.y < y) y -= speedY;
      break;

    case 4:
      moveX();
      if (player.y < y);
      else y += speedY;
      break;
    }
  }

  void hitPlayer() {
    hitTimer++;

    //kijkt of er collision is met bomberman, zo ja haalt hij iedere seconde hp van bomberman eraf
    if (collision(this, player)) {
      speedY = 0;
      speedX = 0;
      if (hitTimer > 60) {
        //haal hp van bomberman eraf
        //player.playerHP -= 1;
        hitTimer = 0;
      }
    } else {
      speedX = bSpeedX;
      speedY = bSpeedY;
    }
  }

  //om te kijken of er collision is tussen 2 rechthoeken
  boolean collision(Object object1, Object object2) {
    boolean collide = false;
    if ((((object1.x >= object2.x && object1.x <= (object2.x + object2.w)) || ((object1.x + object1.w >= object2.x) && (object1.x + object1.w) <= (object2.x + object2.w))) && ((object1.y >= object2.y && object1.y <= object2.y + object2.h) || ((object1.y + object1.h >= object2.y) && (object1.y + object1.h) <= (object2.y + object2.h))))) collide = true;
    return collide;
  }
}

