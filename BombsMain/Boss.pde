class SpiderQueen extends Entity {

  String currentAttack, currentSpiderSpawn;
  int abilityTimer, birthTimer, rechargeTimer, spiderSpawnTime, webAttackDelay, amountWebsShot;
  float abilityPicker;
  boolean doneShooting, spawnSpider;
  Timer pickTimer, attackTimer, webAttackTimer, explosiveBirthTimer, seriousBirthTimer, spiderSpawnTimer;
  ArrayList<Bullet> bullets;


  SpiderQueen(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.entityId = EntityID.SPIDER_BOSS;

    health = SPIDERQUEEN_HEALTH;
    attack = SPIDERQUEEN_ATTACK;
    velX = SPIDERQUEEN_MOVEMENT;
    velY = SPIDERQUEEN_MOVEMENT;
    abilityTimer = ABILITY_TIMER;
    birthTimer = BIRTH_TIMER;
    rechargeTimer = RECHARGE_TIMER;
    webAttackDelay = WEB_ATTACK_DELAY;
    spiderSpawnTime = SPIDER_SPAWN_TIME;
    pickTimer = new Timer("pickTimer");
    webAttackTimer = new Timer("webAttackTimer");
    explosiveBirthTimer = new Timer("explosiveBirthTimer");
    seriousBirthTimer = new Timer("seriousBirthTimer");
    spiderSpawnTimer = new Timer("spiderSpawnTimer");
    attackTimer = new Timer ("attackTimer");
    currentAttack = "";
    currentSpiderSpawn = "";
    spawnSpider = true;

    amountWebsShot = 0;
    doneShooting = false;

    bullets = new ArrayList();
  }

  @Override
    void update() {
    selfDestruct();
    super.update();
    attackUpdate();
    spiderSpawnUpdate();

    //wanneer de boss geen ability charged ->
    if (abilityCharge == false) {
      //wanneer de timer evenlang is als de aangegeven timer (pickTimer op abilityTimer), lees dan de regels onder.
      if (pickTimer.startTimer(abilityTimer)) {
        println("i read this");
        abilityCharge();
        abilityCharge = true;
      }
    }
    //als een mini spider gespawnt is, reset hij de spiderSpawnTimer/switched hij de case naar spiderSpawn
    if (spawnSpider == true) {
      println("spiderSpawn");
      currentSpiderSpawn = "spiderSpawn";
      spiderSpawnTimer.startTime = 0;
      spiderSpawnTimer.startTime = millis();
      spawnSpider = false;
    }
  }

  //aanroepen spawn Mini Spiders
  void spiderSpawnUpdate() {
    switch(currentSpiderSpawn) {
    case "spiderSpawn":
      if (spiderSpawnTimer.startTimer(spiderSpawnTime)) {
        for (int i = 0; i < 4; i++) /*misschien i++ vervangen door (i += 1;)*/ {
          for (int j = 0; j < 2; j++) {
            objectHandler.addMiniSpider(x, y, w, h);
            spawnedMiniSpider += 1;
            //spawn mini spiders (maak nog mini-spiders)
          }
          //i += 1;
          spawnSpider = true;
        }
        break;
      }
    default:
      break;
    }
  }


  void attackUpdate() {
    switch(currentAttack) {
    case "webAttack":
      //het aanroepen van bullets
      if (webAttackTimer.startTimer(webAttackDelay) && amountWebsShot <= 4 && !doneShooting) {
        objectHandler.addBullet(x, y);
        amountWebsShot += 1;
        //attackTimer.startTime = millis();
        println(amountWebsShot);
        if (amountWebsShot >= 5) {
          doneShooting = true;
        }
      } else { 
        //einde van de attack (kan weer lopen en de current attack wordt gereset
        if (attackTimer.startTimer(5000)) {
          velX = SPIDERQUEEN_MOVEMENT;
          velY = SPIDERQUEEN_MOVEMENT;
          println("hi");
          currentAttack = "";
          abilityCharge = false;
        }
      }
      break;

    case "explosiveBirth":
      //2 explosivespider aanmaken
      if (explosiveBirthTimer.startTimer(birthTimer)) {
        for (int i = 0; i < 2; i++) {
          objectHandler.addExplosiveSpider(x, y, w, h);
        }
        velX = SPIDERQUEEN_MOVEMENT;
        velY = SPIDERQUEEN_MOVEMENT;
        currentAttack = "";
        abilityCharge = false;
      }
      break;

    case "seriousBirth":
      //2 normale spiders aanmaken
      if (seriousBirthTimer.startTimer(birthTimer)) {
        for (int i = 0; i < 2; i++) {
          objectHandler.addSpider(x, y, w, h);
        }
        velX = SPIDERQUEEN_MOVEMENT;
        velY = SPIDERQUEEN_MOVEMENT;
        currentAttack = "";
        abilityCharge = false;
      }
      break;

    default:
      abilityCharge = false;
      break;
    }
  }

  void abilityCharge() {
    //een random picker tussen de verschillende abilities
    println("i read this aswell");
    abilityPicker = random(30);
    //random ability kiezer
    if (abilityPicker <= 10 && abilityPicker >= 0) {
      webAttack();
    }
    if (abilityPicker <= 20 && abilityPicker > 10) {
      explosiveBirth();
    }
    if (abilityPicker <= 30 && abilityPicker > 20) {
      seriousBirth();
    }
    abilityCharge = false;
  }

  //aanroepen wat er voor webAttack allemaal moet gebeuren/aangeroepen (case switchen, timer starten...)
  void webAttack() {

    println("web attack");
    velY = 0;
    velX = 0;
    currentAttack = "webAttack";
    doneShooting = false;
    amountWebsShot = 0;
    webAttackTimer.startTime = millis();
  }

  //aanroepen wat er voor explosiveBirth allemaal moet gebeuren/aangeroepen (case switchen, timer starten...)
  void explosiveBirth() {
    println("explosive birth");
    velY = 0;
    velX = 0;
    explosiveBirthTimer.startTime = millis();
    currentAttack = "explosiveBirth";
  }

  //aanroepen wat er voor seriousBirth allemaal moet gebeuren/aangeroepen (case switchen, timer starten...)
  void seriousBirth() {
    println("serious birth");
    velY = 0;
    velX = 0;
    seriousBirthTimer.startTime = millis();
    currentAttack = "seriousBirth";
  }

  void draw() {
    fill(#e823e5);
    rect(x, y, w, h);
  }
}

//class voor de bullets die de SpiderQueen schiet, extends uit de Object class
class Bullet extends Object {
  float playerPosX, playerPosY, velX, velY;
  float bulletSpeed;

  Bullet(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, ObjectID.BULLET, objectHandler, sprites, soundAssets);
    playerPosX = getPlayerX();
    playerPosY = getPlayerY();
    bulletSpeed = BULLET_SPEED;
    velocityCalculation();
  }
  //berekent de snelheid dat de kogel moet hebben
  void velocityCalculation() {
    float dir_x = playerPosX - x;
    float dir_y = playerPosY - y;
    // de snelheid gedeeld door de wortel van (het kwadraad van de directie van x en het kwadraad van de directie van y) (ab^2 + ac^ = bc^2)
    float factor = bulletSpeed / sqrt(sq(dir_x) + sq(dir_y));
    velX = dir_x * factor;
    velY = dir_y * factor;
  }

  void checkCollision() {
    //checkt of de bullet met een wall collide.
    if (wallCollisionDetection()) {
      objectHandler.removeEntity(this);
    }
    // checkt of de bullet met de player collide.
    if (intersection(objectHandler.entities.get(0))) {
      ((Player)objectHandler.entities.get(0)).health -= BULLET_DAMAGE;
      objectHandler.removeEntity(this);
    }
  }

  void update() {
    checkCollision();
    x += velX;
    y += velY;
  }

  void draw() {
    fill(255);
    ellipse(x, y, w, h);
  }
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------//
//code credit Jordy
class MovingWall extends Entity {

  boolean activated, activating, stunned, invincible, attacking;
  int currentAttack, amountOfAttacks;

  HalfWall topWall, bottomWall;
  Timer activateTimer = new Timer("activateTimer");

  MovingWall(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
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
    
    //maakt de bovenste en onderste helft van de boss die pas zichtbaar worden als de boss geactiveerd is
    topWall = new HalfWall(x, y, w, h /2, objectHandler, sprites, soundAssets, true, this);
    bottomWall = new HalfWall(x, y + h /2, w, h /2, objectHandler, sprites, soundAssets, false, this);

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
  //zodat de boss gedamaged wordt als hij in de explosie van een bom zit
    void bombDamage() {
    if (insideExplosion && !takenDamage) {
      if (!activated) {
        activating = true;
      }
      takenDamage = true;
      soundAssets.getEnemyHit();
    }
    if (health <= 0) {
      //zodat alles van de boss weg gaat als hij dood gaat
      objectHandler.removeEntity(this);
      objectHandler.removeEntity(topWall);
      objectHandler.removeEntity(bottomWall);
      soundAssets.getEnemyDies();
    }
    if (!insideExplosion && takenDamage) {
      takenDamage = false;
    }
    insideExplosion = false;
  }

  void Activate() {
    //activeerd de boss
    if (activateTimer.startTimer(WALL_BOSS_INIT_WAIT)) {
      activated = true;
      activating = false;
    }
  }

  @Override
    void movement() {
      //als de boss na een attack op de rust positie zit begint er een nieuwe willekeurige attack
    if (atRest() && !attacking) {
      attacking = true;
      topWall.attackState = 0;
      bottomWall.attackState = 0;
      topWall.velX = WALL_BOSS_VEL;
      topWall.velY = WALL_BOSS_VEL;
      bottomWall.velX = WALL_BOSS_VEL;
      bottomWall.velY = WALL_BOSS_VEL;
      currentAttack = (int)random (amountOfAttacks);
    }
  }

  //geeft true als zowel de topwall als de bottomwall op de rustpositie zijn
  boolean atRest() {
    return topWall.atRest() && bottomWall.atRest();
  }

  //geeft true als zowel de topwall als de bottomwall gesplit zijn
  boolean hasSplit() {
    return topWall.hasSplit && bottomWall.hasSplit;
  }
  //deze twee bovenste waren nodig om de topwall en bottomwall gesynchroniseerd te houden
}



//-----------
//een class waar alle code voor de topwall en de bottomwall in zit 
//als je iets alleen met één van de delen wilt kan je de boolean top gebruiken
class HalfWall extends Entity {
  boolean top;
  MovingWall wallBoss;
  Player player = (Player)objectHandler.entities.get(0);

  Timer timer = new Timer("wallTimer");

  int xRest, yRest, attackState;
  boolean hasSplit, initializing;

  HalfWall(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets, boolean top, MovingWall WallBoss) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.entityId = EntityID.HALF_WALL;

    velX = WALL_BOSS_VEL;
    velY = WALL_BOSS_VEL;
    this.top = top;
    this.wallBoss = WallBoss;

    hasSplit = false;
    initializing = true;

    attackState = 0;

    //geeft een andere rustpositie als het de bovenste helf is of de onderste
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
    //dit is de initialisatie 
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
      //dit gebeurt alleen als de boss geinitialiseerd is
      attack();
      movement();
    }
    bombDamage();
  }

  @Override
    //als halfwall gedamaged word door een bom gaat er health af bij de wallboss 
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
      //tekent alleen als de wallboss geactiveerd is
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
    //zorgt ervoor dat de twee delen een gegeven afstand en snelheid uit elkaar gaan 
    if (top) y -= splitVel;
    else y += splitVel;
    if (timer.startTimer(int(splitDist / splitVel))) {

      hasSplit = true;
    }
  }

  void combine() {
    //zorgt dat de twee helfden bij elkaar komen op de rustpositie van de y-as
    if (dist(0, y, 0, yRest) < WALL_BOSS_VEL) {
      y = yRest;
    }

    if (y < yRest) y += velY;
    if (y > yRest) y -= velY;
  }

  void toRestPos() {
    //zorgt ervoor dat de twee helfden naar de rustpositie gaan
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
    //kijkt of deze halfwall op de rustpositie is
    return (x == xRest && y == yRest);
  }

  boolean hasCombined() {
    //kijkt of deze halfwall op de rustpositie van de y-as is
    //wordt gebruikt om te kijken of de halfwall gecombineerd is 
    return (y == yRest);
  }

  boolean atPlayerX() {
    //kijkt of de halfwall op de x van de player is player 
    return (x == player.x);
  }


  @Override
    void movement() {
      //kijkt welke attack uitgevoerd moet worden
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
    //voert de duoslam attack uit iedere case is een andere fase van de attack
    attack = SLAM_DMG;
    switch(attackState) {
    case 0:
      Split(SLAM_SPLIT, WALL_BOSS_VEL);
      if (wallBoss.hasSplit()) attackState ++;
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
      if (wallBoss.atRest()) attackState ++;
      break;

    case 5:
      wallBoss.attacking = false;
      hasSplit = false;

      break;
    }
  }

  void noEscape() {
    //voert de noEscape attack uit iedere case is een andere fase van de attack
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

      int currentLength = objectHandler.walls.size();
      for (int i = 1; i < NO_ESCAPE_BWALLS_AMOUNT; i++) {
        objectHandler.walls.get(currentLength -i).x = x;
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
      if (wallBoss.atRest()) attackState ++;
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
    //voert de rollout attack uit iedere case is een andere fase van de attack
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
      if (wallBoss.atRest()) {
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
