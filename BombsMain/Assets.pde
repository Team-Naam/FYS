//Code credit Winand Metz

//Inladen en tijdelijk opslaan textures
class TextureAssets {

  final int fps = 6;

  //Array voor x en y positie in grid
  final PImage[][] sprites;
  final PImage[][] wallSprites;
  final PImage[][] itemsBombsUI;
  final PImage[][] menusUserInterface;
  final PImage[][] entities;
  final PImage[][] vasesAndBackpacks;
  //final PImage[][] corpses;
  final PImage[][] bWallSprites;
  //final PImage[][] rockSprites;
  final PImage[][] backgroundSprites;
  final PImage[][] explosion;

  int frame = 0;

  //Class neemt filepaths in en de groote van de gridtegels
  TextureAssets(int tileSize) {
    sprites = loadSprites("data/text/textures.png", tileSize);
    wallSprites = loadSprites("data/text/walls/walls_spritesheet.png", tileSize);
    itemsBombsUI = loadSprites("data/text/items/itemsBombsUI.png", 32);
    menusUserInterface = loadSprites("data/text/ui/menu_ui.png", tileSize);
    entities = loadSprites("data/text/entities/poltergeist_test_64.png", 64);
    bWallSprites = loadSprites("data/text/walls/broken_walls_spritesheet.png", tileSize);
    vasesAndBackpacks = loadSprites("data/text/objects/vases1.png", 64);
    backgroundSprites = loadSprites("data/text/floors/floors.png", tileSize);
    explosion = loadSprites("data/text/effects/explosion.png", 256);
    //corpses = loadSprites("data/text/objects/", tileSize);
  }

  void getExplosion(int column, float x, float y) {
    if ((frameCount % fps) == 0) {
      frame = (frame + 1) % 11;
    }
    imageMode(CENTER);
    image(explosion[frame][column], x, y);
    imageMode(CORNER);
  }

  PImage getBackground(int row, int column) {
    return backgroundSprites[row][column];
  }

  //PImage getCorpse(int row, int column) {
  //  return corpses[row][column];
  //}

  PImage getObject(int row, int column) {
    return vasesAndBackpacks[row][column];
  }

  PImage getWall(int row, int column) {
    return wallSprites[row][column];
  }

  PImage getBrokenWall(int row, int column) {
    return bWallSprites[row][column];
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

  SoundFile coin;

  float rate, FX_VOLUME;

  SoundAssets(PApplet setup) {
    coin = new SoundFile(setup, "coin.mp3");
    rate = 1;
    FX_VOLUME = 1.0;
  }

  void getCoinPickUp() {
    coin.play(1, FX_VOLUME);
  }
}
