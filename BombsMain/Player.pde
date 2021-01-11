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
  int shieldProtection = SHIELD_PROTECTION;
  int bombDamage = BOMB_DAMAGE;
  int speedBonusTimer = SPEED_BONUS_TIME;
  int undefeatabaleBonusTimer = UNDEFEATBALE_BONUS_TIME;
  int cloakBonusTimer = CLOACK_BONUS_TIME;
  int sparklerBonusTimer = BOMB_BONUS_TIME;
  float velX = playerSpeed;
  float velY = playerSpeed;
  int health = PLAYER_HEALTH;
  int shield = PLAYER_SHIELD;
  float oldX, oldY;
  int bombCooldown = 0;
  int bombSparklerCooldown = 30;
  int fps = 20;

  Player(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, Highscore highscore, SoundAssets soundAssets) {
    super(x, y, w, h, ObjectID.PLAYER, objectHandler, sprites, soundAssets);
    timer = new Timer("playerTimer");
    this.highscore = highscore;
  }

  void update() {
    playerControls();

    //Vectors voor de collision vierhoek van het object 
    lb = new PVector(x, y);
    rb = new PVector(x + w, y);
    ro = new PVector(x + w, y + h);
    lo = new PVector(x, y + h);

    //Vector voor bepalen van het middelpunt 
    or = new PVector((lb.x + rb.x) / 2, (lb.y + lo.y) / 2);

    if (speedX == 4 || speedY == 4 || speedX == 4 && speedY == 4 || speedX == -4 || speedY == -4 || speedX == -4 && speedY == -4) {
      if ((frameCount % fps) == 0)
        soundAssets.getPlayerFootsteps();
    }

    x = x + speedX;
    y = y + speedY;

    //Collision tegen de walls
    if (wallCollisionDetection()) {
      x = oldX - game.mapHandler.mapScrollSpeed;
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
    if (shield > 0) {
      shieldBonus = true;
    }

    if (health <= 0 || x <= -128) {
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
      soundAssets.getBombPlaced();
    }
    if (input.sDown()&& bombCooldown == 0) {
      objectHandler.addC4(x + w / 4, y + h / 4, BOMB_SIZE, BOMB_SIZE);
      bombCooldown = BOMB_COOLDOWN_TIME;
      soundAssets.getBombPlaced();
    }
    if (input.aDown()&& bombCooldown == 0) {
      objectHandler.addLandmine(x + w / 4, y + h / 4, BOMB_SIZE, BOMB_SIZE);
      bombCooldown = BOMB_COOLDOWN_TIME;
      soundAssets.getBombPlaced();
    }
  }

  void bombDamage() {
    if (!undefeatabaleBonus) {
      if (insideExplosion && !takenBombDamage && shieldBonus == true) {
        bombDamage = bombDamage - shieldProtection;
        if (bombDamage < 0) bombDamage = 0;
        shield -= 1;
        health -= bombDamage;
        takenBombDamage = true;
      }
      if (insideExplosion && !takenBombDamage && shieldBonus == false) {
        health -= bombDamage;
        println("taking " + bombDamage + " damage");
        takenBombDamage = true;
      }
      
      if (!insideExplosion && takenBombDamage) {
        takenBombDamage = false;
      }
      insideExplosion = false;
    }
  }

  void enemyDamage() {
    if (gettingAttacked && !takenEnemyDamage && shieldBonus == true) {
      attackDamage = attackDamage - shieldProtection;
      if (attackDamage < 0) attackDamage = 0;
      shield -= 1;
      health -= attackDamage;
      takenEnemyDamage = true;
    }
    if (gettingAttacked && !takenEnemyDamage && shieldBonus == false) {
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
        soundAssets.getBootsPickUp();
        if (!speedBonus) {
          println("NYOOM");
          velX += SPEED_BONUS;
          velY += SPEED_BONUS;
          speedBonus = true;
        }
        if (speedBonus) {
          speedBonusTimer += SPEED_BONUS_TIME;
        }
        objectHandler.removeEntity(item);
      }

      if (!item.equals(this) && intersection(item) && item.itemId == ItemID.COIN) {
        soundAssets.getCoinPickUp();
        highscore.addScore(COIN_SCORE);
        objectHandler.removeEntity(item);
      }

      if (!item.equals(this) && intersection(item) && item.itemId == ItemID.HEART) {
        soundAssets.getHeartPickUp();
        println("heart goes boom boom");
        health += 1;
        objectHandler.removeEntity(item);
      }

      if (!item.equals(this) && intersection(item) && item.itemId == ItemID.SHIELD) {
        soundAssets.getShieldPickUp();
        println("thicc");
        shield += SHIELD_BONUS;
        objectHandler.removeEntity(item);
      }

      if (!item.equals(this) && intersection(item) && item.itemId == ItemID.BPOTION) {
        soundAssets.getBluePotionPickUp();
        println("me goes not boom boom");
        undefeatabaleBonus = true;
        objectHandler.removeEntity(item);
      }

      if (!item.equals(this) && intersection(item) && item.itemId == ItemID.SPARKLER) {
        soundAssets.getSparklerPickUp();
        println("kaboom? Yes Rico, kaboom");
        sparklerBonus = true;
        objectHandler.removeEntity(item);
      }

      if (!item.equals(this) && intersection(item) && item.itemId == ItemID.CLOAK) {
        soundAssets.getCloakPickUp();
        println("now you dont");
        cloakBonus = true;
        objectHandler.removeEntity(item);
      }
    }
  }

  @Override
    //De dropshadow (zie Object class) is voor de player anders
    void dropShadow() {
    noStroke();
    fill(0, 112);
    ellipse(x + w / 2, y + h * 1.01, w, w * 0.9);
  }


  void draw() {
    if (!cloakBonus) {
      image(sprites.getEntity(1, 1), x, y);
    }
  }
}
