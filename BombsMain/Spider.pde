//Code credit Jordy Post, Winand Metz, Ruben Verheul, Ole Neuman

class Spider extends Entity {

  Spider(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.entityId = EntityID.SPIDER;
    savedTime = millis();
    health = SPIDER_HEALTH;
    roamingTimer = SPIDER_ROAMING;
    velX = SPIDER_MOVEMENT_SPEED ;
    velY = SPIDER_MOVEMENT_SPEED ;
  }

  @Override
  void update(){
   super.update(); 
  }

  void draw() {
    fill(32);
    rect(x, y, w, h);
  }
}

//-----------------------------Special spider---------------------------------

class ExplosiveSpider extends Entity {



  ExplosiveSpider(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.entityId = EntityID.EXPLOSIVE_SPIDER;
    savedTime = millis();
    health = EXPLOSIVE_SPIDER_HEALTH;
    roamingTimer = EXPLOSIVE_SPIDER_ROAMING;
    velX = EXPLOSIVE_SPIDER_MOVEMENT_SPEED;
    velY = EXPLOSIVE_SPIDER_MOVEMENT_SPEED;
  }

@Override
  void update(){
   super.update(); 
  }

  void draw() {
    fill(174);
    rect(x, y, w, h);
  }
}
