//Code credit Winand Metz

//Class voor het creëren en opslaan van de objecten
class ObjectHandler {

  int eSD = ENTITY_SIZE_DIVIDER;

  ArrayList<Object> walls =  new ArrayList<Object>();
  ArrayList<Object> entities = new ArrayList<Object>();

  Player player = null;

  Assets sprites;

  ObjectHandler(Assets sprites) {
    this.sprites = sprites;
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
    BreakableBlock breakableBlock = new BreakableBlock(x, y - OBJECT_Y_OFFSET, w, h, this, sprites);
    walls.add(breakableBlock);
  }

  //Method voor plaatsen van de player
  void addPlayer() {
    Player player = new Player(PLAYER_X_SPAWN, PLAYER_Y_SPAWN, PLAYER_SIZE, PLAYER_SIZE, this, sprites);
    entities.add(player);
    println("spawned");
  }

  //Method voor plaatsen Ghosts
  void addGhost(float x, float y, int w, int h) {
    Ghost ghost = new Ghost(x, y - OBJECT_Y_OFFSET, w / eSD, h / eSD, this, sprites);
    entities.add(ghost);
  }

  //Method voor plaatsen Poltergeists
  void addPoltergeist(float x, float y, int w, int h) {
    Poltergeist poltergeist = new Poltergeist(x, y - OBJECT_Y_OFFSET, w / eSD, h / eSD, this, sprites);
    entities.add(poltergeist);
  }

  //Method voor plaatsen Mummies
  void addMummy(float x, float y, int w, int h) {
    Mummy mummy = new Mummy(x, y - OBJECT_Y_OFFSET, w / eSD, h / eSD, this, sprites);
    entities.add(mummy);
  }

  //Method voor plaatsen SMummies
  void addSMummy(float x, float y, int w, int h) {
    SMummy sMummy = new SMummy(x, y - OBJECT_Y_OFFSET, w / eSD, h / eSD, this, sprites);
    entities.add(sMummy);
  }

  //Method voor plaatsen van Spiders
  void addSpider(float x, float y, int w, int h) {
    Spider spider = new Spider(x, y - OBJECT_Y_OFFSET, w / eSD, h / eSD, this, sprites);
    entities.add(spider);
  }

  //Method voor plaatsen Explosive_Spiders
  void addExplosiveSpider(float x, float y, int w, int h) {
    ExplosiveSpider explosiveSpider = new ExplosiveSpider(x, y - OBJECT_Y_OFFSET, w / eSD, h / eSD, this, sprites);
    entities.add(explosiveSpider);
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

  void addBoots(float x, float y, int w, int h) {
    Boots boots = new Boots(x, y, w / eSD, h / eSD, this, sprites);
    entities.add(boots);
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
