//Code credit Winand Metz

//Inladen en tijdelijk opslaan textures
class TextureAssets {

  //Array voor x en y positie in grid
  final PImage[][] sprites;
  final PImage[][] wallSprites;
  final PImage[][] itemsBombsUI;
  final PImage[][] menusUserInterface;
  final PImage[][] entities;
  //final PImage[][] rockSprites;
  //final PImage[][] bWallSprites;
  //final PImage[][] itemsAndUISprites;
  //final PImage[][] backgroundSprites;

  //Class neemt filepaths in en de groote van de gridtegels
  TextureAssets(int tileSize) {
    sprites = loadSprites("data/text/textures.png", tileSize);
    wallSprites = loadSprites("data/text/walls/walls_spritesheet.png", tileSize);
    itemsBombsUI = loadSprites("data/text/items/itemsBombsUI.png", 32);
    menusUserInterface = loadSprites("data/text/ui/menu_ui.png", tileSize);
    entities = loadSprites("data/text/entities/poltergeist_test_64.png", 64);
    //rockSprites = loadSprites('', tileSize);
  }

  PImage getWall(int row, int column) {
    return wallSprites[row][column];
  }

  PImage getPlayer() {
    return sprites[1][1];
  }

  PImage getEntity(int row, int column) {
    return entities[row][column];
  }

  PImage getRock() {
    return sprites[1][0];
  }

  //Lives/armor is (0, 0) tot en met (3, 0), highscore is (0, 1) tot (0, 3)
  //Detonation device off is (4, 0) en on is (5, 0)
  //Hud bomb icons zijn C4(6, 0), dynamite(7, 0) en landmine(7, 1)
  PImage getUserHud(int row, int column) {
    return menusUserInterface[row][column];
  }

  //Landmine (0, 0), dynamite (1, 0), c4 (2, 0)
  PImage getBombItem(int row, int column) {
    return itemsBombsUI[row][column];
  }

  //Z (0), x (2), s (4), a (6), on colum 7 (row, voor non-pressed, + 1 for pressed)
  //Esc on colum 6 (row 0, + 1 for pressed)
  PImage getKeyCap(int row, int column) {
    return itemsBombsUI[row][column];
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
