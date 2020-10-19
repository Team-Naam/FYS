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
  void addWall(int x, int y, int w, int h) {
    Wall wall = new Wall(x, y + 28, w, h, this, sprites);
    entries.add(wall);
  }

  //Method voor voegen van de player aan de gameobjecten
  void addPlayer() {
    Player player = new Player(0, 156, 64, 64, this, sprites);
    entries.add(player);
    println("spawned");
  }

  void addEnemy(int x, int y, int w, int h) {
    Enemy enemy = new Enemy(x, y, w / 2, h / 2, this, sprites);
    entries.add(enemy);
  }

  //Method van verwijderen objecten uit array (not used atm) 
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
