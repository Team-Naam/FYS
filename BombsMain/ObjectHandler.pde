//Code credit Winand Metz

//Class voor het creëren en opslaan van de objecten
class ObjectHandler {

  //Opzetten van object array voor muren en breekbare blocks
  ArrayList<Object> entries = new ArrayList<Object>();
  Player player = null;

  Sprites sprites;

  ObjectHandler(Sprites sprites) {
    this.sprites = sprites;
  }

  //Method voor het creëren van de muren, input lijkt me vanzelf sprekend
  void addWall(float x, float y, int w, int h) {
    Wall wall = new Wall(x, y - OBJECT_Y_OFFSET, w, h, this, sprites);
    entries.add(wall);
  }

  //Method voor de rockwall onder- en bovenkant van het scherm 
  void addRock(float x, float y, int w, int h) {
    Rock rock = new Rock(x, y - OBJECT_Y_OFFSET, w, h, this, sprites);
    entries.add(rock);
  }

  //Method voor plaatsen van de player
  void addPlayer() {
    Player player = new Player(PLAYER_X_SPAWN, PLAYER_Y_SPAWN, PLAYER_SIZE, PLAYER_SIZE, this, sprites);
    entries.add(player);
    println("spawned");
  }

  //Method voor plaatsen Ghosts
  void addGhost(float x, float y, int w, int h) {
    Ghost ghost = new Ghost(x, y - OBJECT_Y_OFFSET, w / 2, h / 2, this, sprites);
    entries.add(ghost);
  }

  //Method voor plaatsen Mummies
  void addMummy(float x, float y, int w, int h) {
    Mummy mummy = new Mummy(x, y - OBJECT_Y_OFFSET, w / 2, h / 2, this, sprites);
    entries.add(mummy);
  }
  
  //Method voor plaatsen SMummies
  void addSMummy(int x, int y, int w, int h) {
    SMummy sMummy = new SMummy(x, y - OBJECT_Y_OFFSET, w / 2, h / 2, this, sprites);
    entries.add(sMummy);
  }

  //Method voor plaatsen van Spiders
  void addSpider(float x, float y, int w, int h) {
    Spider spider = new Spider(x, y - OBJECT_Y_OFFSET, w / 2, h / 2, this, sprites);
    entries.add(spider);
  }

  //Method voor plaatsen van een Bomb
  void addBomb(float x, float y, int w, int h){
   Bomb bomb = new Bomb(x, y, w / 2, h / 2, this, sprites);
   entries.add(bomb);
  }
  //Method van verwijderen objecten uit array (not used , can be called in object child classes) 
  void removeEntry(Object entry) {
    entries.remove(entry);
  }

  //Updates elke list entry
  void update() {
    ArrayList<Object> objects = entries;
    for (int i = 0; i < objects.size(); i++) {
      if (i >= objects.size()) {
        break;
      }
      game.mapHandler.moveMap(objects.get(i));
      objects.get(i).update();
    }
  }

  //Draw method voor elk onderdeel in de list
  void draw() {
    ArrayList<Object> objects = entries;
    for (int i = 0; i < objects.size(); i++) {
      if (i >= objects.size()) {
        break;
      }
      objects.get(i).draw();
    }
  }
}
