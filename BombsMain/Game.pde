//Alles game gerelateerd

class Game {
  ObjectHandler objectHandler;
  Sprites sprites;

  final int width, height;

  Game(int tileSize, int width, int height) {
    this.width =  width;
    this.height = height;
    sprites = new Sprites("textures.png", tileSize);
    objectHandler = new ObjectHandler(this.sprites);
    PImage map = loadImage("map-1.png");
    map.loadPixels();
    loadMap(map.pixels, map.width, map.height, tileSize, tileSize, this.objectHandler);
  }

  void update() {
    objectHandler.update();
  }

  void draw() {
    objectHandler.draw();
  }
}

void loadMap(int[] pixels, int w, int h, int tw, int th, ObjectHandler objectHandler) {
  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++ ) {
      int loc = x + y * w;
      float c = pixels[loc];
      if (c == 0xFF7F0622) {
        objectHandler.addWall(x * tw, y * th, tw, th);
        //rect(x * tw, y * th, tw, th);
      }
    }
  }
}
