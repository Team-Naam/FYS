//Code credit Winand Metz

//Alles game gerelateerd
class Game {
  ObjectHandler objectHandler;
  MapHandler mapHandler;
  Sprites sprites;

  final int width, height;

  //Inladen van alle assets voor de game en level creation dmv inladen van een png map, op basis van pixels plaatsing van objecten
  //TileSize is grote van de blokken in het plaatsingsgrid (tegelgrote)
  Game(int tileSize, int width, int height) {
    this.width =  width;
    this.height = height;
    sprites = new Sprites("data/text/textures.png", tileSize);
    objectHandler = new ObjectHandler(this.sprites);
    mapHandler = new MapHandler(tileSize);
    objectHandler.addPlayer();
  }

  //Oproepen van objecten in de game zodat ze worden getekend
  void update() {
    mapHandler.update();
    objectHandler.update();
  }

  void draw() {
    background(128);
    objectHandler.draw();
  }
}
