//Class voor het creëren en opslaan van de objecten
class ObjectHandler {

  //Opzetten van object array voor muren en breekbare blocks
  ArrayList<Block> blocks = new ArrayList<Block>();

  Sprites sprites;

  ObjectHandler(Sprites sprites) {
    this.sprites = sprites;
  }

  //Method voor het creëren van de muren, input lijkt me vanzelf sprekend
  void addWall(int x, int y, int w, int h) {
    Wall wall = new Wall(x, y + 28, w, h, this, sprites);
    blocks.add(wall);
  }

  //Method van verwijderen objecten uit array (not used atm) 
  void removeBlock(Block block) {
    blocks.remove(block);
  }

  //stopt het inladen wanneer hij alles heeft pretty much
  void update() {
    ArrayList<Block> objects = blocks;
    for (int i = 0; i < objects.size(); i++) {
      if (i >= objects.size()) {
        break;
      }
      objects.get(i).update();
    }
  }

  //Draw method voor elk onderdeel in de list
  void draw() {
    ArrayList<Block> objects = blocks;
    for (int i = 0; i < objects.size(); i++) {
      if (i >= objects.size()) {
        break;
      }
      objects.get(i).draw();
    }
  }
}
