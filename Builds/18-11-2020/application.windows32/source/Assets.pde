//Code credit Winand Metz

//Inladen en tijdelijk opslaan textures
class TextureAssets {

  //Array voor x en y positie in grid
  final PImage[][] sprites;
  final PImage[][] wallSprites;

  //Class neemt filepath in en de groote van de gridtegels
  TextureAssets(int tileSize) {
    sprites = loadSprites("data/text/textures.png", tileSize);
    wallSprites = loadSprites("data/text/walls/walls_spritesheet.png", tileSize);
  }

  //Laden van de wall op x 0 en y 0, oftwel eerste vak van het grid met tiles van 128 by 128 pixels
  PImage getWall(int row, int column) {
    return wallSprites[row][column];
  }

  PImage getPlayer() {
    return sprites[1][1];
  }

  PImage getRock() {
    return sprites[1][0];
  }

  //Functie voor het inladen van de verschillende textures in de array
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
