class Item extends Object {

  Item(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, ObjectID.ITEM, objectHandler, sprites, soundAssets);
  }

  void update() {
  }

  void draw() {
  }
}

class Boots extends Item {

  Boots(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.itemId = ItemID.BOOTS;
  }

  void update() {
  }

  void draw() {
    image(sprites.getBombItem(4, 0), x, y);
  }
}

class Sparkler extends Item {

  Sparkler(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.itemId = ItemID.SPARKLER;
  }

  void update() {
  }

  void draw() {
    image(sprites.getBombItem(7, 0), x, y);
  }
}

class BluePotion extends Item {

  BluePotion(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.itemId = ItemID.BPOTION;
  }

  void update() {
  }

  void draw() {
    image(sprites.getBombItem(3, 0), x, y);
  }
}

class Shield extends Item {

  Shield(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.itemId = ItemID.SHIELD;
  }

  void update() {
  }

  void draw() {
    image(sprites.getBombItem(6, 0), x, y);
  }
}

class Cloak extends Item {

  Cloak(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.itemId = ItemID.CLOAK;
  }

  void update() {
  }

  void draw() {
    image(sprites.getBombItem(5, 0), x, y);
  }
}

class Heart extends Item {

  Heart(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.itemId = ItemID.HEART;
  }

  void update() {
  }

  void draw() {
    image(sprites.getBombItem(0, 2), x, y);
  }
}

class Coin extends Item {
  Coin(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.itemId = ItemID.COIN;
  }

  void update() {
  }

  void draw() {
    image(sprites.getBombItem(0, 1), x, y);
  }
}
