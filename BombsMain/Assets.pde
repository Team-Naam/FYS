//Code credit Winand Metz

//Inladen en tijdelijk opslaan textures
class TextureAssets {

  //Array voor x en y positie in grid
  final PImage[][] sprites;
  final PImage[][] wallSprites;
  //final PImage[][] rockSprites;
  //final PImage[][] bWallSprites;
  //final PImage[][] itemsAndUISprites;
  //final PImage[][] backgroundSprites;

  //Class neemt filepaths in en de groote van de gridtegels
  TextureAssets(int tileSize) {
    sprites = loadSprites("data/text/textures.png", tileSize);
    wallSprites = loadSprites("data/text/walls/walls_spritesheet.png", tileSize);
    //rockSprites = loadSprites('', tileSize);
  }

  PImage getWall(int row, int column) {
    return wallSprites[row][column];
  }

  PImage getPlayer() {
    return sprites[1][1];
  }

  PImage getRock() {
    return sprites[1][0];
  }

  //Functie voor het inladen van de verschillende textures in een array
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

class SoundAssets {

  SoundAssets() {
  }
}
