class SpiderQueen extends Entity {

  SpiderQueen(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.entityId = EntityID.SPIDER_BOSS;
  }

  @Override
  void update() {
   selfDestruct();
   super.update();
  }

  void draw() {
    fill(#e823e5);
    rect(x, y, w, h);
  }
}

//code credit Jordy
class MovingWall extends Entity {

  boolean activated, activating, stunned, invincible, attacking;
  int currentAttack, amountOfAttacks;

  HalfWall topWall, bottomWall;
  Timer activateTimer = new Timer();

  MovingWall(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.entityId = EntityID.WALL_BOSS;

    health = WALL_BOSS_HP;
    attack = 0;
    velX = 0;
    velY = 0; 
    amountOfAttacks = 3;

    activated = false;
    activating = false;
    stunned = false;
    invincible = true; 
    attacking = false;

    topWall = new HalfWall(x, y, w, h /2, objectHandler, sprites, true, this);
    bottomWall = new HalfWall(x, y + h /2, w, h /2, objectHandler, sprites, false, this);

    objectHandler.entities.add(topWall);
    objectHandler.entities.add(bottomWall);
  }

  @Override
    void update() {
    selfDestruct();
    bombDamage();
    if (activating) {
      Activate();
    }
    movement();
  }
  @Override
    void draw() {
    if (!activated) {
      fill(#3ac93f);
      noStroke();
      rect(x, y, w, h);
    }
  }

  @Override
    void bombDamage() {
    if (insideExplosion && !takenDamage) {
      if (!activated) {
        activating = true;
      }
      takenDamage = true;
    }
    if (health <= 0) {
      objectHandler.removeEntity(this);
      objectHandler.removeEntity(topWall);
      objectHandler.removeEntity(bottomWall);
    }
    if (!insideExplosion && takenDamage) {
      takenDamage = false;
    }
    insideExplosion = false;
  }

  void Activate() {
    if (activateTimer.startTimer(WALL_BOSS_INIT_WAIT)) {
      activated = true;
      activating = false;
    }
  }

  @Override
    void movement() {
    if (topWall.atRest() && bottomWall.atRest() && !attacking) {
      attacking = true;
      topWall.attackState = 0;
      bottomWall.attackState = 0;
      currentAttack = 1;//(int)random (amountOfAttacks);
    }
  }
}



//-----------

class HalfWall extends Entity {
  boolean top;
  MovingWall wallBoss;
  Player player = (Player)objectHandler.entities.get(0);

  Timer timer = new Timer();

  int xRest, yRest, attackState;
  boolean hasSplit, initializing;

  HalfWall(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, boolean top, MovingWall WallBoss) {
    super(x, y, w, h, objectHandler, sprites);
    this.entityId = EntityID.HALF_WALL;

    velX = WALL_BOSS_VEL;
    velY = WALL_BOSS_VEL;
    this.top = top;
    this.wallBoss = WallBoss;

    hasSplit = false;
    initializing = true;

    attackState = 0;

    if (top) {
      xRest = WALL_BOSS_X_REST;
      yRest = WALL_BOSS_Y_REST;
    } else {
      xRest = WALL_BOSS_X_REST;
      yRest = WALL_BOSS_Y_REST + h;
    }
  }

  @Override
    void update() {
    selfDestruct();
    if (initializing) {
      if (wallBoss.activated) {
        if (!hasSplit) Split(WALL_BOSS_INNIT_SPLIT_DIST, WALL_BOSS_INNIT_SPLIT_VEL);

        else {
          toRestPos();


          if (atRest()) {
            initializing = false;
            hasSplit = false;
            wallBoss.invincible = false;
          }
        }
      }
    } else {
      attack();
      movement();
    }
    bombDamage();
  }

  @Override
    void bombDamage() {
    if (insideExplosion && !wallBoss.takenDamage && !wallBoss.invincible) {
      wallBoss.health -= BOMB_DAMAGE;
      wallBoss.takenDamage = true;
    }
    if (!insideExplosion && wallBoss.takenDamage) {
      wallBoss.takenDamage = false;
    }
    insideExplosion = false;
  }

  @Override
    void draw() {
    if (wallBoss.activated) {
      if (top) {
        stroke(5);
        fill(#3ac93f);
        rect(x, y, w, h);
      } else {
        stroke(5);
        fill(#3ac93f);
        rect(x, y, w, h);
      }
    }
  }

  void Split(float splitDist, float splitVel) {
    if (top) y -= splitVel;
    else y += splitVel;
    if (timer.startTimer(int(splitDist / splitVel))) {

      hasSplit = true;
    }
  }

  void combine() {
    if (dist(0, y, 0, yRest) < WALL_BOSS_VEL) {
      y = yRest;
    }

    if (y < yRest) y += velY;
    if (y > yRest) y -= velY;
  }

  void toRestPos() {
    if (dist(x, y, xRest, yRest) < WALL_BOSS_RETURN_VEL) {
      x = xRest;
      y = yRest;
    }
    if (x < xRest) x += WALL_BOSS_RETURN_VEL;
    if (x > xRest) x -= WALL_BOSS_RETURN_VEL;
    if (y < yRest) y += WALL_BOSS_RETURN_VEL;
    if (y > yRest) y -= WALL_BOSS_RETURN_VEL;
  }

  boolean atRest() {
    return (x == xRest && y == yRest);
  }

  boolean hasCombined() {
    return (y == yRest);
  }

  boolean atPlayerX() {
    return (x == player.x);
  }


  @Override
    void movement() {
    if (wallBoss.attacking) {
      switch(wallBoss.currentAttack) {
      case 0:
        duoSlam();
        break;
      case 1:
        noEscape();
        break;
      case 2: 
        rollout();
        break;
      }
    }
  }

  void duoSlam() {
    attack = SLAM_DMG;
    switch(attackState) {
    case 0:
      Split(SLAM_SPLIT, WALL_BOSS_VEL);
      if (hasSplit) attackState ++;
      break;

    case 1:
      if (x > player.x)  x -= velX;
      if (x > player.x && !(x > WALL_BOSS_X_LIMIT));
      if (dist(x, 0, player.x, 0) < WALL_BOSS_VEL) x = player.x;
      if (atPlayerX()) attackState ++;
      break;

    case 2:
      combine();
      if (hasCombined()) attackState ++;
      break;
    case 3:
      wallBoss.stunned = true;
      if (timer.startTimer(SLAM_STUN_TIME))  attackState ++;
      break;

    case 4:
      wallBoss.stunned = false;
      toRestPos();
      if (atRest()) attackState ++;
      break;

    case 5:
      wallBoss.attacking = false;
      hasSplit = false;

      break;
    }
  }

  void noEscape() {
    attack = NO_ESCAPE_DMG;
    switch(attackState) {
    case 0: 
      if (y > yRest - WALL_BOSS_BOX_TOP) y -= velY;
      else {
        wallBoss.invincible = true;
        velX *= NO_ESCAPE_VEL_MODIFIER;
        velY *= NO_ESCAPE_VEL_MODIFIER;
        attackState ++;
      }
      break;
    case 1: 
      if (timer.startTimer(NO_ESCAPE_SPAWN_TIME)) {

        attackState ++;
      }
      break;
    case 2: 
      if (top) {
        for (int i = 1; i < NO_ESCAPE_BWALLS_AMOUNT; i++) {
          objectHandler.addWall(x, y +(i * (h*2) - h*2) -20, w, h *2);
        }
      }
      attackState ++;
      break;
    case 3:
      x -= velX;
      if (player.x + player.w == x) {
        player.x -= velX;

        if (x < xRest - WALL_BOSS_BOX_LEFT + player.w && player.y > TILE_SIZE *3 -player.h && player.y < TILE_SIZE *5) {
          player.attackDamage = attack;
          player.gettingAttacked = true;
        }
      }

      int currentLength = objectHandler.walls.size() -NO_ESCAPE_BWALLS_AMOUNT;
      for (int i = 1; i < NO_ESCAPE_BWALLS_AMOUNT; i++) {
        objectHandler.walls.get(currentLength +i).x -= velX /2;
      }
      if (x < xRest - WALL_BOSS_BOX_LEFT) {
        currentLength = objectHandler.walls.size();
        for (int i = 1; i < NO_ESCAPE_BWALLS_AMOUNT; i++) {
          objectHandler.walls.remove(objectHandler.walls.get(currentLength -i));
        }
        attackState ++;
      }
      break;
    case 4:
      wallBoss.invincible = false;
      wallBoss.stunned = true;
      if (timer.startTimer(NO_ESCAPE_STUN_TIME))  attackState ++;
      break;
    case 5:
      wallBoss.stunned = false;
      toRestPos();
      if (atRest()) attackState ++;
      break;
    case 6: 
      wallBoss.attacking = false;
      hasSplit = false;
      velX = WALL_BOSS_VEL;
      velY = WALL_BOSS_VEL;
      break;
    }
  }

  void rollout() {
    attack = ROLLOUT_DMG;
    switch(attackState) {
    case 0: 
      if (timer.startTimer(ROLLOUT_CHARGE_TIME)) {
        velX = -WALL_BOSS_VEL * ROLLOUT_VEL_MODIFIER;
        velY = WALL_BOSS_VEL * ROLLOUT_VEL_MODIFIER;
        wallBoss.invincible = true;
        attackState ++;
      }
      break;
    case 1: 
      x += velX;
      y += velY;

      if (y > yRest - WALL_BOSS_BOX_TOP) {
        velY *= -1;
      }
      if (y < yRest + WALL_BOSS_BOX_BOTTOM) {
        velY *= -1;
      }
      if (x < xRest - WALL_BOSS_BOX_LEFT) {
        velX *= -1;
      }
      if (x > xRest + WALL_BOSS_BOX_RIGHT) {
        velX = WALL_BOSS_VEL;
        velY = WALL_BOSS_VEL;
        attackState ++;
      }
      break;
    case 2: 
      toRestPos();
      if (atRest()) {
        wallBoss.invincible = false;
        attackState ++;
      }
      break;
    case 3: 
      wallBoss.stunned = true;
      if (timer.startTimer(ROLLOUT_STUN_TIME))
        attackState ++;
      break;
    case 4: 
      wallBoss.stunned = false;
      wallBoss.attacking = false;
      hasSplit = false;
      break;
    }
  }
}
