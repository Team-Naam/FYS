//Alles game gerelateerd

class Game {
  ObjectHandler objectHandler;
  Sprites sprites;
  Player player;

  final int width, height;

  //Inladen van alle assets voor de game en level creation dmv inladen van een png map, op basis van pixels plaatsing van objecten
  //TileSize is grote van de blokken in het plaatsingsgrid (tegelgrote)
  Game(int tileSize, int width, int height) {
    this.width =  width;
    this.height = height;
    sprites = new Sprites("data/text/textures.png", tileSize);
    objectHandler = new ObjectHandler(this.sprites);
    PImage map = loadImage("data/maps/map1.png");
    objectHandler.addPlayer();
    map.loadPixels();
    loadMap(map.pixels, map.width, map.height, tileSize, tileSize, this.objectHandler);
  }

  //Oproepen van objecten in de game zodat ze worden getekend
  void update() {
    objectHandler.update();
  }

  void draw() {
    background(128);
    objectHandler.draw();
  }
}

//Het bepalen van de plaatsing van objecten in het level dmv aflezen pixel colorcodes(android graphics color) en dit omzetten in een grid van 15 bij 8
void loadMap(int[] pixels, int w, int h, int tw, int th, ObjectHandler objectHandler) {
  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++ ) {
      int loc = x + y * w;
      float c = pixels[loc];
      if (c == 0xFF7F0622) {
        objectHandler.addWall(x * tw, y * th, tw, th);
      }
    }
  }
}
