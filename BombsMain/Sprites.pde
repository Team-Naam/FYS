class Sprites {
  final PImage[][] sprites;

  Sprites(String path, int tileSize) {
    sprites = loadSprites(path, tileSize);
  }

  PImage getWall() {
    return sprites[0][1];
  }

  PImage[][] loadSprites(String path, int tileSize) {
    PImage spriteBlock = loadImage(path);
    PImage[][] sprites = new PImage[spriteBlock.width / tileSize][spriteBlock.height / tileSize];
    for (int x = 0; x < spriteBlock.width / tileSize; x ++) {
      for (int y = 0; y < spriteBlock.height / tileSize; y ++) {
        sprites[x][y] = spriteBlock.get(tileSize * x, tileSize * y, tileSize, tileSize);
      }
    }
    return sprites;
  }
}
