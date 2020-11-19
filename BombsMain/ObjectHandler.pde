//Code credit Winand Metz

//Class voor het creëren en opslaan van de objecten
class ObjectHandler {

  float enemySpawnChance[][] = new float[6][2];
  float itemSpawnChance[][] = new float[7][2];

  int eSD = ENTITY_SIZE_DIVIDER;

  ArrayList<Object> walls =  new ArrayList<Object>();
  ArrayList<Object> entities = new ArrayList<Object>();

  Player player = null;

  TextureAssets sprites;

  ObjectHandler(TextureAssets sprites) {
    this.sprites = sprites;
    for (int i = 0; i < enemySpawnChance.length; i++) {
      enemySpawnChance[i][0] = i;
    }
    enemySpawnChance[0][1] = GHOST_SPAWN_CHANCE;
    enemySpawnChance[1][1] = POLTERGEIST_SPAWN_CHANCE;
    enemySpawnChance[2][1] = SPIDER_SPAWN_CHANCE;
    enemySpawnChance[3][1] = EXPLOSIVE_SPIDER_SPAWN_CHANCE;
    enemySpawnChance[4][1] = MUMMY_SPAWN_CHANCE;
    enemySpawnChance[5][1] = STONED_MUMMY_SPAWN_CHANCE;

    for (int i = 0; i < itemSpawnChance.length; i++) {
      itemSpawnChance[i][0] = i;
    }
    itemSpawnChance[0][1] = BOOTS_DROP_CHANCE;
    itemSpawnChance[1][1] = SPARKLER_DROP_CHANCE;
    itemSpawnChance[2][1] = BLUE_POTION_DROP_CHANCE;
    itemSpawnChance[3][1] = SHIELD_DROP_CHANCE;
    itemSpawnChance[4][1] = CLOAK_DROP_CHANCE;
    itemSpawnChance[5][1] = HEART_DROP_CHANCE;
    itemSpawnChance[6][1] = COIN_DROP_CHANCE;
  }

  float getEnemy(float rand) {
    for (int i = 0; i < enemySpawnChance.length; i++) {
      if (rand < enemySpawnChance[i][1]) {
        return enemySpawnChance[i][0] + 1;
      }
      rand -= enemySpawnChance[i][1];
    }
    return 1;
  }

  void addEnemy(float x, float y, int w, int h) {
    int total = 0;
    for (int i = 0; i < enemySpawnChance.length; i++) { 
      total += enemySpawnChance[i][1];
    }

    float rand = random(0, 1) * total;
    float enemy = getEnemy(rand);

    //println(enemy);

    //Ghost 
    if (enemy == 1) {
      Ghost ghost = new Ghost(x, y - OBJECT_Y_OFFSET, w / eSD, h / eSD, this, sprites);
      entities.add(ghost);
    }
    //Poltergeist
    if (enemy == 2) {
      Poltergeist poltergeist = new Poltergeist(x, y - OBJECT_Y_OFFSET, w / eSD, h / eSD, this, sprites);
      entities.add(poltergeist);
    }
    //Spider
    if (enemy == 3) {
      Spider spider = new Spider(x, y - OBJECT_Y_OFFSET, w / eSD, h / eSD, this, sprites);
      entities.add(spider);
    }
    //Exp spider
    if (enemy == 4) {
      ExplosiveSpider explosiveSpider = new ExplosiveSpider(x, y - OBJECT_Y_OFFSET, w / eSD, h / eSD, this, sprites);
      entities.add(explosiveSpider);
    }
    //Mummy
    if (enemy == 5) {
      Mummy mummy = new Mummy(x, y - OBJECT_Y_OFFSET, w / eSD, h / eSD, this, sprites);
      entities.add(mummy);
    }
    //SMummy
    if (enemy == 6) {
      SMummy sMummy = new SMummy(x, y - OBJECT_Y_OFFSET, w / eSD, h / eSD, this, sprites);
      entities.add(sMummy);
    }
  }

  //Method voor het creëren van de muren, input lijkt me vanzelf sprekend
  void addWall(float x, float y, int w, int h) {
    Wall wall = new Wall(x, y - OBJECT_Y_OFFSET, w, h, this, sprites);
    walls.add(wall);
  }

  //Method voor de rockwall onder- en bovenkant van het scherm 
  void addRock(float x, float y, int w, int h) {
    Rock rock = new Rock(x, y - OBJECT_Y_OFFSET, w, h, this, sprites);
    walls.add(rock);
  }

  void addBreakableWall(float x, float y, int w, int h) {
    BreakableWall breakableWall = new BreakableWall(x, y - OBJECT_Y_OFFSET, w, h, this, sprites);
    walls.add(breakableWall);
  }

  //Method voor plaatsen van de player
  void addPlayer(Highscore highscore) {
    Player player = new Player(PLAYER_X_SPAWN, PLAYER_Y_SPAWN, PLAYER_SIZE, PLAYER_SIZE, this, sprites, highscore);
    entities.add(player);
    println("spawned");
  }

  //Method voor plaatsen van een Bomb
  void addBomb(float x, float y, int w, int h) {
    Bomb bomb = new Bomb(x, y, w / eSD, h / eSD, this, sprites);
    entities.add(bomb);
  }

  void addC4(float x, float y, int w, int h) {
    C4 c4 = new C4(x, y, w / eSD, h / eSD, this, sprites);
    entities.add(c4);
  }

  void addLandmine(float x, float y, int w, int h) {
    Landmine landmine = new Landmine(x, y, w / eSD, h / eSD, this, sprites);
    entities.add(landmine);
  }

  //Method voor plaatsen van een SpiderBomb
  void addSpiderBomb(float x, float y, int w, int h) {
    SpiderBomb spiderBomb = new SpiderBomb(x, y, w / eSD, h / eSD, this, sprites);
    entities.add(spiderBomb);
  }

  float getItem(float rand) {
    for (int i = 0; i < itemSpawnChance.length; i++) {
      if (rand < itemSpawnChance[i][1]) {
        return itemSpawnChance[i][0] + 1;
      }
      rand -= itemSpawnChance[i][1];
    }
    return 1;
  }

  void addItem(float x, float y, int w, int h) {
    int total = 0;
    for (int i = 0; i < itemSpawnChance.length; i++) { 
      total += itemSpawnChance[i][1];
    }

    float rand = random(0, 1) * total;
    float item = getItem(rand);

    //println(item);

    //Boots
    if (item == 1) {
      Boots boots = new Boots(x, y, w / eSD, h / eSD, this, sprites);
      entities.add(boots);
    }
    //Sparkler
    if (item == 2) {
      Sparkler sparkler = new Sparkler(x, y, w / eSD, h / eSD, this, sprites);
      entities.add(sparkler);
    }
    //Blue Potion
    if (item == 3) {
      BluePotion bluePotion = new BluePotion(x, y, w / eSD, h / eSD, this, sprites);
      entities.add(bluePotion);
    }
    //Shield
    if (item == 4) {
      Shield shield = new Shield(x, y, w / eSD, h / eSD, this, sprites);
      entities.add(shield);
    }
    //Cloak
    if (item == 5) {
      Cloak cloak = new Cloak(x, y, w / eSD, h / eSD, this, sprites);
      entities.add(cloak);
    }
    //Heart
    if (item == 6) {
      Heart heart = new Heart(x, y, w / eSD, h / eSD, this, sprites);
      entities.add(heart);
    }
    //Coin
    if (item == 7) {
      Coin coin = new Coin(x, y, w / eSD, h / eSD, this, sprites);
      entities.add(coin);
    }
  }

  //Method van verwijderen objecten uit array
  void removeEntity(Object entry) {
    entities.remove(entry);
  }

  void removeWall(Object entry) {
    walls.remove(entry);
  }

  //Updates elke list entry
  void update() {
    ArrayList<Object> entityObjects = entities;
    for (int i = 0; i < entityObjects.size(); i++) {
      if (i >= entityObjects.size()) {
        break;
      }
      entityObjects.get(i).moveMap();
      entityObjects.get(i).update();
      //entityObjects.get(i).getVector();
    }

    ArrayList<Object> wallObjects = walls;
    for (int i = 0; i < wallObjects.size(); i++) {
      if (i >= wallObjects.size()) {
        break;
      }
      wallObjects.get(i).moveMap();
      wallObjects.get(i).update();
      wallObjects.get(i).getVector();
    }
  }

  //Draw method voor elk onderdeel in de list
  void draw() {
    ArrayList<Object> entityObjects = entities;
    for (int i = 0; i < entityObjects.size(); i++) {
      if (i >= entityObjects.size()) {
        break;
      }
      entityObjects.get(i).draw();
    }

    ArrayList<Object> wallObjects = walls;
    for (int i = 0; i < wallObjects.size(); i++) {
      if (i >= wallObjects.size()) {
        break;
      }
      wallObjects.get(i).draw();
    }
  }
}
