class Item extends Object {

  Item(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, ObjectID.ITEM, objectHandler, sprites);
  }

  void update() {
  }

  void draw() {
  }

  void ifTouching(Object crate) {
  }
}

class Boots extends Item {

  Boots(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.itemId = ItemID.BOOTS;
  }

  void update() {
  }

  void draw() {
    fill(128, 128, 0);
    rect(x, y, w, h);
  }
}

class Sparkler extends Item {

  Sparkler(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.itemId = ItemID.SPARKLER;
  }

  void update() {
  }

  void draw() {
    fill(128, 128, 0);
    rect(x, y, w, h);
  }
}

class BluePotion extends Item {

  BluePotion(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.itemId = ItemID.BPOTION;
  }

  void update() {
  }

  void draw() {
    fill(128, 128, 0);
    rect(x, y, w, h);
  }
}

class Shield extends Item {

  Shield(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.itemId = ItemID.SHIELD;
  }

  void update() {
  }

  void draw() {
    fill(128, 128, 0);
    rect(x, y, w, h);
  }
}

class Cloak extends Item {

  Cloak(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.itemId = ItemID.CLOAK;
  }

  void update() {
  }

  void draw() {
    fill(128, 128, 0);
    rect(x, y, w, h);
  }
}

class Heart extends Item {

  Heart(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.itemId = ItemID.HEART;
  }

  void update() {
  }

  void draw() {
    fill(128, 128, 0);
    rect(x, y, w, h);
  }
}

class Coin extends Item {
  Coin(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.itemId = ItemID.COIN;
  }
  
  void update() {
  }

  void draw() {
    fill(255, 200, 0);
    rect(x, y, w, h);
  }
}
