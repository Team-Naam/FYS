import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import samuelal.squelized.*; 
import processing.sound.*; 
import java.util.Queue; 
import java.util.ArrayDeque; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class BombsMain extends PApplet {

/*  Project FYS BombRunner Winand Metz 500851135, Ole Neuman 500827044, 
 Ruben Verheul 500855129, Jordy Post 500846919, Alex Tarnòki 500798826
 
 Controls: pijltjes toetsen voor lopen, z voor plaatsen dynamiet, s voor C4 plaatsen en x voor exploderen, a voor landmine plaatsen en esc voor exit */

//Code credit Winand Metz, Ole Neuman



//Voor main menu etc
Game game;
InputHandler input;
MainMenu mainMenu;
GameOver gameOver;
TextureAssets textureAssets;
SoundAssets soundAssets;

PFont bits;

int gameState;

boolean escapePressed;

final int KEY_LIMIT = 1024;
boolean[] keysPressed = new boolean[KEY_LIMIT];

public void setup() {
  
  //size(1920, 1080, P2D);
  frameRate(FRAMERATE);

  bits = createFont("data/font/8bitlim.ttf", 40, true);
  textFont(bits);

  input = new InputHandler();
  soundAssets = new SoundAssets(this);
  textureAssets = new TextureAssets(TILE_SIZE);
  mainMenu = new MainMenu(textureAssets, soundAssets);
  game = new Game(TILE_SIZE, width, height, textureAssets, soundAssets);
  gameOver = new GameOver(textureAssets);

  gameState = 0; //gameState for the main menu
}

//code credit Jordy
//stuurt je naar de main menu en reset de game
public void toMainMenu() {
  gameState = 0;
  game = new Game(TILE_SIZE, width, height, textureAssets, soundAssets);
}

//-----------------------------Draw & Key functies---------------------------------

public void draw() {
  instructionPicker();

  escapePressed = false;
}

//this method calls certain other methods based on the current gameState
public void instructionPicker() {     
  switch(gameState) {
  case 0:
    mainMenu.update();
    mainMenu.draw();
    break;

  case 1:
    game.update();
    game.draw();
    break;

  case 2:
    gameOver.update(game.highscore);
    gameOver.draw();
    break;

  default:
    mainMenu.update();
    mainMenu.draw();
    break;
  }
}

public void keyPressed() {  
  if (keyCode >= KEY_LIMIT) return;
  keysPressed[keyCode] = true;

  //rebind van escape
  if (key == ESC) {
    key = 0;
    escapePressed = true;
  }
}

public void keyReleased() {
  if (keyCode >= KEY_LIMIT) return;
  keysPressed[keyCode] = false;
}
//Code credit Winand Metz

//Inladen en tijdelijk opslaan textures
class TextureAssets {

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
  final PImage[][] backgroundOverlays;
  final PImage[][] explosion;
  final PImage logo;


  //Class neemt filepaths in en de groote van de gridtegels
  TextureAssets(int tileSize) {
    logo = loadImage("data/text/logo_highres.png");
    sprites = loadSprites("data/text/textures.png", tileSize);
    wallSprites = loadSprites("data/text/walls/walls_spritesheet.png", tileSize);
    itemsBombsUI = loadSprites("data/text/items/itemsBombsUI.png", 32);
    menusUserInterface = loadSprites("data/text/ui/menu_ui.png", tileSize);
    entities = loadSprites("data/text/entities/poltergeist_test_64.png", 64);
    bWallSprites = loadSprites("data/text/walls/broken_walls_spritesheet.png", tileSize);
    vasesAndBackpacks = loadSprites("data/text/objects/vases1.png", 64);
    backgroundSprites = loadSprites("data/text/floors/floors.png", tileSize);
    backgroundOverlays = loadSprites("data/text/floors/overlays.png", tileSize);
    explosion = loadSprites("data/text/effects/explosion.png", 256);
    //corpses = loadSprites("data/text/objects/", tileSize);
  }

  public PImage getLogo() {
    return logo;
  }

  public PImage getBackground(int row, int column) {
    return backgroundSprites[row][column];
  }

  public PImage getBackgroundOverlay(int row, int column) {
    return backgroundOverlays[row][column];
  }

  //PImage getCorpse(int row, int column) {
  //  return corpses[row][column];
  //}

  public PImage getObject(int row, int column) {
    return vasesAndBackpacks[row][column];
  }

  public PImage getWall(int row, int column) {
    return wallSprites[row][column];
  }

  public PImage getBrokenWall(int row, int column) {
    return bWallSprites[row][column];
  }

  public PImage getEntity(int row, int column) {
    return entities[row][column];
  }

  public PImage getRock() {
    return sprites[1][0];
  }

  //Lives/armor is (0, 0) tot en met (3, 0), highscore is (0, 1) tot (0, 3)
  //Detonation device off is (4, 0) en on is (5, 0)
  //Hud bomb icons zijn C4(6, 0), dynamite(7, 0) en landmine(7, 1)
  public PImage getUserHud(int row, int column) {
    return menusUserInterface[row][column];
  }

  //Landmine (0, 0), dynamite (1, 0), c4 (2, 0)
  public PImage getBombItem(int row, int column) {
    return itemsBombsUI[row][column];
  }

  //Z (0), x (2), s (4), a (6), on colum 7 (row, voor non-pressed, + 1 for pressed)
  //Esc on colum 6 (row 0, + 1 for pressed)
  public PImage getKeyCap(int row, int column) {
    return itemsBombsUI[row][column];
  }
}

class SpriteSheetAnim {

  PImage[][] images;

  float x, y, index, speed;
  int fps, column, frames;

  boolean playing, playOnce, center;

  SpriteSheetAnim(PImage[][] images_, int column_, int frames_, int fps) {
    this.images = images_;
    this.column = column_;
    this.frames = frames_;

    playing = true;
    playOnce = false;
    center = false;

    index = 0;
    setFPS(fps);
  }

  public void setFPS(int fps) {
    this.fps = fps;
  }

  public void setSpeed(int fps) {
    speed = fps / (float)frameRate;
  }

  public void setCenter() {
    center = true;
  }

  public void playOnce() {
    index = 0;
    playOnce = true;
    playing = true;
  }

  public void loop() {
    playing = true;
    playOnce = false;
  }

  public void stop() {
    playing = false;
    playOnce = false;
  }

  public boolean isPlaying() {
    return playing;
  }

  public void draw() {
    int imageIndex = PApplet.parseInt(index);

    if (!center) {
      image(images[imageIndex][column], x, y);
    }
    if (center) {
      imageMode(CENTER);
      image(images[imageIndex][column], x, y);
      imageMode(CORNER);
    }
  }

  public void update(float x_, float y_) {
    this.x = x_;
    this.y = y_;
    
    setSpeed(fps);

    if (playing) {
      index += speed;

      if (index >= frames) {
        if (playOnce) {
          playing = false;
          index = frames - 1;
        } else {
          index -= frames;
        }
      }
    }
  }
}

class SoundAssets {

  SoundFile item_coin, item_heart, item_cloak, item_shield, item_sparkler, item_bluepotion, item_boots;
  SoundFile enemy_hit, enemy_dies;
  SoundFile player_hit, player_dies, player_footsteps;
  SoundFile bomb_placed, bomb_exploded, bomb_breaks_object;
  SoundFile menu_hover, menu_select;
  Reverb roomRev;
  LowPass lowPass;

  final float room = 0.1f;
  final float damp = 0;
  final float wet = 1;

  float rate, FX_VOLUME;

  SoundAssets(PApplet setup) {
    //--ITEM SOUND EFFECTS-------------------------------------------------------------------------
    item_coin = new SoundFile(setup, "data/sound/item/coin.mp3");
    item_heart = new SoundFile(setup, "data/sound/item/heart.mp3");
    item_cloak = new SoundFile(setup, "data/sound/item/cloak.mp3");
    item_shield = new SoundFile(setup, "data/sound/item/shield.mp3");
    item_sparkler = new SoundFile(setup, "data/sound/item/sparkler.mp3");
    item_bluepotion = new SoundFile(setup, "data/sound/item/bluepotion.mp3");
    item_boots = new SoundFile(setup, "data/sound/item/boots.mp3");
    //--ENEMY SOUNDS EFFECTS-----------------------------------------------------------------------
    enemy_hit = new SoundFile(setup, "data/sound/enemy/hit.mp3");
    enemy_dies = new SoundFile(setup, "data/sound/enemy/dies.mp3");
    //--PLAYER SOUND EFFECTS-----------------------------------------------------------------------
    player_hit = new SoundFile(setup, "data/sound/player/hit.mp3");
    player_dies = new SoundFile(setup, "data/sound/player/dies.mp3");
    player_footsteps = new SoundFile(setup, "data/sound/player/footsteps.mp3");
    //--BOMB SOUND EFFECTS-------------------------------------------------------------------------
    bomb_placed = new SoundFile(setup, "data/sound/bomb/placed.mp3");
    bomb_exploded = new SoundFile(setup, "data/sound/bomb/exploded.mp3");
    bomb_breaks_object = new SoundFile(setup, "data/sound/bomb/breaksobject.mp3");
    //--MENU SOUND EFFECTS-------------------------------------------------------------------------
    menu_hover = new SoundFile(setup, "data/sound/menu/hover.mp3");
    menu_select = new SoundFile(setup, "data/sound/menu/select.mp3");

    roomRev = new Reverb(setup);
    lowPass = new LowPass(setup);

    roomRev.set(room, damp, wet);
    lowPass.freq(500);

    rate = 1;
    FX_VOLUME = 0.75f;
  }

  //ITEM SOUND EFFECTS--------------------------------
  public void getCoinPickUp() {
    item_coin.play(1, FX_VOLUME);
  }
  public void getHeartPickUp() {
    item_heart.play(1, FX_VOLUME);
  }
  public void getCloakPickUp() {
    item_cloak.play(1, FX_VOLUME);
  }
  public void getShieldPickUp() {
    item_shield.play(1, FX_VOLUME);
  }
  public void getSparklerickUp() {
    item_sparkler.play(1, FX_VOLUME);
  }
  public void getBluePotionPickUp() {
    item_bluepotion.play(1, FX_VOLUME);
  }
  public void getBootsPickUp() {
    item_boots.play(1, FX_VOLUME);
  }
  //ENEMY SOUNDS EFFECTS-----------------------------
  public void getEnemyHit() {
    enemy_hit.play(1, FX_VOLUME);
  }
  public void getEnemyDies() {
    enemy_dies.play(1, FX_VOLUME);
  }
  //PLAYER SOUND EFFECTS------------------------------
  public void getPlayerHit() {
    player_hit.play(1, FX_VOLUME);
  }
  public void getPlayerDies() {
    player_dies.play(1, FX_VOLUME);
  }
  public void getPlayerFootsteps() {
    player_footsteps.play(1, FX_VOLUME - 0.5f);
    roomRev.process(player_footsteps);
    lowPass.process(player_footsteps);
  }
  //BOMB SOUND EFFECTS------------------------------
  public void getBombPlaced() {
    bomb_placed.play(1, FX_VOLUME);
  }
  public void getBombExploded() {
    bomb_exploded.play(1, FX_VOLUME - 0.60f);
  }

  public void getBombBreaksObject() {
    bomb_breaks_object.play(1, FX_VOLUME);
  }
  //MENU SOUND EFFECTS------------------------------
  public void getMenuHover() {
    menu_hover.play(1, FX_VOLUME);
  }
  public void getMenuSelect() {
    menu_select.play(1, FX_VOLUME);
  }
}

//Code credit Winand Metz

//Muren, moet nog collision op
class Wall extends Object {
  Ray leftRay;
  Ray rightRay;
  Ray upRay;
  Ray downRay;

  boolean leftCon, rightCon, upCon, downCon;

  Wall(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, ObjectID.WALL, objectHandler, sprites, soundAssets);
  }

  public void update() {
    selfDestruct();

    leftCon = false;
    rightCon = false;
    upCon = false;
    downCon = false;

    lb = new PVector(x, y);
    rb = new PVector(x + w, y);
    ro = new PVector(x + w, y + h);
    lo = new PVector(x, y + h);

    or = new PVector((lb.x + rb.x) / 2, (lb.y + lo.y) / 2);

    left = new PVector(x - 5, (lb.y + lo.y) / 2);
    right = new PVector(x + w + 5, (lb.y + lo.y) / 2);
    up = new PVector((lb.x + rb.x) / 2 - 1, y - 5);
    down = new PVector((lb.x + rb.x) / 2 + 1, y + h + 5);

    for (Object wallObject : objectHandler.walls) {
      if (wallObject.objectId == ObjectID.WALL || wallObject.objectId == ObjectID.ROCK || wallObject.objectId == ObjectID.BBLOCK) {
        if (dist(or.x, or.y, wallObject.or.x, wallObject.or.y) < 138) {

          leftRay = new Ray(or, left.x, left.y);
          rightRay = new Ray(or, right.x, right.y);
          upRay = new Ray(or, up.x, up.y);
          downRay = new Ray(or, down.x, down.y);

          float record = 69;

          PVector leftInt = leftRay.getIntersection(wallObject.rb, wallObject.ro);
          PVector rightInt = rightRay.getIntersection(wallObject.lb, wallObject.lo);
          PVector upInt = upRay.getIntersection(wallObject.lo, wallObject.ro);
          PVector downInt = downRay.getIntersection(wallObject.lb, wallObject.rb);

          if (leftInt != null) {
            float d = PVector.dist(this.or, leftInt);
            if (d < record) {
              leftCon = true;
            }
          }
          if (rightInt != null) {
            float d = PVector.dist(this.or, rightInt);
            if (d < record) {
              rightCon = true;
            }
          }
          if (upInt != null) {
            float d = PVector.dist(this.or, upInt);
            if (d < record) {
              upCon = true;
            }
          }
          if (downInt != null) {
            float d = PVector.dist(this.or, downInt);
            if (d < record) {
              downCon = true;
            }
          }
        }
      }
    }
  }

  //Inladen van de texture voor de muur en plaatsing
  public void draw() {
    //stroke(255, 0, 0);
    //line(or.x, or.y, x - 5, (lb.y + lo.y) / 2);
    //stroke(0, 255, 0);
    //line(or.x, or.y, x + w + 5, (lb.y + lo.y) / 2);
    //stroke(0, 0, 255);
    //line(or.x, or.y, (lb.x + rb.x) / 2, y - 5);
    //stroke(255, 255, 0);
    //line(or.x, or.y, (lb.x + rb.x) / 2, y + h + 5);


    if (rightCon && leftCon && downCon && !upCon) {
      image(sprites.getWall(2, 0), x, y);
    }
    if (rightCon && leftCon && !downCon && !upCon) {
      image(sprites.getWall(2, 1), x, y);
    }
    if (rightCon && !leftCon && !downCon && !upCon) {
      image(sprites.getWall(0, 1), x, y);
    }

    if (rightCon && leftCon && downCon && upCon) {
      image(sprites.getWall(0, 3), x, y);
    }
    if (!rightCon && !leftCon && !downCon && !upCon) {
      image(sprites.getWall(1, 1), x, y);
    }

    if (!rightCon && leftCon && downCon && upCon) {
      image(sprites.getWall(1, 2), x, y);
    }
    if (!rightCon && !leftCon && downCon && upCon) {
      image(sprites.getWall(1, 0), x, y);
    }
    if (!rightCon && !leftCon && !downCon && upCon) {
      image(sprites.getWall(0, 0), x, y);
    }

    if (!rightCon && leftCon && !downCon && !upCon) {
      image(sprites.getWall(0, 2), x, y);
    }
    if (!rightCon && !leftCon && downCon && !upCon) {
      image(sprites.getWall(3, 0), x, y);
    }
    if (rightCon && !leftCon && downCon && upCon) {
      image(sprites.getWall(2, 2), x, y);
    }

    if (rightCon && !leftCon && !downCon && upCon) {
      image(sprites.getWall(3, 3), x, y);
    }
    if (!rightCon && leftCon && !downCon && upCon) {
      image(sprites.getWall(3, 2), x, y);
    }
    if (rightCon && leftCon && !downCon && upCon) {
      image(sprites.getWall(3, 1), x, y);
    }

    if (rightCon && !leftCon && downCon && !upCon) {
      image(sprites.getWall(1, 3), x, y);
    }
    if (!rightCon && leftCon && downCon && !upCon) {
      image(sprites.getWall(2, 3), x, y);
    }
  }
}

//-----------------------------Rock top & bottom---------------------------------

//Onder en boven muren
class Rock extends Object {

  Rock(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, ObjectID.ROCK, objectHandler, sprites, soundAssets);
  }

  public void update() {
    selfDestruct();

    lb = new PVector(x, y);
    rb = new PVector(x + w, y);
    ro = new PVector(x + w, y + h);
    lo = new PVector(x, y + h);

    or = new PVector((lb.x + rb.x) / 2, (lb.y + lo.y) / 2);

    left = new PVector(x - 5, (lb.y + lo.y) / 2);
    right = new PVector(x + w + 5, (lb.y + lo.y) / 2);
    up = new PVector((lb.x + rb.x) / 2 - 1, y - 5);
    down = new PVector((lb.x + rb.x) / 2 + 1, y + h + 5);
  }

  public void draw() {
    image(sprites.getRock(), x, y);
  }
}

//-----------------------------Path blocks---------------------------------

class Path extends Object {
  Ray leftRay;
  Ray rightRay;
  Ray upRay;

  int randomOverlayX, randomOverlayY;
  
  boolean leftCon, rightCon, upCon;

  Path(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, ObjectID.PATH, objectHandler, sprites, soundAssets);
    randomOverlayX = (int)random(0, 2);
    randomOverlayY = (int)random(0, 2);
  }

  public void update() {
    if (x < -128) {
      x = 2048;
    }

    leftCon = false;
    rightCon = false;
    upCon = false;

    stroke(0);
    strokeWeight(1);
    fill(255, 0, 0);
    rect(x, y, w, h);

    lb = new PVector(x, y);
    rb = new PVector(x + w, y);
    ro = new PVector(x + w, y + h);
    lo = new PVector(x, y + h);

    or = new PVector((lb.x + rb.x) / 2, (lb.y + lo.y) / 2);

    left = new PVector(x - 5, (lb.y + lo.y) / 2);
    right = new PVector(x + w + 5, (lb.y + lo.y) / 2);
    up = new PVector((lb.x + rb.x) / 2 - 1, y - 5);

    for (Object wallObject : objectHandler.walls) {
      if (wallObject.objectId == ObjectID.WALL || wallObject.objectId == ObjectID.ROCK || wallObject.objectId == ObjectID.BBLOCK) {
        if (dist(or.x, or.y, wallObject.or.x, wallObject.or.y) < 138) {
          leftRay = new Ray(or, left.x, left.y);
          rightRay = new Ray(or, right.x, right.y);
          upRay = new Ray(or, up.x, up.y);

          float record = 69;

          PVector leftInt = leftRay.getIntersection(wallObject.rb, wallObject.ro);
          PVector rightInt = rightRay.getIntersection(wallObject.lb, wallObject.lo);
          PVector upInt = upRay.getIntersection(wallObject.lo, wallObject.ro);
          if (leftInt != null) {
            float d = PVector.dist(this.or, leftInt);
            if (d < record) {
              leftCon = true;
            }
          }
          if (rightInt != null) {
            float d = PVector.dist(this.or, rightInt);
            if (d < record) {
              rightCon = true;
            }
          }
          if (upInt != null) {
            float d = PVector.dist(this.or, upInt);
            if (d < record) {
              upCon = true;
            }
          }
        }
      }
    }
  }

  public void draw() {
    if (upCon && rightCon && leftCon) {
      image(sprites.getBackground(1, 0), x, y);
    }
    if (upCon && !rightCon && !leftCon) {
      image(sprites.getBackground(0, 1), x, y);
    }

    if (upCon && rightCon && !leftCon) {
      image(sprites.getBackground(0, 2), x, y);
    }
    if (upCon && !rightCon && leftCon) {
      image(sprites.getBackground(1, 1), x, y);
    }

    if (!upCon && !rightCon && leftCon) {
      image(sprites.getBackground(2, 0), x, y);
    }
    if (!upCon && rightCon && !leftCon) {
      image(sprites.getBackground(1, 2), x, y);
    } 

    if (!upCon && rightCon && leftCon) {
      image(sprites.getBackground(2, 1), x, y);
    }

    if (!upCon && !rightCon && !leftCon) {
      image(sprites.getBackground(0, 0), x, y);
    }
    
    image(sprites.getBackgroundOverlay(randomOverlayX, randomOverlayY), x, y);

    //stroke(255, 0, 0);
    //line(or.x, or.y, x - 5, (lb.y + lo.y) / 2);
    //stroke(0, 255, 0);
    //line(or.x, or.y, x + w + 5, (lb.y + lo.y) / 2);
    //stroke(0, 0, 255);
    //line(or.x, or.y, (lb.x + rb.x) / 2, y - 5);
    //stroke(255, 255, 0);
    //line(or.x, or.y, (lb.x + rb.x) / 2, y + h + 5);

    //fill(82, 51, 63);
    //rect(x, y, w, h);
  }
}

//-----------------------------Breakable blocks---------------------------------

class BreakableWall extends Entity {
  Ray leftRay;
  Ray rightRay;
  Ray upRay;
  Ray downRay;

  boolean leftCon, rightCon, upCon, downCon;

  BreakableWall(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.objectId = ObjectID.BBLOCK;
  }

  public @Override
    void update() {
    selfDestruct();

    leftCon = false;
    rightCon = false;
    upCon = false;
    downCon = false;

    lb = new PVector(x, y);
    rb = new PVector(x + w, y);
    ro = new PVector(x + w, y + h);
    lo = new PVector(x, y + h);

    or = new PVector((lb.x + rb.x) / 2, (lb.y + lo.y) / 2);

    left = new PVector(x - 5, (lb.y + lo.y) / 2);
    right = new PVector(x + w + 5, (lb.y + lo.y) / 2);
    up = new PVector((lb.x + rb.x) / 2 - 1, y - 5);
    down = new PVector((lb.x + rb.x) / 2 + 1, y + h + 5);

    for (Object wallObject : objectHandler.walls) {
      if (wallObject.objectId == ObjectID.WALL || wallObject.objectId == ObjectID.ROCK || wallObject.objectId == ObjectID.BBLOCK) {
        if (dist(or.x, or.y, wallObject.or.x, wallObject.or.y) < 138) {

          leftRay = new Ray(or, left.x, left.y);
          rightRay = new Ray(or, right.x, right.y);
          upRay = new Ray(or, up.x, up.y);
          downRay = new Ray(or, down.x, down.y);

          float record = 69;

          PVector leftInt = leftRay.getIntersection(wallObject.rb, wallObject.ro);
          PVector rightInt = rightRay.getIntersection(wallObject.lb, wallObject.lo);
          PVector upInt = upRay.getIntersection(wallObject.lo, wallObject.ro);
          PVector downInt = downRay.getIntersection(wallObject.lb, wallObject.rb);

          if (leftInt != null) {
            float d = PVector.dist(this.or, leftInt);
            if (d < record) {
              leftCon = true;
            }
          }
          if (rightInt != null) {
            float d = PVector.dist(this.or, rightInt);
            if (d < record) {
              rightCon = true;
            }
          }
          if (upInt != null) {
            float d = PVector.dist(this.or, upInt);
            if (d < record) {
              upCon = true;
            }
          }
          if (downInt != null) {
            float d = PVector.dist(this.or, downInt);
            if (d < record) {
              downCon = true;
            }
          }
        }
      }
    }

    bombDamage();
  }

  public @Override
    void bombDamage() {
    if (insideExplosion) {
      health -= BOMB_DAMAGE;
      insideExplosion = false;
    }
    if (health <= 0) {
      objectHandler.addItem(x, y, 64, 64);
      objectHandler.removeWall(this);
    }
  }

  public void draw() {
    if (rightCon && leftCon && !upCon && !downCon) {
      image(sprites.getBrokenWall(0, 0), x, y);
    }
    if (!rightCon && !leftCon && upCon && downCon) {
      image(sprites.getBrokenWall(1, 0), x, y);
    }
  }
}

//-----------------------------Breakable items---------------------------------

class BreakableObject extends Entity {

  int randomTexture;
  float randomPosQ, newX, newY;

  BreakableObject(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.entityId = EntityID.BOBJECT;
  }

  public void update() {
    selfDestruct();

    newX = x + randomPosQ;
    newY = y + randomPosQ;

    bombDamage();
  }

  public @Override
    void bombDamage() {
    if (insideExplosion) {
      health -= BOMB_DAMAGE;
      insideExplosion = false;
    }
    if (health <= 0) {
      objectHandler.addItem(newX, newY, 64, 64);
      objectHandler.removeEntity(this);
    }
  }
}

class Corpse extends BreakableObject {

  Corpse(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
  }

  public @Override
    void bombDamage() {
    if (insideExplosion) {
      health -= BOMB_DAMAGE;
      insideExplosion = false;
    }
    if (health <= 0) {
      objectHandler.addItem(x, y, 64, 64);
      objectHandler.removeEntity(this);
    }
  }

  public void draw() {
    fill(255);
    rect(x, y + 24, w, h);
  }
}

class Vases extends BreakableObject {

  Vases(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    randomTexture = (int)random(9);
    randomPosQ = random(1) * 80;

    println(newX, newY);
  }

  public void draw() {
    image(sprites.getObject(0, 0), newX, newY);
  }
}

class Backpack extends BreakableObject {

  Backpack(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    randomTexture = (int)random(9);
    randomPosQ = random(1) * 70;
  }

  public void draw() {
    fill(255);
    rect(newX, newY, w, h);
  }
}
//Code credit Alex Tarnòki, Ole Neuman

class Bomb extends Object {
  SpriteSheetAnim explosionAnim;

  final int fps;

  int bombTimer = EXPLOSION_TIMER;
  int bombOpacity = BOMB_START_OPACITY;
  int startTime;
  int explosionOpacity = EXPLOSION_START_OPACITY;
  int explosionRadius = EXPLOSION_START_RADIUS;

  boolean bombAnimation = false;

  Bomb(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, ObjectID.BOMB, objectHandler, sprites, soundAssets);
    this.bombId = BombID.DYNAMITE;

    fps = 12;
    startTime = millis();
    explosionAnim = new SpriteSheetAnim(sprites.explosion, 0, 12, fps);
    explosionAnim.playOnce();
    explosionAnim.setCenter();
  }

  //Wanneer dynamiet explodeerd kijk hij of er enemy in de blastradius zit en paast dit door naar de enemy class
  //Explosie begint fel en neemt daarna af in opacity, wanneer deze nul is wordt hij verwijdert
  public void update() {
    selfDestruct();

    if (bombExploded()) {
      bombAnimation = true;

      explosionAnim.update(x, y);

      //soundAssets.getBombExploded();
      enemyDetection();

      if (explosionRadius < 400) {
        explosionRadius += 25;
      }
      if (explosionRadius >= 400) {
        explosionOpacity -=6;
        bombOpacity = 0;
      }
    }
  }

  public void draw() {
    if (!bombAnimation) {
      image(sprites.getBombItem(1, 0), x, y);
    }
    if (bombAnimation) {
      explosionAnim.draw();
    }
    if (explosionAnim.index > 11) {
      objectHandler.removeEntity(this);
    }
  }

  //Kijkt of object een enemy is
  public void enemyDetection() {
    for (Object entity : objectHandler.entities) {
      if (!entity.equals(this) && entity.objectId == ObjectID.ENTITY ) {
        if (circleRectangleOverlap(entity.x, entity.y, entity.w, entity.h)) {
          ((Entity)entity).insideExplosion = true;
        }
      } else if (!entity.equals(this) && entity.objectId == ObjectID.PLAYER) {
        if (circleRectangleOverlap(entity.x, entity.y, entity.w, entity.h)) {
          ((Player)entity).insideExplosion = true;
        }
      }        
      for (Object wall : objectHandler.walls) {
        if (!wall.equals(this) && wall.objectId == ObjectID.BBLOCK ) {
          if (circleRectangleOverlap(wall.x, wall.y, wall.w, wall.h)) {
            ((Entity)wall).insideExplosion = true;
          }
        }
      }
    }
  }

  //Kijk of de enemy in de circle zit van de blast radius
  public boolean circleRectangleOverlap(float rectX, float rectY, int rectW, int rectH) {
    //println("bombX = " + x + ", bombY = " + y + ", explosionRadius = " + explosionRadius);
    //println("enemyX = " + rectX + "enemyY = " + rectY);
    float distanceX = abs(x - rectX - rectW / 4);
    float distanceY = abs(y - rectY - rectH / 4);

    if (distanceX > rectW / 2 + explosionRadius/2) return false; 
    if (distanceY > rectH / 2 + explosionRadius/2) return false; 

    if (distanceX <= rectW / 2) return true;  
    if (distanceY <= rectH / 2) return true; 

    float dx = distanceX-rectW / 2;
    float dy = distanceY-rectH / 2;
    return (dx*dx+dy*dy<=((explosionRadius/2)*(explosionRadius/2)));
  }

  //Explosie timer
  public boolean bombExploded() {
    if ( millis() > startTime + bombTimer) {
      return true;
    }
    return false;
  }
}

//-----------------------------C4 bomb---------------------------------

class C4 extends Bomb
{
  boolean bombActivated;

  C4(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.bombId = BombID.CFOUR;
    bombActivated = false;
  }

  public void draw() {
    fill(0, bombOpacity);
    if (bombOpacity == 0) noStroke();
    image(sprites.getBombItem(2, 0), x, y);
    //rect(x, y, w, h);
    fill(235, 109, 30, explosionOpacity);
    noStroke();
    circle(x + w, y + h, explosionRadius);
    stroke(1);
    if (explosionOpacity <= 0) {
      objectHandler.removeEntity(this);
    }
  }

  public void update() {
    selfDestruct();

    if ( bombActivated) {
      enemyDetection();
      if (explosionRadius < 400) {
        explosionRadius += 25;
      }
      if (explosionRadius >= 400) {
        explosionOpacity -=5;
        bombOpacity = 0;
      }
    }
    if (input.xDown())
    {
      bombActivated = true;
    }
  }
}

//-----------------------------Landmine---------------------------------

class Landmine extends Bomb
{
  boolean enemyOverlaps;

  Landmine(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.bombId = BombID.LANDMINE;
    enemyOverlaps = false;
  }

  public void draw() {
    fill(0, bombOpacity);
    if (bombOpacity == 0) noStroke();
    image(sprites.getBombItem(0, 0), x, y);
    //rect(x, y, w, h);
    fill(235, 109, 30, explosionOpacity);
    noStroke();
    circle(x + w, y + h, explosionRadius);
    stroke(1);
    if (explosionOpacity <= 0) {
      objectHandler.removeEntity(this);
    }
  }
  public void update() {
    selfDestruct();

    if (enemyOverlaps == false)
    {
      enemyOverlapsLandmine();
    }
    if (enemyOverlaps) {
      enemyDetection();
      if (explosionRadius < 400) {
        explosionRadius += 25;
      }
      if (explosionRadius >= 400) {
        explosionOpacity -=5;
        bombOpacity = 0;
      }
    }
  }

  public void enemyOverlapsLandmine() {
    for (Object entity : objectHandler.entities) {
      if ( !entity.equals(this) && entity.objectId == ObjectID.ENTITY ) {
        if (circleRectangleOverlap(entity.x, entity.y, entity.w, entity.h)) {
          enemyOverlaps = true;
        }
      }
    }
  }

  public boolean rectRect(float r2x, float r2y, float r2w, float r2h) {

    // are the sides of one rectangle touching the other?

    if (x + w >= r2x &&    // r1 right edge past r2 left
      x <= r2x + r2w &&    // r1 left edge past r2 right
      y + h >= r2y &&    // r1 top edge past r2 bottom
      y <= r2y + r2h) {    // r1 bottom edge past r2 top
      return true;
    }
    return false;
  }
}

//-----------------------------Spiderbombs---------------------------------

//class voor de Bomb die de ExplosiveSpider maakt
//code credit Alex Tarnoki, Ole Neuman, Ruben Verheul
class SpiderBomb extends Bomb {

  int bombTimer = EXPLOSION_TIMER;
  int bombOpacity = BOMB_START_OPACITY;
  int startTime;
  int explosionOpacity = EXPLOSION_START_OPACITY;
  int explosionRadius = EXPLOSION_START_RADIUS;


  SpiderBomb(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.bombId = BombID.SPIDER_BOMB;
    startTime = millis();
  }

  //Wanneer dynamiet explodeerd kijk hij of er enemy in de blastradius zit en paast dit door naar de enemy class
  //Explosie begint fel en neemt daarna af in opacity, wanneer deze nul is wordt hij verwijdert
  public void update() {
    selfDestruct();

    if ( bombExploded()) {
      playerDetection();
      if (explosionRadius < 400) {
        explosionRadius += 25;
      }
      if (explosionRadius >= 400) {
        explosionOpacity -=5;
        bombOpacity = 0;
      }
    }
  }

  public void draw() {
    fill(0, bombOpacity);
    if (bombOpacity == 0) noStroke();
    rect(x, y, w, h);
    fill(235, 109, 30, explosionOpacity);
    noStroke();
    circle(x + w, y + h, explosionRadius);
    stroke(1);
    if (explosionOpacity <= 0) {
      objectHandler.removeEntity(this);
    }
  }

  //Kijkt of object een player is
  public void playerDetection() {
    for (Object player : objectHandler.entities) {
      if ( !player.equals(this) && player.objectId == ObjectID.PLAYER ) {
        if (circleRectangleOverlap(player.x, player.y, player.w, player.h)) {
          ((Player)player).insideExplosion = true;
        }
      }
    }
  }

  //Kijk of de enemy in de circle zit van de blast radius
  public boolean circleRectangleOverlap(float rectX, float rectY, int rectW, int rectH) {
    //println("bombX = " + x + ", bombY = " + y + ", explosionRadius = " + explosionRadius);
    //println("enemyX = " + rectX + "enemyY = " + rectY);
    float distanceX = abs(x - rectX - rectW / 4);
    float distanceY = abs(y - rectY - rectH / 4);

    if (distanceX > rectW / 2 + explosionRadius/2) return false; 
    if (distanceY > rectH / 2 + explosionRadius/2) return false; 

    if (distanceX <= rectW / 2) return true;  
    if (distanceY <= rectH / 2) return true; 

    float dx = distanceX-rectW / 2;
    float dy = distanceY-rectH / 2;
    return (dx*dx+dy*dy<=((explosionRadius/2)*(explosionRadius/2)));
  }

  //Explosie timer
  public boolean bombExploded() {
    if ( millis() > startTime + bombTimer) return true;
    return false;
  }
}

class SpiderQueen extends Entity {

  SpiderQueen(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.entityId = EntityID.SPIDER_BOSS;
  }

  public @Override
  void update() {
   selfDestruct();
   super.update();
  }

  public void draw() {
    fill(0xffe823e5);
    rect(x, y, w, h);
  }
}

class MovingWall extends Entity {

  MovingWall(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.entityId = EntityID.WALL_BOSS;
  }

  public void update() {
    selfDestruct();
  }
  
  public void draw() {
    fill(0xff3ac93f);
    rect(x, y, w, h);
  }
}
//Code credit Winand Metz

//Game
final float MAP_SCROLL_SPEED = 1;
final float MAP_OFFSET = 0;
final int LEVEL_AMOUNT = 3;
final int FPS = 6;

//!NIET VERANDEREN!
final int TILE_SIZE = 128;
final int OBJECT_Y_OFFSET = 100;

//Graphics
final int FRAMERATE = 60;
final int FLOOR_SHADOW_STRENGTH = 230; //Normaliter ligt de waarde van deze en ENVIROMENT_SHADOW_STRENGHT dicht bij elkaar
final int ENVIROMENT_SHADOW_STRENGHT = 230;
final int RAY_DISTANCE = 500;

//Main Menu
final int MENU_BACKGROUND_COLOUR = 0xff12173B;
final int BOX_BASIC_OUTER_COLOUR = 0xffC51FBD;
final int BOX_BASIC_INNER_COLOUR = 0xff271FC5;
final int BOX_HIGHLIGHTED_OUTER_COLOUR = 0xffE4BB17;
final int BOX_HIGHLIGHTED_INNER_COLOUR = 0xffED270F;
final int BOX_TEXT_COLOUR = 0xff000000;
final int MENUBOX_AMOUNT = 2;
final int MENU_MOVE_COOLDOWN = 10;

//HighScores
final int TIME_SCORE = 10;
final int TIME_SCORE_TIMER = 1;  //in sec

//Coin
final int COIN_SCORE = 100;

//Player
final int PLAYER_X_SPAWN = 256;
final int PLAYER_Y_SPAWN = 476;
final int PLAYER_HEALTH = 12;
final int PLAYER_SPEED = 4;
final int PLAYER_SHIELD = 0;
//!NIET VERANDEREN!
final int PLAYER_SIZE = TILE_SIZE / 2;

//Bombs
final int EXPLOSION_TIMER = 1200;
final int BOMB_START_OPACITY = 255;
final int EXPLOSION_START_OPACITY = 255;
final int EXPLOSION_START_RADIUS = 0;
final int BOMB_DAMAGE = 3;
final int BOMB_SIZE = 32;
final int BOMB_COOLDOWN_TIME = 60;

//Entities
final int PLAYER_DETECTION_DISTANCE = 400;
final int ENTITY_SIZE_DIVIDER = 2;
final float GHOST_SPAWN_CHANCE = 30;
final float POLTERGEIST_SPAWN_CHANCE = 7;
final float SPIDER_SPAWN_CHANCE = 50;
final float EXPLOSIVE_SPIDER_SPAWN_CHANCE = 10;
final float MUMMY_SPAWN_CHANCE = 40;
final float STONED_MUMMY_SPAWN_CHANCE = 13;

//Ghost
final int GHOST_HEALTH = 3;
final int GHOST_ATTACK = 3;
final int GHOST_ROAMING = 3000;
final int GHOST_MOVEMENT_SPEED = 2;

//Poltergeist
final int POLTERGEIST_HEALTH = 4;
final int POLTERGEIST_ATTACK = 3;
final int POLTERGEIST_ROAMING = 3000;
final int POLTERGEIST_MOVEMENT_SPEED = 2;

//Mummy
final int MUMMY_HEALTH = 8;
final int MUMMY_ATTACK = 4;
final int MUMMY_ROAMING = 2000;
final int MUMMY_MOVEMENT_SPEED = 1;

//SMummy
final int SMUMMY_HEALTH = 8;
final int SMUMMY_ATTACK = 4;
final int SMUMMY_ROAMING = 2000;
final int SMUMMY_MOVEMENT_SPEED = 1;
final int SMUMMY_SHIELD = 2;

//Spider
final int SPIDER_HEALTH = 1;
final int SPIDER_ATTACK = 1;
final int SPIDER_ROAMING = 1000;
final int SPIDER_MOVEMENT_SPEED = 3;

//ExplosiveSpider
final int EXPLOSIVE_SPIDER_HEALTH = 1;
final int EXPLOSIVE_SPIDER_ATTACK = 1;
final int EXPLOSIVE_SPIDER_ROAMING = 1000;
final int EXPLOSIVE_SPIDER_MOVEMENT_SPEED = 3;

//Items
final float BOOTS_DROP_CHANCE = 5;
final float SPARKLER_DROP_CHANCE = 4;
final float BLUE_POTION_DROP_CHANCE = 2;
final float SHIELD_DROP_CHANCE = 10;
final float CLOAK_DROP_CHANCE = 3;
final float HEART_DROP_CHANCE = 13;
final float COIN_DROP_CHANCE = 60;

//Power ups
final int SPEED_BONUS_TIME = 4000;
final int UNDEFEATBALE_BONUS_TIME = 2000;
final int CLOACK_BONUS_TIME = 3000;
final int BOMB_BONUS_TIME = 2000;
final int SHIELD_BONUS = 2;
final int SPEED_BONUS = 2;
//Code credit Jordy Post, Winand Metz, Ruben Verheul

class Ghost extends Entity {

  Ghost(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.entityId = EntityID.GHOST;
    savedTime = millis();
    health = GHOST_HEALTH;
    attack = GHOST_ATTACK;
    roamingTimer = GHOST_ROAMING;
    velX = GHOST_MOVEMENT_SPEED;
    velY = GHOST_MOVEMENT_SPEED;
  }

  public @Override
    void update() {
    selfDestruct();
    bombDamage();
    movement();
    attack();

    x = x + speedX;
    y = y + speedY;

    if (rockCollisionDetection()) {
      x = oldX - game.mapHandler.mapScrollSpeed;
      y = oldY;
    }

    oldX = x;
    oldY = y;
  }

  public void draw() {
    image(sprites.getEntity(0, 0), x, y);
  }
}

//-----------------------------Special ghost---------------------------------

//Code credit Ruben Verheul
class Poltergeist extends Entity {


  Poltergeist(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.entityId = EntityID.POLTERGEIST;
    savedTime = millis();
    health = POLTERGEIST_HEALTH;
    attack = POLTERGEIST_ATTACK;
    roamingTimer = POLTERGEIST_ROAMING;
    velX = POLTERGEIST_MOVEMENT_SPEED;
    velY = POLTERGEIST_MOVEMENT_SPEED;
  }

  public @Override
    void update() {
    selfDestruct();
    bombDamage();
    movement();
    attack();

    x = x + speedX;
    y = y + speedY;

    if (rockCollisionDetection()) {
      x = oldX - game.mapHandler.mapScrollSpeed;
      y = oldY;
    }

    oldX = x;
    oldY = y;
  }

  public void attack() {
    ArrayList<Object> entityObjects = objectHandler.entities;
    Object playerEntity = entityObjects.get(0);
    if (intersection(playerEntity)) {
      ((Player)playerEntity).attackDamage = attack;
      ((Player)playerEntity).gettingAttacked = true;
      cloakBonus = false;
      undefeatabaleBonus = false;
      speedBonus = false;
      sparklerBonus = false;
      println("slash");
    }
  }

  public void draw() {
    image(sprites.getEntity(0, 0), x, y);
  }
}

//-----------------------------Mummy---------------------------------

class Mummy extends Entity {

  Mummy(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.entityId = EntityID.MUMMY;
    savedTime = millis();

    health = MUMMY_HEALTH;
    attack = MUMMY_ATTACK;
    roamingTimer = MUMMY_ROAMING;
    velX = MUMMY_MOVEMENT_SPEED;
    velY = MUMMY_MOVEMENT_SPEED;
  }

  public @Override
    void update() {
    super.update();
  }

  public void draw() {
    image(sprites.getEntity(1, 0), x, y);
  }
}

//-----------------------------Special mummy---------------------------------

//Code credit Jordy Post
class SMummy extends Mummy {

  int shield;

  SMummy(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.entityId = EntityID.SMUMMY;
    savedTime = millis();
    health = SMUMMY_HEALTH;
    shield = SMUMMY_SHIELD;
    attack = SMUMMY_ATTACK;
  }

  public @Override
    void update() {
    super.update();
  }

  //Method voor destruction
  public @Override
    void bombDamage() {
    if (insideExplosion) {
      println(insideExplosion);
      if (shield <= 0) {
        health -= BOMB_DAMAGE;
        insideExplosion = false;
      } else {
        shield -= BOMB_DAMAGE;
        insideExplosion = false;
      }
    }
    if (health <= 0) {
      objectHandler.removeEntity(this);
    }
  }

  public void draw() {
    image(sprites.getEntity(1, 0), x, y);
  }
}

//-----------------------------Spider---------------------------------

class Spider extends Entity {

  Spider(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.entityId = EntityID.SPIDER;
    savedTime = millis();
    health = SPIDER_HEALTH;
    attack = SPIDER_ATTACK;
    roamingTimer = SPIDER_ROAMING;
    velX = SPIDER_MOVEMENT_SPEED ;
    velY = SPIDER_MOVEMENT_SPEED ;
  }

  public @Override
    void update() {
    super.update();
  }

  public void draw() {
    image(sprites.getEntity(0, 1), x, y);
  }
}

//-----------------------------Special spider---------------------------------

class ExplosiveSpider extends Entity {



  ExplosiveSpider(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.entityId = EntityID.EXPLOSIVE_SPIDER;
    savedTime = millis();
    health = EXPLOSIVE_SPIDER_HEALTH;
    attack = EXPLOSIVE_SPIDER_ATTACK;
    roamingTimer = EXPLOSIVE_SPIDER_ROAMING;
    velX = EXPLOSIVE_SPIDER_MOVEMENT_SPEED;
    velY = EXPLOSIVE_SPIDER_MOVEMENT_SPEED;
  }

  public @Override
    void update() {
    super.update();
  }

  public void draw() {
    image(sprites.getEntity(0, 1), x, y);
  }
}
//Code credit Jordy Post, Winand Metz, Ruben Verheul, Ole Neuman 

class Entity extends Object {

  int health;
  int attack;
  int roamingTimer;
  int savedTime;
  int speedX;
  int speedY;
  int velX;
  int velY;
  float oldX, oldY;

  boolean insideExplosion;
  boolean takenDamage;
  boolean touching;

  Entity(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, ObjectID.ENTITY, objectHandler, sprites, soundAssets);
    savedTime = millis();
    health = 1;
    attack = 1;
    roamingTimer = 1;
    insideExplosion = false;
    takenDamage = false;
    touching = false;
  }

  //Nieuw collision system waarbij hij terug wordt gezet naar de oude positie
  public void update() {
    selfDestruct();
    bombDamage();
    movement();
    attack();

    x = x + speedX;
    y = y + speedY;

    if (wallCollisionDetection()) {
      x = oldX - game.mapHandler.mapScrollSpeed;
      y = oldY;
    }

    oldX = x;
    oldY = y;
  }

  public void movement() {
    //Timer voor basic willekeurig ronddwalen over speelveld elke twe seconden gaat hij andere kant op
    //Zodra hij binnen 400 pixels van de player komt gaat hij achter de player aan
    //Moet nog in dat hij om muren heen navigeert ipv tegenaanstoot en stil staat
    int passedTime = millis() - savedTime;
    if (dist(getPlayerX(), getPlayerY(), x, y) < 400) {
      hunt();
    } else {
      if (passedTime > roamingTimer) {
        speedX = velX * randomOnes();
        speedY = velY * randomOnes();
        savedTime= millis();
      }
    }
  }

  public void hunt() {
    if (cloakBonus == false) {
      if (getPlayerX() > x && getPlayerY() > y) {
        speedX = velX;
        speedY = velY;
      } 
      if (getPlayerX() < x && getPlayerY() < y) {
        speedX = -velX;
        speedY = -velY;
      } 
      if (getPlayerX() > x && getPlayerY() < y) {
        speedX = velX;
        speedY = -velY;
      } 
      if (getPlayerX() < x && getPlayerY() > y) {
        speedX = -velX;
        speedY = velY;
      }
    }
  }

  public void bombDamage() {
    if (insideExplosion && !takenDamage) {
      soundAssets.getEnemyHit();
      health -= BOMB_DAMAGE;
      takenDamage = true;
    }
    if (health <= 0) {
      if (entityId == EntityID.EXPLOSIVE_SPIDER) {
        objectHandler.addSpiderBomb(x, y, BOMB_SIZE, BOMB_SIZE);
      }
      if (entityId == EntityID.SPIDER_BOSS || entityId == EntityID.WALL_BOSS){
        game.mapHandler.mapScrolling = true; 
        game.mapHandler.fastforwardWidth = 0.75f;
      }
      objectHandler.removeEntity(this);
    }
    if (!insideExplosion && takenDamage) {
      takenDamage = false;
    }
    insideExplosion = false;
  }

  public void attack() {
    ArrayList<Object> entityObjects = objectHandler.entities;
    Object playerEntity = entityObjects.get(0);
    if (intersection(playerEntity)) {
      ((Player)playerEntity).attackDamage = attack;
      ((Player)playerEntity).gettingAttacked = true;
      println("slash");
    }
  }

  //Method voor basic volgen van de player
  //Moet nog in dat hij om muren heen navigeert (of je niet ziet achter de muren?)
  //credits Jordy, Ruben

  public void draw() {
    fill(20);
    rect(x, y, w, h);
  }
}

class CollisionFix extends Object {

  CollisionFix(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, ObjectID.FIX, objectHandler, sprites, soundAssets);
  }

  public @Override
    void moveMap() {
  }

  public void update() {
  }

  public void draw() {
    rect(x, y, w, h);
  }
}
//Code credit Winand Metz

//Alles game gerelateerd
class Game {
  ObjectHandler objectHandler;
  MapHandler mapHandler;
  TextureAssets textureLoader;
  Highscore highscore;
  GraphicsEngine graphicsEngine;
  UserInterface userInterface;
  Background background;
  SoundAssets soundLoader;

  final int width, height;

  //Inladen van alle assets voor de game en level creation dmv inladen van een png map, op basis van pixels plaatsing van objecten
  //TileSize is grote van de blokken in het plaatsingsgrid (tegelgrote)
  Game(int tileSize, int width, int height, TextureAssets textureAssets, SoundAssets soundAssets) {
    this.width =  width;
    this.height = height;
    textureLoader = textureAssets;
    soundLoader = soundAssets;
    highscore = new Highscore();
    objectHandler = new ObjectHandler(this.textureLoader, this.soundLoader);
    objectHandler.addPlayer(this.highscore);
    objectHandler.addFix();
    background = new Background(textureLoader);
    mapHandler = new MapHandler(tileSize);
    graphicsEngine = new GraphicsEngine();
    userInterface = new UserInterface(this.textureLoader, this.highscore, this.objectHandler);
  }

  //Oproepen van objecten in de game zodat ze worden getekend
  public void update() {
    mapHandler.update();
    background.update();
    objectHandler.update();
    highscore.update();
    graphicsEngine.update();
    userInterface.update();

    //stuurt je naar het main menu als je op escape drukt
    if (input.escapeDown()) {
      toMainMenu();
    }
  }

  public void draw() {
    background(41, 29, 43);
    background.draw();
    graphicsEngine.drawFloorLighting();
    objectHandler.draw();
    graphicsEngine.draw();
    userInterface.draw();
  }

  //-----------------------------Graphics engine---------------------------------

  class GraphicsEngine {

    Emitter emitterPlayer;

    PGraphics floorLightMap;
    PGraphics floorTorchLight;
    PGraphics floorShadowMask;
    PGraphics floorInvShadowMask;
    PGraphics floorInvShadowMap;
    PGraphics floorShadowMap;

    PGraphics wallLightMask;
    PGraphics wallLightMap;

    PImage torchLight;
    PImage invTorchLight;

    PVector playerPos;

    GraphicsEngine() {
      emitterPlayer = new Emitter(objectHandler);
      playerPos = new PVector();
      torchLight = loadImage("data/lightmaps/torch.png");
      invTorchLight = loadImage("data/lightmaps/inv_torch.png");
      floorInvShadowMap = createGraphics(1920, 1080, P2D);
      floorShadowMap = createGraphics(1920, 1080, P2D);
      floorLightMap = createGraphics(1920, 1080, P2D);
      floorTorchLight = createGraphics(1920, 1080, P2D);
      floorShadowMask = createGraphics(1920, 1080, P2D);
      floorInvShadowMask = createGraphics(1920, 1080, P2D);
      wallLightMask = createGraphics(1920, 1080, P2D);
      wallLightMap = createGraphics(1920, 1080, P2D);
    }

    public void update() {
      ArrayList<Object> entityObjects = objectHandler.entities;
      Object playerEntity = entityObjects.get(0);
      playerPos.set(playerEntity.x, playerEntity.y);
      emitterPlayer.update(playerPos.x, playerPos.y);
      emitterPlayer.cast(objectHandler.walls);
    }

    //Tekent de bewegende shaduwen op de vloer
    public void drawFloorLighting() {
      //Bepaald hoe het licht op de vloer valt op basis van een variant van path tracing
      floorLightMap.beginDraw();
      floorLightMap.clear();
      floorLightMap.background(0);
      floorLightMap.shape(emitterPlayer.getShape(255));
      floorLightMap.endDraw();

      //Bepaald de grote van het fakkel licht van de player dmv een png
      floorTorchLight.beginDraw();
      floorTorchLight.clear();
      floorTorchLight.background(0);
      floorTorchLight.imageMode(CENTER);
      floorTorchLight.image(torchLight, playerPos.x, playerPos.y);
      floorTorchLight.endDraw();

      //Zorgt ervoor dat path tracing alleen voordoet binnen het fakkel licht
      floorLightMap.mask(floorTorchLight);

      //Maakt een mask van de floorLightMap die inverted is, oftwel de inverted shadow mask
      floorInvShadowMask.beginDraw();
      floorInvShadowMask.clear();
      floorInvShadowMask.background(0);
      floorInvShadowMask.image(floorLightMap, 0, 0);
      floorInvShadowMask.endDraw();

      //Basis layer voor de inverted shadow map
      floorInvShadowMap.beginDraw();
      floorInvShadowMap.clear();
      floorInvShadowMap.background(0);
      floorInvShadowMap.endDraw();

      //Zet de inverted shadow mask om in de inverted shadow map
      floorInvShadowMap.mask(floorInvShadowMask);

      //Tekend de shadow mask, dit bepaald waar de schaduwen komen en hoe sterk ze zijn
      floorShadowMask.beginDraw();
      floorShadowMask.clear();
      floorShadowMask.background(FLOOR_SHADOW_STRENGTH);
      floorShadowMask.image(floorInvShadowMap, 0, 0);
      floorShadowMask.endDraw();

      //Tekend de shadow map, dit is wat uiteindelijk te zien is op het scherm
      floorShadowMap.beginDraw();
      floorShadowMap.clear();
      floorShadowMap.background(0);
      floorShadowMap.endDraw();

      //Zet de shadow mask om in de shadow map die geprojecteerd wordt
      floorShadowMap.mask(floorShadowMask);

      //Aantal check functies
      //image(lightMap, 0, 0);
      //image(lightMapOutput, 0, 0);
      //image(shadowMask, 0, 0);
      //image(shadowMap, 0, 0);
      //image(lightMask, 0, 0);
      image(floorShadowMap, 0, 0);
    }

    public void draw() {
      //Dit is de light mask voor de muren en entities, laad de grote van het fakkel licht en de sterkte van de schaduwen in en zet dit om in een mask
      wallLightMask.beginDraw();
      wallLightMask.clear();
      wallLightMask.background(ENVIROMENT_SHADOW_STRENGHT);
      wallLightMask.imageMode(CENTER);
      wallLightMask.image(invTorchLight, playerPos.x, playerPos.y);
      wallLightMask.endDraw();

      //De uiteindelijke light map die te zien is op het scherm
      wallLightMap.beginDraw();
      wallLightMap.clear();
      wallLightMap.background(0);
      wallLightMap.endDraw();

      //Zet de mask om in een light map
      wallLightMap.mask(wallLightMask);

      //Check functie
      //image(wallLightMap, 0, 0);
      image(wallLightMap, 0, 0);
    }
  }

  class Background {
    //Path path;

    Object[] backgrounds = new Object[170];

    float x, y;
    int cols = 17;
    int rows = 10;
    int amount = 170;

    Background(TextureAssets sprites) {
      int k = 0;
      for (int i = 0; i < cols; i++) {
        for (int j = 0; j < rows; j++) {
          backgrounds[k] = new Path(i * 128, j * 128 - OBJECT_Y_OFFSET, 128, 128, objectHandler, sprites, soundAssets);

          k++;
        }
      }
    }

    public void update() {
      for (int i = 0; i < backgrounds.length; i++) {
        backgrounds[i].moveMap();
        backgrounds[i].update();
      }
    }

    public void draw() {
      for (int i = 0; i < backgrounds.length; i++) {
        backgrounds[i].draw();
      }
    }
  }
}

//-----------------------------Highscore---------------------------------

//code credit Jordy
class Highscore {
  int score, timeScore, timer;
  Timer scoreTimer;
  boolean scoreAdded;
  //MySQLConnection myConnection;
  // Table highscores;
  int userId;
  String addScore, selectScore, user;
  int highscoreTableLimit;

  Highscore() {
    //myConnection = new MySQLConnection("verheur6", "od93cCRbyqVu5R1M", "jdbc:mysql://oege.ie.hva.nl/zverheur6");
    //highscores = myConnection.getTable("Highscore");
    score = 0; 
    timeScore = TIME_SCORE;
    timer = FRAMERATE * TIME_SCORE_TIMER;
    scoreTimer = new Timer();
    scoreAdded = false;
    queries();
  }

  //iedere sec komt er score bij
  public void update() {
    switch(gameState) {
    case 1:
      if (scoreTimer.startTimer(timer)) {
        score += timeScore;
      }
      break;
    case 2:
      //als gameState gameover is en de highscores nog niet geupdate zijn worden de scores geupdate
      if (scoreAdded == false) {
        updateHighscores();
      }
      break;
    }
  }

  //update de highscorelist
  public void updateHighscores() {
    //zet de highscore in de tabel
    //myConnection.updateQuery(addScore);
    //zodat je altijd de meest up to date highscore laat zien
    //highscores = myConnection.runQuery(selectScore);
    scoreAdded = true;
  }

  //als je buiten deze class score wilt toevoegen
  public void addScore(int amount) {
    score += amount;
  }

  //temp als je de highscores wilt printen
  //void printHighscore(int limit) {
  //  highscoreTableLimit = limit;

  //  for (int i = 0; i < highscores.getRowCount(); i++) {
  //    TableRow row = highscores.getRow(i);
  //    for (int j = 0; j < row.getColumnCount(); j++) {
  //      text(row.getString(j), width / 2 -150 + 150 * j, 250 + 50 * i);
  //    }
  //  }
  //}

  public void queries() {
    addScore = "INSERT INTO `Highscore`(`name`, `highscore`) VALUES ("+ user + "," + score + ")";
    selectScore = "SELECT User_id, score FROM Highscore ORDER BY `score` DESC LIMIT " + highscoreTableLimit;
  }
}
class Item extends Object {

  Item(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, ObjectID.ITEM, objectHandler, sprites, soundAssets);
  }

  public void update() {
    selfDestruct();
  }

  public void draw() {
  }
}

class Boots extends Item {

  Boots(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.itemId = ItemID.BOOTS;
  }

  public void draw() {
    image(sprites.getBombItem(4, 0), x, y);
  }
}

class Sparkler extends Item {

  Sparkler(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.itemId = ItemID.SPARKLER;
  }

  public void draw() {
    image(sprites.getBombItem(7, 0), x, y);
  }
}

class BluePotion extends Item {

  BluePotion(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.itemId = ItemID.BPOTION;
  }

  public void draw() {
    image(sprites.getBombItem(3, 0), x, y);
  }
}

class Shield extends Item {

  Shield(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.itemId = ItemID.SHIELD;
  }

  public void draw() {
    image(sprites.getBombItem(6, 0), x, y);
  }
}

class Cloak extends Item {

  Cloak(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.itemId = ItemID.CLOAK;
  }

  public void draw() {
    image(sprites.getBombItem(5, 0), x, y);
  }
}

class Heart extends Item {

  Heart(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.itemId = ItemID.HEART;
  }

  public void draw() {
    image(sprites.getBombItem(0, 2), x, y);
  }
}

class Coin extends Item {
  SpriteSheetAnim coinSprite;

  final int fps;

  Coin(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.itemId = ItemID.COIN;
    
        fps = 6;
    
    coinSprite = new SpriteSheetAnim(sprites.itemsBombsUI, 1, 4, fps);
  }

  public void update() {
    super.update();
    coinSprite.update(x, y);
  }

  public void draw() {
    coinSprite.draw();
    //image(sprites.getBombItem(0, 1), x, y);
  }
}

/* Vanuit hier kun je methods gebruiken die geschreven zijn voor het project en op meerdere manieren gebruikt kunnen worden.
 Als je iets toevoegd, zet je credit erbij en een uitleg
 */

//Code credit Ole Neuman
class InputHandler {

  //checks if the leftArrow key is held down, and returns true if it is
  public boolean leftDown() {
    if (keysPressed[37]) return true;
    return false;
  }

  //checks if the rightArrow key is held down, and returns true if it is
  public boolean rightDown() {
    if (keysPressed[39]) return true;
    return false;
  }

  //checks if the upArrow key is held down, and returns true if it is
  public boolean upDown() {
    if (keysPressed[38]) return true;
    return false;
  }

  //checks if the downArrow key is held down, and returns true if it is
  public boolean downDown() {
    if (keysPressed[40]) return true;
    return false;
  }

  //checks if the A is held down, and returns true if it is
  public boolean aDown() {
    if (keysPressed[65]) return true;
    return false;
  }

  //checks if the Z key is held down, and returns true if it is
  public boolean zDown() {
    if (keysPressed[90]) return true;
    return false;
  }

  //checks if the S key is held down, and returns true if it is
  public boolean sDown() {
    if (keysPressed[83]) return true;
    return false;
  }

  //checks if the X key is held down, and returns true if it is
  public boolean xDown() {
    if (keysPressed[88]) return true;
    return false;
  }

  //checks if the ESCAPE key is held down, and returns true if it is
  public boolean escapeDown() {
    return escapePressed;
  }
}

/*Code credit Winand
 Random getal van -1 tot 1*/
public int randomOnes() {
  return (int) random(3) - 1;
}

class Timer {

  int startTime;
  boolean start = true;

  Timer() {
  }

  public boolean startTimer(int countDownTime) {
    int time = millis();
    if (start) {
      startTime = millis();
      start = false;
    }
    int passedTime = time - startTime;
    if (passedTime > countDownTime) {
      startTime = 0;
      time = 0;
      start = true;
      return true;
    }
    return false;
  }
}

class Ray {

  PVector pos, dir;

  Ray(PVector pos, float dirX, float dirY) {
    this.pos = pos;
    dir = new PVector(dirX, dirY);
  }

  //Method die checkt of de ray een andere lijn snijd, input is beginpunt en eindpunt van een een lijn
  //Orginele bron, afgeleid van: https://ncase.me/sight-and-light/
  public PVector getIntersection(PVector wall_a, PVector wall_b) {
    //Ray in parametric: Point + Delta * T1
    float r_px = pos.x;
    float r_py = pos.y;
    float r_dx = dir.x - pos.x;
    float r_dy = dir.y - pos.y;

    //Wall in parametric: Point + Delta * T2
    float s_px = wall_a.x;
    float s_py = wall_a.y;
    float s_dx = wall_b.x - wall_a.x;
    float s_dy = wall_b.y - wall_a.y;

    //Check if they are parrellel, if not, return null
    double r_mag = Math.sqrt(r_dx*r_dx+r_dy*r_dy);
    double s_mag = Math.sqrt(s_dx*s_dx+s_dy*s_dy);
    if (r_dx / r_mag == s_dx / s_mag && r_dy / r_mag == s_dy / s_mag) {
      return null;
    }

    //Check if the ray intersects the wall, T2 & T1 are the line's gradients (Slopes) 
    float T2 = (r_dx * (s_py - r_py) + r_dy * (r_px - s_px)) / (s_dx * r_dy - s_dy * r_dx);
    float T1 = (s_px + s_dx * T2 - r_px) / r_dx;

    //Must be within the parametic whatevers for ray/wall
    if (T1 < 0) { 
      return null;
    }
    if (T2 < 0 || T2 > 1) {
      return null;
    } else {
      // Return the point of intersection
      PVector pt = new PVector();
      pt.x = r_px + r_dx * T1;
      pt.y = r_py + r_dy * T1;
      //pt.z = T1;

      return pt;
    }
  }
}

//Functie voor het inladen van de verschillende textures in een array
public PImage[][] loadSprites(String path, int tileSize) {
  PImage spriteBlock = loadImage(path);
  PImage[][] sprites = new PImage[spriteBlock.width / tileSize][spriteBlock.height / tileSize];
  for (int x = 0; x < spriteBlock.width / tileSize; x ++) {
    for (int y = 0; y < spriteBlock.height / tileSize; y ++) {
      sprites[x][y] = spriteBlock.get(tileSize * x, tileSize * y, tileSize, tileSize);
    }
  }
  return sprites;
}
//Code credit Winand Metz & Ole Neuman
//Class for moving shadow emitter
class Emitter {

  ObjectHandler objectHandler;

  ArrayList<Ray> rays = new ArrayList<Ray>(); 
  ArrayList<PVector> lightVertices = new ArrayList<PVector>();
  ArrayList<PVector> sortedLightVertices = new ArrayList<PVector>();

  PVector pos;

  PShape lightPoly;

  Emitter(ObjectHandler objectHandler) {
    this.objectHandler = objectHandler;
    this.pos = new PVector(width / 2, height / 2);
  }

  public void update(float x, float y) {
    //Bepaald de plek van de emitter
    this.pos.set(x + 10, y + 20);
    /*Zoekt van de Wall en Rock objecten alle hoekpunten op
     Schiet hier een ray naar toe met elk twee extra rays die net zijonder en zijboven zitten van de orginele ray
     Dit helpt met de vloeiendheid wanneer de emitter beweegt en de schaduwen van plek veranderen*/
    for (Object object : objectHandler.walls) {
      if (object.objectId == ObjectID.WALL || object.objectId == ObjectID.ROCK || object.objectId == ObjectID.BBLOCK) {
        if (dist(pos.x, pos.y, object.x, object.y) < RAY_DISTANCE) { //checkt alleen rays voor objecten binnen RAY_DISTANCE pixels van de emitter
          rays.add(new Ray(pos, object.lb.x, object.lb.y));
          rays.add(new Ray(pos, object.rb.x, object.rb.y));
          rays.add(new Ray(pos, object.ro.x, object.ro.y));
          rays.add(new Ray(pos, object.lo.x, object.lo.y));

          rays.add(new Ray(pos, object.lb.x + 0.001f, object.lb.y + 0.001f));
          rays.add(new Ray(pos, object.rb.x + 0.001f, object.rb.y + 0.001f));
          rays.add(new Ray(pos, object.ro.x + 0.001f, object.ro.y + 0.001f));
          rays.add(new Ray(pos, object.lo.x + 0.001f, object.lo.y + 0.001f));

          rays.add(new Ray(pos, object.lb.x - 0.001f, object.lb.y - 0.001f));
          rays.add(new Ray(pos, object.rb.x - 0.001f, object.rb.y - 0.001f));
          rays.add(new Ray(pos, object.ro.x - 0.001f, object.ro.y - 0.001f));
          rays.add(new Ray(pos, object.lo.x - 0.001f, object.lo.y - 0.001f));
        }
      }
    }
  }

  //Method voor bepalen van waar de rays een ander object doorkruizen
  public void cast(ArrayList<Object> entries) {
    for (Ray ray : rays) {
      PVector closest = null;
      float record = width; //Voor optimization redenen staat deze op width, bepaald hoe ver de ray max mag komen
      for (Object object : entries) {
        if (object.objectId == ObjectID.WALL || object.objectId == ObjectID.ROCK || object.objectId == ObjectID.BBLOCK) { //Safe wall dat hij alleen de waardes pakt van Wall en Rock
          PVector intUp = ray.getIntersection(object.lb, object.rb); //Checkt intersectie met bovenkant
          PVector intRight = ray.getIntersection(object.rb, object.ro); //Checkt intersectie met rechterkant
          PVector intDown = ray.getIntersection(object.ro, object.lo); //Checkt intersectie met onderkant
          PVector intLeft = ray.getIntersection(object.lo, object.lb); //Checkt intersectie met linkerkant
          if (intUp != null ) { //Als er een intersectie plaatsvind bij bovenkant ga verder
            float d = PVector.dist(this.pos, intUp); //Afstand tussen de emitter en intersectie
            if (d < record) { //Als afstand kleiner is dan de width ga verder
              record = d;
              closest = intUp; //Closest is uitkomst van intersectie punt
            }
          }  
          if (intRight != null ) {
            float d = PVector.dist(this.pos, intRight);
            if (d < record) {
              record = d;
              closest = intRight;
            }
          }  
          if (intDown != null ) {
            float d = PVector.dist(this.pos, intDown);
            if (d < record) {
              record = d;
              closest = intDown;
            }
          }  
          if (intLeft != null ) {
            float d = PVector.dist(this.pos, intLeft);
            if (d < record) {
              record = d;
              closest = intLeft;
            }
          }
        }
      }
      //Safe wall voor toevoegen closest aan de list met vertices
      if (closest != null) { 
        lightVertices.add(closest);
      }
    }
    //Schoon de rays arraylist
    rays.clear();
    //Sorteer alle punten op hoek tegenover de emitter
    sortList();
  }

  public void sortList() {
    while (lightVertices.size() > 0) {
      float biggestAngle = 0;
      int biggestAngleIndex = 0;
      float currentVertexAngle = 0;
      for (int i = 0; i < lightVertices.size(); i++ ) {
        currentVertexAngle = angleCalculationMagic(lightVertices.get(i));
        if (currentVertexAngle > biggestAngle) {
          biggestAngle = currentVertexAngle;
          biggestAngleIndex = i;
        }
      }
      sortedLightVertices.add(lightVertices.get(biggestAngleIndex));
      lightVertices.remove(biggestAngleIndex);
    }
  }

  public float angleCalculationMagic(PVector vertex) {
    boolean aboveEmitter;
    boolean rightOfEmitter;

    float vertexX = vertex.x;
    float vertexY = vertex.y;

    float distanceX = 0;
    float distanceY = 0;

    float basicRadiansBetweenEmitterAndVertex = 0;
    float trueRadiansBetweenEmitterAndVertex = 0;

    if (vertexX > pos.x) {
      distanceX = vertexX - pos.x;
      rightOfEmitter = true;
    } else {
      distanceX = pos.x - vertexX;
      rightOfEmitter = false;
    }

    if (vertexY > pos.y) {
      distanceY = vertexY - pos.y;
      aboveEmitter = true;
    } else {
      distanceY = pos.y - vertexY;
      aboveEmitter = false;
    }

    basicRadiansBetweenEmitterAndVertex = atan(distanceY/distanceX);
    if (rightOfEmitter && aboveEmitter) {
      trueRadiansBetweenEmitterAndVertex = HALF_PI - basicRadiansBetweenEmitterAndVertex;
    } else if (rightOfEmitter && !aboveEmitter) {
      trueRadiansBetweenEmitterAndVertex = HALF_PI + basicRadiansBetweenEmitterAndVertex;
    } else if (!rightOfEmitter && !aboveEmitter) {
      trueRadiansBetweenEmitterAndVertex = PI + HALF_PI - basicRadiansBetweenEmitterAndVertex;
    } else {
      trueRadiansBetweenEmitterAndVertex = PI + HALF_PI + basicRadiansBetweenEmitterAndVertex;
    }
    return trueRadiansBetweenEmitterAndVertex;
  }

  //Maken van de lightpoly op basis van de sorted light vertices, neemt de grijswaarde in
  public PShape getShape(int col) {
    lightPoly = createShape();
    lightPoly.beginShape();
    lightPoly.noStroke();
    lightPoly.fill(col);
    for (PVector vertex : sortedLightVertices) {
      lightPoly.vertex(vertex.x, vertex.y);
    }
    lightPoly.endShape();
    sortedLightVertices.clear();
    lightVertices.clear();

    return lightPoly;
  }
}
//Code Credit Ole Neuman 
//This class handles everything that has to do with the map 




class MapHandler { 

  IntList mapList; 
  Queue<Integer> mapQueue;
  PImage newMap; 
  int tileSize; 
  float mapScrollSpeed; 
  float baseScrollSpeed;
  float mapPositionTracker; 
  float fastforwardWidth;
  float offSet; 
  int mapAmount; 
  int numberOfMapsLoaded;
  boolean mapScrolling;
  boolean mapEvent;

  String bossToBeSpawned;

  MapHandler(int sizeOfTiles) { 
    mapList = new IntList();
    mapQueue = new ArrayDeque<Integer>(50);
    for (int i = 0; i < LEVEL_AMOUNT; i++) {
      mapList.append(i);
    }
    addTutorial();
    mapPositionTracker = 0; 
    tileSize = sizeOfTiles; 
    baseScrollSpeed = MAP_SCROLL_SPEED; 
    mapScrollSpeed = baseScrollSpeed;
    offSet = MAP_OFFSET; 
    mapAmount = LEVEL_AMOUNT;
    mapScrolling = false;
    mapEvent = false;
    fastforwardWidth = 0.60f;
    numberOfMapsLoaded = 0;
    bossToBeSpawned = "";
  } 

  public void update() { 
    mapScrollSpeed = baseScrollSpeed;
    if (!mapScrolling) mapScrollSpeed = 0;
    fastMapForward();
    mapPositionTracker -= mapScrollSpeed; 
    if (mapPositionTracker <= 0) { 
      mapEventHandler();
      if (mapEvent == false) {
        loadNormalMap(); 
        //println("Generating new map");
      } else if ( mapPositionTracker <= -128) {
        mapScrolling = false;
        fastforwardWidth = 1;
        spawnBoss();
        mapEvent = false;
        offSet -= 128;
      }
    }
  }


  public void fastMapForward() {
    if (game.objectHandler.entities.get(0).x > width * fastforwardWidth) {
      if (fastforwardWidth != 0.75f) {
        mapScrolling = true;
        fastforwardWidth = 0.75f;
      }
      mapScrollSpeed += 0.5f;
    }
  }

  public void generateMap(ObjectHandler objectHandler) { 
    loadMap(newMap.pixels, newMap.width, newMap.height, tileSize, tileSize, objectHandler, offSet);
    mapPositionTracker += offSet; 
    offSet = floor(newMap.width * tileSize); 
    numberOfMapsLoaded += 1;
  } 

  public void mapEventHandler() {
    //switch(numberOfMapsLoaded) {
    //}
    if (mapEvent) {
    }

    if (numberOfMapsLoaded % 5 == 0 && numberOfMapsLoaded != 0 && !mapEvent) {
      generateBossMap();
      mapEvent = true;
    }
  }


  public void loadNormalMap() {
    if (mapQueue.peek() != null) {
      int mapFileNumber = mapQueue.remove();
      loadNormalMapImage(mapFileNumber);
    } else {
      generateQueue();
    }
  }

  public void loadNormalMapImage(int mapFileNumber) { 
    if (mapFileNumber >= 0) {
      newMap = loadImage("data/maps/main/map" + mapFileNumber + ".png"); 
      newMap.loadPixels();
    } else {
      newMap = loadImage("data/maps/start/tutorial" + (-mapFileNumber - 1) + ".png"); 
      newMap.loadPixels();
    }
    generateMap(game.objectHandler);
  }

  public void generateQueue() {
    IntList maps = mapList;
    while (maps.size() > 0) {
      int randomMapIndex = PApplet.parseInt(random(0, maps.size()));
      mapQueue.add(maps.get(randomMapIndex));
      maps.remove(randomMapIndex);
    }
  }

  public void generateBossMap() {
    bossToBeSpawned = randomBoss();
    newMap = loadImage("data/maps/bosses/" + bossToBeSpawned + "_map.png");
    newMap.loadPixels();
    generateMap(game.objectHandler);
    numberOfMapsLoaded += 1;
  }

  public void addTutorial() {
    mapQueue.add(-1);
    mapQueue.add(-2);
  }
  
  public void spawnBoss(){
   switch(bossToBeSpawned){
     case "spider":
     game.objectHandler.addSpiderQueen(1200, 540, tileSize, tileSize);
     break;
     
     case "wall":
     game.objectHandler.addMovingWall(1200, 540, tileSize, tileSize);
     break;
   }
  }
  
  public String randomBoss(){
   int boss = PApplet.parseInt(random(1, 3));
   switch(boss){
    case 1:
    return "spider";
    
    case 2:
    return "wall";
    
    default:
    return "spider";
   }
  }
}


//Code credit Winand Metz
//Het bepalen van de plaatsing van objecten in het level dmv aflezen pixel colorcodes(android graphics color) en dit omzetten in een grid van 15 bij 8
public void loadMap(int[] pixels, int w, int h, int tw, int th, ObjectHandler objectHandler, float offSet) {
  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++ ) {
      int loc = x + y * w;
      float c = pixels[loc];
      //Hexcode = 595652
      if (c == 0xFF595652) {
        objectHandler.addWall(x * tw + offSet, y * th, tw, th);
      }
      //Hexode = ac3232
      if (c == 0xFFac3232) {
        objectHandler.addEnemy(x * tw + offSet, y * th, tw, th);
      }
      //Hexode = 00a0c8
      if (c == 0xFF000000) {
        objectHandler.addSpider(x * tw + offSet, y * th, tw, th);
      }
      //Hexcode = 76428a
      if (c == 0xFF76428a) {
        objectHandler.addBreakableWall(x * tw + offSet, y * th, tw, th);
      }
      //Hexcode = 222034
      if (c == 0xFF222034) {
        objectHandler.addSpiderQueen(x * tw + offSet, y * th, tw, th);
      }
      //Hexcode = 45283c
      if (c == 0xFF45283c) {
        objectHandler.addMovingWall(x * tw + offSet, y * th, tw, th);
      }
      //Hexcode = 696a6a
      if (c == 0xFF696a6a) {
        objectHandler.addRock(x * tw + offSet, y * th, tw, th);
      }
      //Hexcode = 6abe30
      if (c == 0xFF6abe30) {
        objectHandler.addBreakableItem(x * tw + offSet, y * th, tw, th);
      }
    }
  }
}
//all code that has to do with the Main Menu of the game
//code credit Ole Neuman

class MainMenu {

  TextureAssets sprites;
  SoundAssets soundAssets;

  MenuBox[] boxArray = new MenuBox[MENUBOX_AMOUNT];

  int boxSelected;
  int moveCooldown;

  PImage logo;

  int xKeyXPos = 1405;
  int xKeyYPosStart = 640;
  int xKeyYPosSettings = 820;
  int xKeyYPosQuit = 1000;

  MainMenu(TextureAssets textureLoader, SoundAssets soundAssets) {

    for (int i = 0; i < MENUBOX_AMOUNT; i++) {
      boxArray[i] = new MenuBox(width / 4, height / 2 + i* (height / 6), width / 2, height / 8, 20);
    }
    boxArray[0].boxText = "Start";
    //boxArray[1].boxText = "Settings";
    boxArray[1].boxText = "Quit";

    boxSelected = 0;

    moveCooldown = 0;
    this.sprites = textureLoader;
    this.soundAssets = soundAssets;
  }

  public void draw() {
    background(MENU_BACKGROUND_COLOUR);
    image(sprites.getLogo(), 20, height - 131, 200, 111);
    for (MenuBox menuBox : boxArray) {
      menuBox.draw();
    }
    image(sprites.getKeyCap(2, 7), xKeyXPos, xKeyYPosStart);
    image(sprites.getKeyCap(2, 7), xKeyXPos, xKeyYPosSettings);
    //image(sprites.getKeyCap(2, 7), xKeyXPos, xKeyYPosQuit);
  }

  public void update() {
    for (MenuBox menuBox : boxArray) {
      menuBox.selected = false;
    }
    boxArray[boxSelected].selected = true;


    if (input.upDown() && moveCooldown == 0) {
      if (boxSelected == 0) boxSelected = MENUBOX_AMOUNT - 1;
      else boxSelected--;
      moveCooldown = MENU_MOVE_COOLDOWN;
      soundAssets.getMenuHover();
    }

    if (input.downDown() && moveCooldown == 0) {
      if (boxSelected == MENUBOX_AMOUNT - 1) boxSelected = 0;
      else boxSelected++;
      moveCooldown = MENU_MOVE_COOLDOWN;
      soundAssets.getMenuHover();
    }
    if (moveCooldown > 0) moveCooldown--;

    if (input.xDown()) {
      soundAssets.getMenuSelect();
      switch(boxSelected) {
      case 0:
        gameState = 1;
        break;
        //case 1:
        //  gameState = 2;
        //  break;
      case 1:
        exit();
        return;

      default:
        gameState = 1;
      }
    }
  }
}

class MenuBox {

  float posX, posY;
  int boxWidth, boxHeight;

  int boxOuterColour;
  int boxInteriorColour;
  int textColour;

  String boxText;
  int textSize;

  boolean selected;

  MenuBox(float positionX, float positionY, int Width, int Height, int size) {
    posX = positionX;
    posY = positionY;
    boxWidth = Width;
    boxHeight = Height;
    boxOuterColour = BOX_BASIC_OUTER_COLOUR;
    boxInteriorColour = BOX_BASIC_INNER_COLOUR;
    textColour = BOX_TEXT_COLOUR;
    boxText = "";
    textSize = size;
    selected = false;
  }

  public void draw() {
    update();
    stroke(boxOuterColour);
    fill(boxInteriorColour);
    strokeWeight(5);
    rect(posX, posY, boxWidth, boxHeight);
    strokeWeight(1);
    fill(textColour);
    textSize(textSize);
    text(boxText, posX + boxWidth / 2, posY + boxHeight / 2);
  }

  public void update() {
    if (selected) {
      boxOuterColour = BOX_HIGHLIGHTED_OUTER_COLOUR;
      boxInteriorColour = BOX_HIGHLIGHTED_INNER_COLOUR;
    } else {
      boxOuterColour = BOX_BASIC_OUTER_COLOUR;
      boxInteriorColour = BOX_BASIC_INNER_COLOUR;
    }
  }
}

//code credit Jordy
//gameOver scherm
class GameOver {
  TextureAssets sprites;
  Highscore highscore;

  GameOver(TextureAssets textureLoader) {
    this.sprites = textureLoader;
  }

  public void update(Highscore highscore) {
    this.highscore = highscore;
    if (input.escapeDown()) {
      toMainMenu();
    }
  }

  public void draw() {
    background(MENU_BACKGROUND_COLOUR);
    image(sprites.getLogo(), 20, height - 131, 200, 111);
    fill(0);
    textSize(50);
    text("GAME OVER", width / 2 -150, height / 4);
    textSize(40);
    text("SCORE: " + highscore.score, width / 2 -125, height / 4 + 100);
  }
}
//Code credit Winand Metz

//Kan gebruikt worden in schrijven van collision methods, maar ook andere scripting usages, eigenlijk andere manier van classes, game objecten, oproepen
enum ObjectID {
  WALL, PLAYER, ENTITY, BOMB, ROCK, BBLOCK, ITEM, SPIDER_BOMB, PATH, FIX
}

enum ItemID {
  BOOTS, SPARKLER, BPOTION, SHIELD, CLOAK, HEART, COIN
}

enum BombID {
  CFOUR, DYNAMITE, LANDMINE, SPIDER_BOMB
}

enum EntityID {
  GHOST, MUMMY, SMUMMY, SPIDER, EXPLOSIVE_SPIDER, POLTERGEIST, SPIDER_BOSS, WALL_BOSS, BOBJECT
}

//Basis class voor alle gameobjecten
abstract class Object {

  PVector lb, rb, ro, lo, or, left, right, up, down;

  boolean cloakBonus;
  boolean undefeatabaleBonus;
  boolean speedBonus;
  boolean sparklerBonus;

  float x, y;
  int w, h;
  ObjectID objectId;
  ItemID itemId;
  EntityID entityId;
  BombID bombId;
  ObjectHandler objectHandler;
  TextureAssets sprites;
  SoundAssets soundAssets;

  Object(float x, float y, int w, int h, ObjectID objectId, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.objectId = objectId;
    this.objectHandler = objectHandler;
    this.sprites = sprites;
    this.soundAssets = soundAssets;
    lb = new PVector();
    rb = new PVector();
    ro = new PVector();
    lo = new PVector();
    or = new PVector();
    left = new PVector();
    right = new PVector();
    up = new PVector();
    down = new PVector();
  }

  public abstract void update();

  public abstract void draw();

  public void moveMap() { 
    x -= game.mapHandler.mapScrollSpeed;
  } 

  public void selfDestruct() {
    if (x < -256) {
      if (objectId == ObjectID.WALL || objectId == ObjectID.BBLOCK ||objectId == ObjectID.ROCK) {
        objectHandler.removeWall(this);
      } 
      objectHandler.removeEntity(this);
    }
  }

  //Position crawler voor de player X
  //Gaat door de objecthandler z'n list heen en zoekt naar object met het ID player om vervolgens x op te vragen
  public float getPlayerX() {
    float pX = 0;
    ArrayList<Object> entityObjects = objectHandler.entities;
    Object player = entityObjects.get(0);
    pX = player.x;
    return pX;
  }

  //Position crawler voor de player Y
  public float getPlayerY() {
    float pY = 0;
    ArrayList<Object> entityObjects = objectHandler.entities;
    Object player = entityObjects.get(0);
    pY = player.y;
    return pY;
  }

  public PVector getPlayerPos() {
    PVector pt = new PVector();

    ArrayList<Object> entityObjects = objectHandler.entities;
    Object player = entityObjects.get(0);

    pt.set(player.or);

    return pt;
  }

  //Geeft aan of twee objecten met elkaar kruizen, is niet echt bruikbaar buiten een crawler
  public boolean intersection(Object other) {
    return other.w > 0 && other.h > 0 && w > 0 && h > 0
      && other.x < x + w && other.x + other.w > x
      && other.y < y + h && other.y + other.h > y;
  }

  //Gebruikt bovenstaande methode om te kijken of objecten elkaar doorkruizen
  public boolean wallCollisionDetection() {
    for (Object wallObject : objectHandler.walls) {
      for (Object entityObject : objectHandler.entities) {
        if (!entityObject.equals(this) && intersection(wallObject) && entityObject.objectId != ObjectID.BOMB && entityObject.entityId != EntityID.GHOST) {
          return true;
        }
      }
    }
    return false;
  }


  public boolean rockCollisionDetection() {
    for (Object wallObject : objectHandler.walls) {
      for (Object entityObject : objectHandler.entities) {
        if (!entityObject.equals(this) && intersection(wallObject) && wallObject.objectId == ObjectID.ROCK) {
          return true;
        }
      }
    }
    return false;
  }
}
//Code credit Winand Metz

//Class voor het creëren en opslaan van de objecten
class ObjectHandler {

  float enemySpawnChance[][] = new float[6][2];
  float itemSpawnChance[][] = new float[7][2];

  int eSD = ENTITY_SIZE_DIVIDER;

  ArrayList<Object> walls =  new ArrayList<Object>();
  ArrayList<Object> entities = new ArrayList<Object>();

  Player player = null;
  CollisionFix fix = null;

  TextureAssets sprites;
  SoundAssets soundAssets;

  ObjectHandler(TextureAssets sprites, SoundAssets soundAssets) {
    this.sprites = sprites;
    this.soundAssets = soundAssets;
    for (int i = 0; i < enemySpawnChance.length; i++) {
      enemySpawnChance[i][0] = i;
    }
    enemySpawnChance[0][1] = GHOST_SPAWN_CHANCE;
    enemySpawnChance[1][1] = POLTERGEIST_SPAWN_CHANCE;
    enemySpawnChance[2][1] = SPIDER_SPAWN_CHANCE;
    enemySpawnChance[3][1] = EXPLOSIVE_SPIDER_SPAWN_CHANCE;
    enemySpawnChance[4][1] = MUMMY_SPAWN_CHANCE;
    enemySpawnChance[5][1] = STONED_MUMMY_SPAWN_CHANCE;

    for (int i = 0; i < itemSpawnChance.length; i++) {
      itemSpawnChance[i][0] = i;
    }
    itemSpawnChance[0][1] = BOOTS_DROP_CHANCE;
    itemSpawnChance[1][1] = SPARKLER_DROP_CHANCE;
    itemSpawnChance[2][1] = BLUE_POTION_DROP_CHANCE;
    itemSpawnChance[3][1] = SHIELD_DROP_CHANCE;
    itemSpawnChance[4][1] = CLOAK_DROP_CHANCE;
    itemSpawnChance[5][1] = HEART_DROP_CHANCE;
    itemSpawnChance[6][1] = COIN_DROP_CHANCE;
  }

  public void addEntity(float x, float y, int w, int h) {
    x = x + 32;
    y = y + 32;

    Entity entity = new Entity(x, y - OBJECT_Y_OFFSET, w / eSD, h / eSD, this, sprites, soundAssets);
    entities.add(entity);
  }

  public float getEnemy(float rand) {
    for (int i = 0; i < enemySpawnChance.length; i++) {
      if (rand < enemySpawnChance[i][1]) {
        return enemySpawnChance[i][0] + 1;
      }
      rand -= enemySpawnChance[i][1];
    }
    return 1;
  }

  public void addEnemy(float x, float y, int w, int h) {
    x = x + 64;
    y = y + 64;

    int total = 0;
    for (int i = 0; i < enemySpawnChance.length; i++) { 
      total += enemySpawnChance[i][1];
    }

    float rand = random(0, 1) * total;
    float enemy = getEnemy(rand);

    //println(enemy);

    //Ghost 
    if (enemy == 1) {
      Ghost ghost = new Ghost(x, y - OBJECT_Y_OFFSET, w / eSD, h / eSD, this, sprites, soundAssets);
      entities.add(ghost);
    }
    //Poltergeist
    if (enemy == 2) {
      Poltergeist poltergeist = new Poltergeist(x, y - OBJECT_Y_OFFSET, w / eSD, h / eSD, this, sprites, soundAssets);
      entities.add(poltergeist);
    }
    //Spider
    if (enemy == 3) {
      Spider spider = new Spider(x, y - OBJECT_Y_OFFSET, w / eSD / eSD, h / eSD / eSD, this, sprites, soundAssets);
      entities.add(spider);
    }
    //Exp spider
    if (enemy == 4) {
      ExplosiveSpider explosiveSpider = new ExplosiveSpider(x, y - OBJECT_Y_OFFSET, w / eSD, h / eSD, this, sprites, soundAssets);
      entities.add(explosiveSpider);
    }
    //Mummy
    if (enemy == 5) {
      Mummy mummy = new Mummy(x, y - OBJECT_Y_OFFSET, w / eSD / eSD, h / eSD, this, sprites, soundAssets);
      entities.add(mummy);
    }
    //SMummy
    if (enemy == 6) {
      SMummy sMummy = new SMummy(x, y - OBJECT_Y_OFFSET, w / eSD, h / eSD, this, sprites, soundAssets);
      entities.add(sMummy);
    }
  }

  public void addBreakableObject(float x, float y, int w, int h) {
    BreakableObject breakableObject = new BreakableObject(x, y - OBJECT_Y_OFFSET, w / eSD / eSD, h / eSD / eSD, this, sprites, soundAssets);
    entities.add(breakableObject);
  }

  public void addSpider(float x, float y, int w, int h) {
    Spider spider = new Spider(x, y - OBJECT_Y_OFFSET, w / eSD / eSD, h / eSD / eSD, this, sprites, soundAssets);
    entities.add(spider);
  }

  //Method voor het creëren van de muren, input lijkt me vanzelf sprekend
  public void addWall(float x, float y, int w, int h) {
    Wall wall = new Wall(x, y - OBJECT_Y_OFFSET, w, h, this, sprites, soundAssets);
    walls.add(wall);
  }

  //Method voor de rockwall onder- en bovenkant van het scherm 
  public void addRock(float x, float y, int w, int h) {
    Rock rock = new Rock(x, y - OBJECT_Y_OFFSET, w, h, this, sprites, soundAssets);
    walls.add(rock);
  }

  public void addBreakableWall(float x, float y, int w, int h) {
    BreakableWall breakableWall = new BreakableWall(x, y - OBJECT_Y_OFFSET, w, h, this, sprites, soundAssets);
    walls.add(breakableWall);
  }

  //Method voor plaatsen van de player
  public void addPlayer(Highscore highscore) {
    Player player = new Player(PLAYER_X_SPAWN, PLAYER_Y_SPAWN, PLAYER_SIZE / eSD, PLAYER_SIZE, this, sprites, highscore, soundAssets);
    entities.add(player);
    println("spawned");
  }

  public void addFix() {
    CollisionFix fix = new CollisionFix(PLAYER_X_SPAWN, PLAYER_Y_SPAWN - OBJECT_Y_OFFSET, PLAYER_SIZE, PLAYER_SIZE, this, sprites, soundAssets);
    entities.add(fix);
  }

  //Method voor plaatsen van een Bomb
  public void addBomb(float x, float y, int w, int h) {
    Bomb bomb = new Bomb(x, y, w, h, this, sprites, soundAssets);
    entities.add(bomb);
  }

  public void addC4(float x, float y, int w, int h) {
    C4 c4 = new C4(x, y, w, h, this, sprites, soundAssets);
    entities.add(c4);
  }

  public void addLandmine(float x, float y, int w, int h) {
    Landmine landmine = new Landmine(x, y, w, h, this, sprites, soundAssets);
    entities.add(landmine);
  }

  //Method voor plaatsen van een SpiderBomb
  public void addSpiderBomb(float x, float y, int w, int h) {
    SpiderBomb spiderBomb = new SpiderBomb(x, y, w, h, this, sprites, soundAssets);
    entities.add(spiderBomb);
  }

  public float getItem(float rand) {
    for (int i = 0; i < itemSpawnChance.length; i++) {
      if (rand < itemSpawnChance[i][1]) {
        return itemSpawnChance[i][0] + 1;
      }
      rand -= itemSpawnChance[i][1];
    }
    return 1;
  }

  public void addItem(float x, float y, int w, int h) {
    int total = 0;
    for (int i = 0; i < itemSpawnChance.length; i++) { 
      total += itemSpawnChance[i][1];
    }

    float rand = random(0, 1) * total;
    float item = getItem(rand);

    //println(item);

    //Boots
    if (item == 1) {
      Boots boots = new Boots(x, y, w / eSD, h / eSD, this, sprites, soundAssets);
      entities.add(boots);
    }
    //Sparkler
    if (item == 2) {
      Sparkler sparkler = new Sparkler(x, y, w / eSD, h / eSD, this, sprites, soundAssets);
      entities.add(sparkler);
    }
    //Blue Potion
    if (item == 3) {
      BluePotion bluePotion = new BluePotion(x, y, w / eSD, h / eSD, this, sprites, soundAssets);
      entities.add(bluePotion);
    }
    //Shield
    if (item == 4) {
      Shield shield = new Shield(x, y, w / eSD, h / eSD, this, sprites, soundAssets);
      entities.add(shield);
    }
    //Cloak
    if (item == 5) {
      Cloak cloak = new Cloak(x, y, w / eSD, h / eSD, this, sprites, soundAssets);
      entities.add(cloak);
    }
    //Heart
    if (item == 6) {
      Heart heart = new Heart(x, y, w / eSD, h / eSD, this, sprites, soundAssets);
      entities.add(heart);
    }
    //Coin
    if (item == 7) {
      Coin coin = new Coin(x, y, w / eSD, h / eSD, this, sprites, soundAssets);
      entities.add(coin);
    }
  }

  public void addSpiderQueen(float x, float y, int w, int h) {
    SpiderQueen spiderQueen = new SpiderQueen(x, y - OBJECT_Y_OFFSET, w, h, this, sprites, soundAssets);
    entities.add(spiderQueen);
  }

  public void addMovingWall(float x, float y, int w, int h) {
    MovingWall movingWall = new MovingWall(x, y - OBJECT_Y_OFFSET, w, h, this, sprites, soundAssets);
    entities.add(movingWall);
  }

  public void addBreakableItem(float x, float y, int w, int h) {
    int randomItem = (int)random(4);

    //println(randomItem);

    if (randomItem == 1) {
      Corpse corpse = new Corpse(x, y - OBJECT_Y_OFFSET, w, h / eSD, this, sprites, soundAssets);
      entities.add(corpse);
    }
    if (randomItem == 2) {
      Vases vases = new Vases(x, y - OBJECT_Y_OFFSET, w / eSD, h / eSD, this, sprites, soundAssets);
      entities.add(vases);
    }
    if (randomItem == 3) {
      Backpack backpack = new Backpack(x, y - OBJECT_Y_OFFSET, w / eSD, h / eSD, this, sprites, soundAssets);
      entities.add(backpack);
    }
  }

  //Method van verwijderen objecten uit array
  public void removeEntity(Object entry) {
    entities.remove(entry);
  }

  public void removeWall(Object entry) {
    walls.remove(entry);
  }

  //Updates elke list entry
  public void update() {
    ArrayList<Object> entityObjects = entities;
    for (int i = 0; i < entityObjects.size(); i++) {
      if (i >= entityObjects.size()) {
        break;
      }
      entityObjects.get(i).moveMap();
      entityObjects.get(i).update();
    }

    ArrayList<Object> wallObjects = walls;
    for (int i = 0; i < wallObjects.size(); i++) {
      if (i >= wallObjects.size()) {
        break;
      }
      wallObjects.get(i).moveMap();
      wallObjects.get(i).update();
    }
  }

  //Draw method voor elk onderdeel in de list
  public void draw() {
    ArrayList<Object> entityObjects = entities;
    for (int i = 0; i < entityObjects.size(); i++) {
      if (i >= entityObjects.size()) {
        break;
      }
      entityObjects.get(i).draw();
    }

    ArrayList<Object> wallObjects = walls;
    for (int i = 0; i < wallObjects.size(); i++) {
      if (i >= wallObjects.size()) {
        break;
      }
      wallObjects.get(i).draw();
    }
  }
}
//Code credit Ruben Verheul, Winand Metz, Ole Neuman

class Player extends Object {
  Timer timer;
  Highscore highscore;

  boolean shieldBonus = false;
  boolean undefeatabaleBonus = false;
  boolean speedBonus = false;
  boolean sparklerBonus = false;
  boolean insideExplosion = false;
  boolean takenBombDamage = false;
  boolean takenEnemyDamage = false;
  boolean gettingAttacked = false;

  int speedX, speedY, startTime, attackDamage;
  int speedBonusTimer = SPEED_BONUS_TIME;
  int undefeatabaleBonusTimer = UNDEFEATBALE_BONUS_TIME;
  int cloakBonusTimer = CLOACK_BONUS_TIME;
  int sparklerBonusTimer = BOMB_BONUS_TIME;
  int velX = PLAYER_SPEED;
  int velY = PLAYER_SPEED;
  int health = PLAYER_HEALTH;
  int shield = PLAYER_SHIELD;
  float oldX, oldY;
  int bombCooldown = 0;
  int bombSparklerCooldown = 0;
  int fps = 20;

  Player(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, Highscore highscore, SoundAssets soundAssets) {
    super(x, y, w, h, ObjectID.PLAYER, objectHandler, sprites, soundAssets);
    timer = new Timer();
    this.highscore = highscore;
  }

  public void update() {
    playerControls();

    lb = new PVector(x, y);
    rb = new PVector(x + w, y);
    ro = new PVector(x + w, y + h);
    lo = new PVector(x, y + h);

    or = new PVector((lb.x + rb.x) / 2, (lb.y + lo.y) / 2);

    if (speedX == 4 || speedY == 4 || speedX == 4 && speedY == 4 || speedX == -4 || speedY == -4 || speedX == -4 && speedY == -4) {
      if((frameCount % fps) == 0)
      soundAssets.getPlayerFootsteps();
    }
    
    x = x + speedX;
    y = y + speedY;

    if (wallCollisionDetection()) {
      x = oldX - game.mapHandler.mapScrollSpeed;
      y = oldY;
    }

    oldX = x;
    oldY = y;

    powerUpDetection();
    powerUps();

    bombDamage();
    enemyDamage();

    if (shield <= 0) {
      shieldBonus = false;
    }

    if (health <= 0 || x <= -128) {
      gameState = 2;
    }

    if (bombCooldown > 0) bombCooldown--;
  }

  public void playerControls() {
    speedX = 0;
    speedY = 0;
    if (input.leftDown() && x > 0) {
      speedX += -velX;
    }
    if (input.rightDown() && x < width) {
      speedX += velX;
    }
    if (input.upDown() && y > 0) {
      speedY += -velY;
    }
    if (input.downDown() && y < height) {
      speedY += velY;
    }

    if (sparklerBonus) {
      bombCooldown = bombSparklerCooldown;
    }

    if (input.zDown() && bombCooldown == 0) {
      objectHandler.addBomb(x + w / 4, y + h / 4, BOMB_SIZE, BOMB_SIZE);
      bombCooldown = BOMB_COOLDOWN_TIME;
      //soundAssets.getBombPlaced();
    }
    if (input.sDown()&& bombCooldown == 0) {
      objectHandler.addC4(x + w / 4, y + h / 4, BOMB_SIZE, BOMB_SIZE);
      bombCooldown = BOMB_COOLDOWN_TIME;
      //soundAssets.getBombPlaced();
    }
    if (input.aDown()&& bombCooldown == 0) {
      objectHandler.addLandmine(x + w / 4, y + h / 4, BOMB_SIZE, BOMB_SIZE);
      bombCooldown = BOMB_COOLDOWN_TIME;
      //soundAssets.getBombPlaced();
    }
  }

  public void bombDamage() {
    if (!undefeatabaleBonus) {
      if (insideExplosion && !takenBombDamage) {
        health -= BOMB_DAMAGE;
        println("taking " + BOMB_DAMAGE + " damage");
        takenBombDamage = true;
      }
      if (!insideExplosion && takenBombDamage) {
        takenBombDamage = false;
      }
      insideExplosion = false;
    }
  }

  public void enemyDamage() {
    if (gettingAttacked && !takenEnemyDamage) {
      health -= attackDamage;
      takenEnemyDamage = true;
    }
    if (!gettingAttacked && takenEnemyDamage) {
      takenEnemyDamage = false;
    }
    gettingAttacked = false;
  }

  public void powerUps() {
    if (speedBonus) {
      if (timer.startTimer(speedBonusTimer)) {
        println("ANTIWOOSH");
        velX -= 2;
        velY -= 2;
        speedBonus = false;
      }
    }
    if (cloakBonus) {
      if (timer.startTimer(cloakBonusTimer)) {
        println("now you see me");
        cloakBonus = false;
      }
    }
    if (undefeatabaleBonus) {
      if (timer.startTimer(undefeatabaleBonusTimer)) {
        undefeatabaleBonus = false;
      }
    }
    if (sparklerBonus) {
      if (timer.startTimer(sparklerBonusTimer)) {
        sparklerBonus = false;
      }
    }
    if (shieldBonus && shield == 0) {
      shieldBonus = false;
    }
  }

  public void powerUpDetection() {
    ArrayList<Object> objects = objectHandler.entities;
    for (int i = 0; i < objects.size(); i++) {
      Object item = objects.get(i);
      if (!item.equals(this) && intersection(item) && item.itemId == ItemID.BOOTS) {
        if (!speedBonus) {
          println("NYOOM");
          velX += SPEED_BONUS;
          velY += SPEED_BONUS;
          speedBonus = true;
        }
        if (speedBonus) {
          speedBonusTimer += SPEED_BONUS_TIME;
        }
        objectHandler.removeEntity(item);
      }

      if (!item.equals(this) && intersection(item) && item.itemId == ItemID.COIN) {
        highscore.addScore(COIN_SCORE);
        objectHandler.removeEntity(item);
      }

      if (!item.equals(this) && intersection(item) && item.itemId == ItemID.HEART) {
        println("heart goes boom boom");
        health += 1;
        objectHandler.removeEntity(item);
      }

      if (!item.equals(this) && intersection(item) && item.itemId == ItemID.SHIELD) {
        println("thicc");
        shield += SHIELD_BONUS;
        shieldBonus = true;
        objectHandler.removeEntity(item);
      }

      if (!item.equals(this) && intersection(item) && item.itemId == ItemID.BPOTION) {
        println("me goes not boom boom");
        undefeatabaleBonus = true;
        objectHandler.removeEntity(item);
      }

      if (!item.equals(this) && intersection(item) && item.itemId == ItemID.SPARKLER) {
        println("kaboom? Yes Rico, kaboom");
        sparklerBonus = true;
        objectHandler.removeEntity(item);
      }

      if (!item.equals(this) && intersection(item) && item.itemId == ItemID.CLOAK) {
        println("now you dont");
        cloakBonus = true;
        objectHandler.removeEntity(item);
      }
    }
  }


  public void draw() {
    if (!cloakBonus) {
      image(sprites.getEntity(1, 1), x, y);
    }
  }
}
class SeverHandler {

  SeverHandler() {
  }
  
}
class UserInterface {
  TextureAssets assetLoader;
  Player player;
  Highscore highscore;
  ObjectHandler objectHandler;

  boolean shieldBonus = false;
  boolean undefeatabaleBonus = false;
  boolean speedBonus = false;
  boolean sparklerBonus = false;

  int bombCooldown, health, shield;

  UserInterface(TextureAssets assetLoader, Highscore highScore, ObjectHandler objectHandler) {
    this.assetLoader = assetLoader;
    this.objectHandler = objectHandler;
    this.highscore = highScore;
    this.assetLoader = assetLoader;
    this.highscore = highScore;
  }

  public void update() {
    ArrayList<Object> entityObjects = objectHandler.entities;
    Object playerEntity = entityObjects.get(0);
    bombCooldown = ((Player)playerEntity).bombCooldown;
    health = ((Player)playerEntity).health;
    shield = ((Player)playerEntity).shield;
    speedBonus = ((Player)playerEntity).speedBonus;
    sparklerBonus = ((Player)playerEntity).sparklerBonus;
    undefeatabaleBonus = ((Player)playerEntity).undefeatabaleBonus;
    shieldBonus = ((Player)playerEntity).shieldBonus;
  }

  public void draw()
  {
    showHP();
    showShield();
    showScoreBoard();
    showStatsBoard();
    showUI();
    showButtons();

    //READ ME ___ READ ME ___ READ ME ___ READ ME ___ READ ME ___ READ ME ___ READ ME ___ READ ME ___ READ ME ___ READ ME 
    //"Deze void heb ik ff uitgezet mr t werkt wel als iemand eraan wilde zitten voor een of ander reden" ~ Alex

    //showPowerUps();
  }

  public void showHP()
  {
    //Een rectangle voor HP \\\ Per extra opgepakte HP, wordt de lengte vd rectangle vergroot met de toegegeven waarde
    fill(255, 0, 0);
    stroke(200, 0, 0);
    strokeWeight(5);
    rect(80, height-80, health * 20, 20);
    noFill();
    noStroke();
  }

  public void showShield()
  {
    //Een rectangle voor de shield \\\ Per extra opgepakte shield, wordt de lengte vd rectangle vergroot met toegegeven waarde
    fill(0, 255, 255);
    stroke(0, 200, 200);
    strokeWeight(5);
    rect(80, height-30, shield * 20, 15);
    noFill();
    noStroke();
  }

  public void showButtons()
  {
    //Pakt de Z, A, S en de X knop uit Assets
    image(textureAssets.getBombItem(0, 7), width-325, height-50);
    image(textureAssets.getBombItem(6, 7), width-200, height-50);
    image(textureAssets.getBombItem(4, 7), width-75, height-50);
    image(textureAssets.getBombItem(2, 7), width-50, height-150);
  }

  public void showScoreBoard()
  {
    //Pakt de Score bord uit Assets van kolom 1, rij 0 tm 3
    image(textureAssets.getUserHud(0, 1), 0, height-240);
    image(textureAssets.getUserHud(1, 1), 128, height-240);
    image(textureAssets.getUserHud(2, 1), 256, height-240);
    image(textureAssets.getUserHud(3, 1), 384, height-240);

    //Bijbehorende score text
    fill(255);
    textSize(30);
    //text("HighScore: ", 20, height-140);
    text("Your Score: "+ highscore.score, 20, height-170);
    noFill();
  }

  public void showStatsBoard()
  {
    //Pakt de Stats bord uit Assets van kolom 0, rij 0 tm 3
    image(textureAssets.getUserHud(0, 0), 0, height-125);
    image(textureAssets.getUserHud(1, 0), 128, height-125);
    image(textureAssets.getUserHud(2, 0), 256, height-125);
    image(textureAssets.getUserHud(3, 0), 384, height-125);
  }

  public void showUI()
  {
    //Pakt de plaatjes uit Assets voor Dynamite, Landmine, C4
    image(textureAssets.getUserHud(7, 0), width-400, height-125);
    image(textureAssets.getUserHud(7, 1), width-275, height-125);
    image(textureAssets.getUserHud(6, 0), width-150, height-125);

    //Pakt het plaatje uit Assets voor het activeer knop
    image(textureAssets.getUserHud(4, 0), width-125, height-250);

    //Checkt waneer een C4 geplaatst is, zo ja -> verandert het plaatje 
    if (checkC4(objectHandler.entities)) {
      image(textureAssets.getUserHud(5, 0), width-125, height-250);
    }
  }

  //READ ME ___ READ ME ___ READ ME ___ READ ME ___ READ ME ___ READ ME ___ READ ME ___ READ ME ___ READ ME ___ READ ME 
  //"Deze void heb ik ff uitgezet mr t werkt wel als iemand eraan wilde zitten voor een of ander reden" ~ Alex

  //void showPowerUps()
  //{
  //  if (speedBonus) {
  //    fill(125, 125, 255); //lichtpaars/blauw
  //    rect(875, height-75, 50, 50);
  //    noFill();
  //  }

  //  if (sparklerBonus) {
  //    fill(255, 255, 0); //paars/pink
  //    rect(950, height-75, 50, 50);
  //    noFill();
  //  }

  //  if (undefeatabaleBonus) {
  //    fill(255, 0, 255); // geel
  //    rect(1025, height-75, 50, 50);
  //    noFill();
  //  }

  //  if (shieldBonus) {
  //    fill(0, 255, 255);  //cyan
  //    rect(1100, height-75, 50, 50);
  //    noFill();
  //  }
  //}

  //Checkt of er een C4 geplaatst is door de speler
  public boolean checkC4(ArrayList<Object> entityObjects) {
    for (Object c4 : entityObjects) {
      if (c4.bombId == BombID.CFOUR) {
        return true;
      }
    }
    return false;
  }
}
  public void settings() {  fullScreen(P2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "BombsMain" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
