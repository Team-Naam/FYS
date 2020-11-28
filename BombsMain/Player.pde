//Code credit Ruben Verheul, Winand Metz, Ole Neuman

class Player extends Object {
  Timer timer;
  Highscore highscore;

  boolean shieldBonus = false;
  boolean undefeatabaleBonus = false;
  boolean speedBonus = false;
  boolean sparklerBonus = false;
  boolean insideExplosion = false;
  boolean takenBombDamage = false;
  boolean takenEnemyDamage = false;
  boolean gettingAttacked = false;

  int speedX, speedY, startTime, attackDamage;
  int speedBonusTimer = 1000;
  int undefeatabaleBonusTimer = 5000;
  int cloakBonusTimer = 5000;
  int sparklerBonusTimer = 3000;
  int velX = PLAYER_SPEED;
  int velY = PLAYER_SPEED;
  int health = PLAYER_HEALTH;
  int shield = PLAYER_SHIELD;
  float oldX, oldY;
  int bombCooldown = 0;
  int bombSparklerCooldown = 0;

  Player(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, Highscore highscore) {
    super(x, y, w, h, ObjectID.PLAYER, objectHandler, sprites);
    timer = new Timer();
    this.highscore = highscore;
  }

  void update() {
    playerControls();
    
    lb = new PVector(x, y);
    rb = new PVector(x + w, y);
    ro = new PVector(x + w, y + h);
    lo = new PVector(x, y + h);

    or = new PVector((lb.x + rb.x) / 2, (lb.y + lo.y) / 2);

    if (speedX != 0) {
      speedY = 0;
    } else if (speedY != 0) {
      speedX = 0;
    }

    x = x + speedX;
    y = y + speedY;

    if (wallCollisionDetection()) {
      x = oldX - MAP_SCROLL_SPEED;
      y = oldY;
    }

    oldX = x;
    oldY = y;

    powerUpDetection();
    powerUps();

    bombDamage();
    enemyDamage();

    if (shield <= 0) {
      shieldBonus = false;
    }

    if (health <= 0) {
      gameState = 2;
    }

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

    if (sparklerBonus) {
      bombCooldown = bombSparklerCooldown;
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

  void bombDamage() {
    if (!undefeatabaleBonus) {
      if (insideExplosion && !takenBombDamage) {
        health -= BOMB_DAMAGE;
        println("taking " + BOMB_DAMAGE + " damage");
        takenBombDamage = true;
      }
      if (!insideExplosion && takenBombDamage) {
        takenBombDamage = false;
      }
      insideExplosion = false;
    }
  }

  void enemyDamage() {
    if (gettingAttacked && !takenEnemyDamage) {
      health -= attackDamage;
      takenEnemyDamage = true;
    }
    if (!gettingAttacked && takenEnemyDamage) {
      takenEnemyDamage = false;
    }
    gettingAttacked = false;
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
    if (cloakBonus) {
      if (timer.startTimer(cloakBonusTimer)) {
        println("now you see me");
        cloakBonus = false;
      }
    }
    if (undefeatabaleBonus) {
      if (timer.startTimer(undefeatabaleBonusTimer)) {
        undefeatabaleBonus = false;
      }
    }
    if (sparklerBonus) {
      if (timer.startTimer(sparklerBonusTimer)) {
        sparklerBonus = false;
      }
    }
    if (shieldBonus && shield == 0) {
      shieldBonus = false;
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
        highscore.addScore(COIN_SCORE);
        objectHandler.removeEntity(item);
      }

      if (!item.equals(this) && intersection(item) && item.itemId == ItemID.HEART) {
        println("heart goes boom boom");
        health += 1;
        objectHandler.removeEntity(item);
      }

      if (!item.equals(this) && intersection(item) && item.itemId == ItemID.SHIELD) {
        println("thicc");
        shield += 2;
        shieldBonus = true;
        objectHandler.removeEntity(item);
      }

      if (!item.equals(this) && intersection(item) && item.itemId == ItemID.BPOTION) {
        println("me goes not boom boom");
        undefeatabaleBonus = true;
        objectHandler.removeEntity(item);
      }

      if (!item.equals(this) && intersection(item) && item.itemId == ItemID.SPARKLER) {
        println("kaboom? Yes Rico, kaboom");
        sparklerBonus = true;
        objectHandler.removeEntity(item);
      }

      if (!item.equals(this) && intersection(item) && item.itemId == ItemID.CLOAK) {
        println("now you dont");
        cloakBonus = true;
        objectHandler.removeEntity(item);
      }
    }
  }


  void draw() {
    //rect(x, y, w, h);
    image(sprites.getPlayer(), x, y);
  }
}
