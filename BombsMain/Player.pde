//Code credit Ruben Verheul, Winand Metz, Ole Neuman

class Player extends Object {
  Timer timer;
  Highscore highscore;

  boolean speedBonus = false;
  boolean start = true;

  int speedX, speedY, startTime;
  int speedBonusTimer = 1000;
  int velX = PLAYER_SPEED;
  int velY = PLAYER_SPEED;
  int health = PLAYER_HEALTH;
  float oldX, oldY;
  int bombCooldown = 0;

  Player(float x, float y, int w, int h, ObjectHandler objectHandler, Assets sprites, Highscore highscore) {
    super(x, y, w, h, ObjectID.PLAYER, objectHandler, sprites);
    timer = new Timer();
    this.highscore = highscore;
  }

  void update() {
    playerControls();
    powerUpDetection();
    powerUps();

    if (speedX != 0) {
      speedY = 0;
    } else if (speedY != 0) {
      speedX = 0;
    }

    x = x + speedX;
    y = y + speedY;

    if (collisionDetection()) {
      x = oldX - MAP_SCROLL_SPEED;
      y = oldY;
    }

    oldX = x;
    oldY = y;

    if (bombCooldown > 0) bombCooldown--;
  }

  void playerControls() {
    speedX = 0;
    speedY = 0;
    if (input.leftDown() && x > 0) {
      speedX += -velX;
    }
    if (input.rightDown() && x < width) {
      speedX += velX;
    }
    if (input.upDown() && y > 0) {
      speedY += -velY;
    }
    if (input.downDown() && y < height) {
      speedY += velY;
    }
    if (input.zDown() && bombCooldown == 0) {
      objectHandler.addBomb(x + w / 4, y + h / 4, BOMB_SIZE, BOMB_SIZE);
      bombCooldown = BOMB_COOLDOWN_TIME;
    }
    if (input.sDown()&& bombCooldown == 0) {
      objectHandler.addC4(x + w / 4, y + h / 4, BOMB_SIZE, BOMB_SIZE);
      bombCooldown = BOMB_COOLDOWN_TIME;
    }
    if (input.aDown()&& bombCooldown == 0) {
      objectHandler.addLandmine(x + w / 4, y + h / 4, BOMB_SIZE, BOMB_SIZE);
      bombCooldown = BOMB_COOLDOWN_TIME;
    }
  }

  void ifTouching(Object crate) {
  }

  void powerUps() {
    if (speedBonus) {
      if (timer.startTimer(speedBonusTimer)) {
        println("ANTIWOOSH");
        velX -= 2;
        velY -= 2;
        speedBonus = false;
      }
    }
  }

  void powerUpDetection() {
    ArrayList<Object> objects = objectHandler.entities;
    for (int i = 0; i < objects.size(); i++) {
      Object item = objects.get(i);
      if (!item.equals(this) && intersection(item) && item.itemId == ItemID.BOOTS) {
        println("NYOOM");
        velX += 2;
        velY += 2;
        speedBonus = true;
        objectHandler.removeEntity(item);
      }
      
      if (!item.equals(this) && intersection(item) && item.itemId == ItemID.COIN) {
        highscore.addScore(20);
        objectHandler.removeEntity(item);
      }
    }
  }

  void draw() {
    //rect(x, y, w, h);
    image(sprites.getPlayer(), x, y);
  }
}
