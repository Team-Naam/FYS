public class LevelGeneration {

  final int width, height;

  LevelGeneration(int tileSize, int width, int height) {
    this.width = width;
    this.height = height;
    PImage mapImg = loadImage("map-1.png");
    mapImg.loadPixels();
    loadMap(mapImg.pixels, mapImg.width, mapImg.height, tileSize, tileSize);
  }

  void loadMap(int[] pixels, int w, int h, int tw, int th) {
    for (int x = 0; x < w; x++) {
      for (int y = 0; y < h; y++ ) {
        int loc = x + y * w;
        float c = pixels[loc];
        if (c == 0xFF7F0622) {

        }
        if (c == 0xFF0000FF) {
        }
        if (c == 0xFF00FF00) {
        }
        if (c == 0xFFFF00FF) {
        }
        if (c == 0xFFFFFFFF) {
        }
      }
    }
  }

  //int randomMinOrOne() {
  //  return (int) random(2) * 2 - 1;
  //}

  void update() {
  }

  void draw() {
  }
}
