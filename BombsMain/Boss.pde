class SpiderQueen extends Entity {

  SpiderQueen(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.entityId = EntityID.SPIDER_BOSS;
  }
  
  @Override
  void update(){
   super.update();
  }

  void draw() {
    fill(#e823e5);
    rect(x, y, w, h);
  }
}

class MovingWall extends Entity {

  MovingWall(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.entityId = EntityID.WALL_BOSS;
  }

  void draw() {
    fill(#3ac93f);
    rect(x, y, w, h);
  }
}
