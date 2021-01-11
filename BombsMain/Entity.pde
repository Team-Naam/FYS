//Code credit Jordy Post, Winand Metz, Ruben Verheul, Ole Neuman 

class Entity extends Object {

  int health;
  int attack;
  int roamingTimer;
  int savedTime;
  int speedX;
  int speedY;
  int velX;
  int velY;
  float oldX, oldY;
  float slowAmount;
  float slow;
  int spawnedMiniSpider;
  boolean abilityCharge;
  boolean insideExplosion;
  boolean takenDamage;
  boolean touching;

  Entity(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, ObjectID.ENTITY, objectHandler, sprites, soundAssets);
    savedTime = millis();
    health = 1;
    attack = 1;
    roamingTimer = 1;
    insideExplosion = false;
    takenDamage = false;
    touching = false;
    abilityCharge = false;
    slow = MINI_SPIDER_SLOW;
  }

  void update() {
    //Als het object zich buiten het scherm bevindt wordt hij verwijderd
    selfDestruct();
    bombDamage();
    movement();
    attack();

    x = x + speedX;
    y = y + speedY;

    if (wallCollisionDetection()) {
      x = oldX - game.mapHandler.mapScrollSpeed;
      y = oldY;
    }

    oldX = x;
    oldY = y;

    slowAmount = slow * spawnedMiniSpider;
  }

  void movement() {
    /*Timer voor basic willekeurig ronddwalen over speelveld elke twe seconden gaat hij andere kant op
     Zodra hij binnen 400 pixels van de player komt gaat hij achter de player aan */
    int passedTime = millis() - savedTime;
    if (dist(getPlayerX(), getPlayerY(), x, y) < 400) {
      hunt();
    } else {
      if (passedTime > roamingTimer) {
        speedX = velX * randomOnes();
        speedY = velY * randomOnes();
        savedTime= millis();
      }
    }
  }

  void hunt() {
    float playerX = getPlayerX();
    float playerY = getPlayerY();
    
    
    if (cloakBonus == false && abilityCharge == false) {
      if (playerX > x) {
        speedX = velX;
      } 
      if (playerX < x) {
        speedX = -velX;
      } 
      if (playerY < y) {
        speedY = -velY;
      } 
      if (playerY > y) {
        speedY = velY;
      }
      
      if (dist(playerX, 0, x, 0) < velX) {
        x = playerX;
        speedX = 0;
      }
      if (dist(0, playerY, 0, y) < velY) {
        y = playerY;
        speedY = 0;
      }
    }   
  }

  void bombDamage() {
    //Eerst wordt gecheckt of de object zich in de explosie circle bevind, waarna vervolgens de health ervan wordt afgetrokken
    if (insideExplosion && !takenDamage) {
      soundAssets.getEnemyHit();
      health -= BOMB_DAMAGE;
      takenDamage = true;
    }
    if (health <= 0) {
      if (entityId == EntityID.EXPLOSIVE_SPIDER) {
        objectHandler.addSpiderBomb(x, y, BOMB_SIZE, BOMB_SIZE);
      }
      if (entityId == EntityID.SPIDER_BOSS || entityId == EntityID.WALL_BOSS) {
        game.mapHandler.mapScrolling = true; 
        game.mapHandler.fastforwardWidth = 0.75;
      }
      if (entityId == EntityID.SPIDER_BOSS) {
        for (int i = 0; i < 6; i++) {
          objectHandler.addSpider(x, y, w, h);
        }
      }
      //Object wordt uit de list gehaald en verwijderd
      objectHandler.removeEntity(this);
    }
    if (!insideExplosion && takenDamage) {
      takenDamage = false;
    }
    insideExplosion = false;
  }

  void attack() {
    ArrayList<Object> entityObjects = objectHandler.entities;
    Object playerEntity = entityObjects.get(0);
    if (intersection(playerEntity)) {
      ((Player)playerEntity).attackDamage = attack;
      ((Player)playerEntity).gettingAttacked = true;
      //println("slash");
    }

    if (intersection(playerEntity) && entityId == EntityID.MINI_SPIDER) {
      playerSpeed = slowAmount * playerSpeed;
    }
  }

  void draw() {
  }
}

//Er moet voor collision detection minimaal twee objecten in de entity list zitten, dit is een lege entry, dat nooit verwijderd wordt
class CollisionFix extends Object {

  CollisionFix(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, ObjectID.FIX, objectHandler, sprites, soundAssets);
  }

  @Override
    void moveMap() {
  }

  @Override
    void dropShadow() {
  }

  void update() {
  }

  void draw() {
    //rect(x, y, w, h);
  }
}
