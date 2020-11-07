//Code credit Winand Metz

//Inladen en tijdelijk opslaan textures
class Sprites {

  //Array voor x en y positie in grid
  final PImage[][] sprites;

  //Class neemt filepath in en de groote van de gridtegels
  Sprites(String path, int tileSize) {
    sprites = loadSprites(path, tileSize);
  }

  //Laden van de wall op x 0 en y 0, oftwel eerste vak van het grid met tiles van 128 by 128 pixels
  PImage getWall() {
    return sprites[0][0];
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
