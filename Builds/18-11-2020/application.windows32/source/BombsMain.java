import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import samuelal.squelized.*; 
import processing.sound.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class BombsMain extends PApplet {

/*  Project FYS Winand Metz 500851135, Ole Neuman 500827044, 
 Ruben Verheul 500855129, Jordy Post 500846919, Alex Tarnòki 500798826
 
 Controls: pijltjes toetsen voor lopen, z voor plaatsen dynamiet en esc voor exit */

//Code credit Winand Metz, Ole Neuman



//Voor main menu etc
Game game;
InputHandler input;

final int KEY_LIMIT = 1024;
boolean[] keysPressed = new boolean[KEY_LIMIT];

public void setup() {
  //fullScreen(P2D);
  
  frameRate(FRAMERATE);
  game = new Game(TILE_SIZE, width, height);
  input = new InputHandler();
}

//-----------------------------Draw & Key functies---------------------------------

public void draw() {
  game.update();
  game.draw();
}

public void keyPressed() {  
  if (keyCode >= KEY_LIMIT) return;
  keysPressed[keyCode] = true;
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

  //Class neemt filepath in en de groote van de gridtegels
  TextureAssets(int tileSize) {
    sprites = loadSprites("data/text/textures.png", tileSize);
    wallSprites = loadSprites("data/text/walls/walls_spritesheet.png", tileSize);
  }

  //Laden van de wall op x 0 en y 0, oftwel eerste vak van het grid met tiles van 128 by 128 pixels
  public PImage getWall(int row, int column) {
    return wallSprites[row][column];
  }

  public PImage getPlayer() {
    return sprites[1][1];
  }

  public PImage getRock() {
    return sprites[1][0];
  }

  //Functie voor het inladen van de verschillende textures in de array
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
}
//Code credit Winand Metz

//Muren, moet nog collision op
class Wall extends Object {
  Ray leftRay;
  Ray rightRay;
  Ray upRay;
  Ray downRay;

  boolean leftCon = false;
  boolean rightCon = false;
  boolean upCon = false;
  boolean downCon = false;

  Wall(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, ObjectID.WALL, objectHandler, sprites);
  }

  public void ifTouching(Object crate) {
  }

  public void update() {
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
      if (wallObject.objectId == ObjectID.WALL || wallObject.objectId == ObjectID.ROCK) {
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

  Rock(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, ObjectID.ROCK, objectHandler, sprites);
  }

  public void ifTouching(Object crate) {
  }

  public void update() {
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

//-----------------------------Breakable blocks---------------------------------

class BreakableBlock extends Entity {

  int health = BBLOCK_HEALTH;

  //PVector lb, rb, ro, lo;

  BreakableBlock(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.objectId = ObjectID.BBLOCK;
  }

  public void update() {
    bombDamage();
  }

  public void bombDamage() {
    if (insideExplosion) {
      health -= BOMB_DAMAGE;
      insideExplosion = false;
    }
    if (health <= 0) {
      objectHandler.removeWall(this);
      objectHandler.addBoots(x, y, 64, 64);
    }
  }

  public void draw() {
    fill(128, 24, 78);
    rect(x, y, w, h);
  }
}
//Code credit Alex Tarnòki, Ole Neuman

class Bomb extends Object {

  int bombTimer = EXPLOSION_TIMER;
  int bombOpacity = BOMB_START_OPACITY;
  int startTime;
  int explosionOpacity = EXPLOSION_START_OPACITY;
  int explosionRadius = EXPLOSION_START_RADIUS;


  Bomb(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, ObjectID.BOMB, objectHandler, sprites);
    startTime = millis();
  }

  public void ifTouching(Object crate) {
  }

  //Wanneer dynamiet explodeerd kijk hij of er enemy in de blastradius zit en paast dit door naar de enemy class
  //Explosie begint fel en neemt daarna af in opacity, wanneer deze nul is wordt hij verwijdert
  public void update() {
    if ( bombExploded()) {
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

  public void draw() {
    fill(0, bombOpacity);
    if (bombOpacity == 0) {
      noStroke();
    }
    rect(x, y, w, h);
    fill(235, 109, 30, explosionOpacity);
    noStroke();
    circle(x + w, y + h, explosionRadius);
    stroke(1);
    if (explosionOpacity <= 0) {
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

//-----------------------------C4 bomb---------------------------------

class C4 extends Bomb
{
  boolean bombActivated;

  C4(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    bombActivated = false;
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

  public void update() {
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

  Landmine(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    enemyOverlaps = false;
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
  public void update() {
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
          ((Entity)entity).insideExplosion = true;
        }
      }
    }        
    for (Object wall : objectHandler.walls) {
      if ( !wall.equals(this) && wall.objectId == ObjectID.BBLOCK ) {
        if (circleRectangleOverlap(wall.x, wall.y, wall.w, wall.h)) {
          ((Entity)wall).insideExplosion = true;
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
class SpiderBomb extends Object {

  int bombTimer = EXPLOSION_TIMER;
  int bombOpacity = BOMB_START_OPACITY;
  int startTime;
  int explosionOpacity = EXPLOSION_START_OPACITY;
  int explosionRadius = EXPLOSION_START_RADIUS;


  SpiderBomb(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, ObjectID.SPIDER_BOMB, objectHandler, sprites);
    startTime = millis();
  }

  public void ifTouching(Object crate) {
  }

  //Wanneer dynamiet explodeerd kijk hij of er enemy in de blastradius zit en paast dit door naar de enemy class
  //Explosie begint fel en neemt daarna af in opacity, wanneer deze nul is wordt hij verwijdert
  public void update() {
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
          ((Entity)player).insideExplosion = true;
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

  SpiderQueen(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.entityId = EntityID.SPIDER_BOSS;
  }

  public void update() {
  }

  public void draw() {
  }
}

class MovingWall extends Entity {

  MovingWall(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.entityId = EntityID.WALL_BOSS;
  }

  public void update() {
  }

  public void draw() {
  }
}
//Code credit Winand Metz

//Game
final float MAP_SCROLL_SPEED = 1;
final float MAP_OFFSET = 0;
final int LEVELS = 3;
//!NIET VERANDEREN!
final int TILE_SIZE = 128;
final int OBJECT_Y_OFFSET = 100;

//Graphics
final int FRAMERATE = 60;
final int FLOOR_SHADOW_STRENGTH = 230; //Normaliter ligt de waarde van deze en ENVIROMENT_SHADOW_STRENGHT dicht bij elkaar
final int ENVIROMENT_SHADOW_STRENGHT = 230;
final int RAY_DISTANCE = 500;

//HighScores
final int TIME_SCORE = 10;
final int TIME_SCORE_TIMER = 1;  //in sec

//Coin
final int COIN_SCORE = 20;

//Player
final int PLAYER_X_SPAWN = 0;
final int PLAYER_Y_SPAWN = 156;
final int PLAYER_HEALTH = 3;
final int PLAYER_SPEED = 4;
//!NIET VERANDEREN!
final int PLAYER_SIZE = TILE_SIZE / 2;

//Bombs
final int EXPLOSION_TIMER = 2000;
final int BOMB_START_OPACITY = 255;
final int EXPLOSION_START_OPACITY = 255;
final int EXPLOSION_START_RADIUS = 0;
final int BOMB_DAMAGE = 3;
final int BOMB_SIZE = 32;
final int BOMB_COOLDOWN_TIME = 60;

//Blocks
final int BBLOCK_HEALTH = 1;

//Entities
final int PLAYER_DETECTION_DISTANCE = 400;
final int ENTITY_SIZE_DIVIDER = 2;

//Ghost
final int GHOST_HEALTH = 4;
final int GHOST_ROAMING = 3000;
final int GHOST_MOVEMENT_SPEED = 2;

//Poltergeist
final int POLTERGEIST_HEALTH = 4;
final int POLTERGEIST_ROAMING = 3000;
final int POLTERGEIST_MOVEMENT_SPEED = 2;

//Mummy
final int MUMMY_HEALTH = 3;
final int MUMMY_ROAMING = 2000;
final int MUMMY_MOVEMENT_SPEED = 1;

//SMummy
final int SMUMMY_HEALTH = 3;
final int SMUMMY_ROAMING = 2000;
final int SMUMMY_MOVEMENT_SPEED = 1;
final int SMUMMY_SHIELD = 1;

//Spider
final int SPIDER_HEALTH = 1;
final int SPIDER_ROAMING = 1000;
final int SPIDER_MOVEMENT_SPEED = 3;

//ExplosiveSpider
final int EXPLOSIVE_SPIDER_HEALTH = 1;
final int EXPLOSIVE_SPIDER_ROAMING = 1000;
final int EXPLOSIVE_SPIDER_MOVEMENT_SPEED = 3;
//Code credit Jordy Post, Winand Metz, Ruben Verheul, Ole Neuman

class Entity extends Object {

  int health;
  int roamingTimer;
  int savedTime;
  int speedX;
  int speedY;
  int velX;
  int velY;
  float oldX, oldY;

  boolean insideExplosion = false;
  boolean touching = false;

  Entity(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, ObjectID.ENTITY, objectHandler, sprites);
    savedTime = millis();
  }

  //Nieuw collision system waarbij hij terug wordt gezet naar de oude positie
  public void update() {
    movement();

    x = x + speedX;
    y = y + speedY;

    if (collisionDetection()) {
      x = oldX - MAP_SCROLL_SPEED;
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

  //Method voor basic volgen van de player
  //Moet nog in dat hij om muren heen navigeert (of je niet ziet achter de muren?)
  public void hunt() {
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

  public void ifTouching(Object crate) {
  }

  public void draw() {
    //fill(20);
    //rect(x, y, w, h);
  }
}
//Code credit Winand Metz

//Alles game gerelateerd
class Game {
  ObjectHandler objectHandler;
  MapHandler mapHandler;
  TextureAssets textureLoader;
  Player player;
  Highscore highscore;
  GraphicsEngine graphicsEngine;
  UserInterface userInterface;

  final int width, height;

  //Inladen van alle assets voor de game en level creation dmv inladen van een png map, op basis van pixels plaatsing van objecten
  //TileSize is grote van de blokken in het plaatsingsgrid (tegelgrote)
  Game(int tileSize, int width, int height) {
    this.width =  width;
    this.height = height;
    textureLoader = new TextureAssets(tileSize);
    highscore = new Highscore();
    objectHandler = new ObjectHandler(this.textureLoader);
    objectHandler.addPlayer(this.highscore);
    mapHandler = new MapHandler(tileSize);
    graphicsEngine = new GraphicsEngine();
    userInterface = new UserInterface(this.textureLoader, this.player, this.highscore);
  }

  //Oproepen van objecten in de game zodat ze worden getekend
  public void update() {
    mapHandler.update();
    objectHandler.update();
    highscore.update();
    userInterface.update();
    graphicsEngine.update();
  }

  public void draw() {
    background(128);
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
}

//-----------------------------Highscore---------------------------------

class Highscore {
  int score, timeScore, timer;
  Timer scoreTimer;
  boolean tempGameOver;
  boolean scoreAdded;
  //MySQLConnection myConnection;
  //Table highscores;
  int userId;

  Highscore() {
    //myConnection = new MySQLConnection("verheur6", "od93cCRbyqVu5R1M", "jdbc:mysql://oege.ie.hva.nl/zverheur6");
    //highscores = myConnection.getTable("Highscore");
    //highscores = myConnection.runQuery("SELECT User_id, score FROM Highscore ORDER BY `score` DESC");
    score = 0;
    timeScore = TIME_SCORE;
    timer = FRAMERATE * TIME_SCORE_TIMER;
    scoreTimer = new Timer();
    tempGameOver = false;
    scoreAdded = false;
  }

  //iedere sec komt er score bij
  public void update() {
    if (tempGameOver == false) {
      if (scoreTimer.startTimer(timer)) {
        score += timeScore;
      }
    } else {
      // als gameover true is en de highscores nog niet geupdate zijn worden de scores geupdate
      if (scoreAdded == false) {
        updateHighscores();
      }
    }
  }
  
  //update de highscorelist
  public void updateHighscores() {
    //als het een nieuwe hoogste score is
    //highscores = myConnection.runQuery("INSERT INTO `Highscore`(`user_id`, `score`) VALUES ("+ userId + "," + score + ");");
    score = 0;
    scoreAdded = true;
  }
  
  //als je buiten deze class score wilt toevoegen
  public void addScore(int amount) {
    score += amount;
  }
}
//Code credit Jordy Post, Winand Metz, Ruben Verheul

class Ghost extends Entity {

  int health = GHOST_HEALTH;
  int roamingTimer = GHOST_ROAMING;
  int velX = GHOST_MOVEMENT_SPEED;
  int velY = GHOST_MOVEMENT_SPEED;

  Ghost(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.entityId = EntityID.GHOST;
    savedTime = millis();
  }

  public void update() {
    bombDamage();
    movement();

    x = x + speedX;
    y = y + speedY;

    if (rockCollisionDetection()) {
      x = oldX - MAP_SCROLL_SPEED;
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
        savedTime = millis();
      }
    }
  }

  //Method voor destruction
  public void bombDamage() {
    if (insideExplosion) {
      health -= BOMB_DAMAGE;
      insideExplosion = false;
    }
    if (health <= 0) {
      objectHandler.removeEntity(this);
    }
  }

  public void hunt() {
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

  public void draw() {
    fill(225);
    rect(x, y, w, h);
  }
}

//-----------------------------Special ghost---------------------------------

//Code credit Ruben Verheul
class Poltergeist extends Entity {
  int heath = POLTERGEIST_HEALTH;
  int roamingTimer = POLTERGEIST_ROAMING;
  int velX = POLTERGEIST_MOVEMENT_SPEED;
  int velY = POLTERGEIST_MOVEMENT_SPEED;

  Poltergeist(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.entityId = EntityID.POLTERGEIST;
    savedTime = millis();
  }

  public void update() {
    bombDamage();
    movement();

    x = x + speedX;
    y = y + speedY;

    if (rockCollisionDetection()) {
      x = oldX - MAP_SCROLL_SPEED;
      y = oldY;
    }
    oldX = x;
    oldY = y;
  }

  public void movement() {

    int passedTime = millis() - savedTime;
    if (dist(getPlayerX(), getPlayerY(), x, y) < PLAYER_DETECTION_DISTANCE) {
      hunt();
    } else {
      if (passedTime > roamingTimer) {
        speedX = velX * randomOnes();
        speedY = velY * randomOnes();
        savedTime = millis();
      }
    }
  }

  public void bombDamage() {
    if (insideExplosion) {
      health -= BOMB_DAMAGE;
      insideExplosion = false;
    }
    if (health <= 0) {
      objectHandler.removeEntity(this);
    }
  }

  public void hunt() {
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
  public void draw() {
    fill(200);
    rect(x, y, w, h);
  }
}
class Item extends Object {

  Item(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, ObjectID.ITEM, objectHandler, sprites);
  }

  public void update() {
  }

  public void draw() {
  }

  public void ifTouching(Object crate) {
  }
}

class Boots extends Item {

  Boots(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.itemId = ItemID.BOOTS;
  }

  public void update() {
  }

  public void draw() {
    fill(128, 128, 0);
    rect(x, y, w, h);
  }
}

class Sparkler extends Item {

  Sparkler(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.itemId = ItemID.SPARKLER;
  }

  public void update() {
  }

  public void draw() {
    fill(128, 128, 0);
    rect(x, y, w, h);
  }
}

class BluePotion extends Item {

  BluePotion(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.itemId = ItemID.BPOTION;
  }

  public void update() {
  }

  public void draw() {
    fill(128, 128, 0);
    rect(x, y, w, h);
  }
}

class Shield extends Item {

  Shield(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.itemId = ItemID.SHIELD;
  }

  public void update() {
  }

  public void draw() {
    fill(128, 128, 0);
    rect(x, y, w, h);
  }
}

class Cloak extends Item {

  Cloak(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.itemId = ItemID.CLOAK;
  }

  public void update() {
  }

  public void draw() {
    fill(128, 128, 0);
    rect(x, y, w, h);
  }
}

class Heart extends Item {

  Heart(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.itemId = ItemID.HEART;
  }

  public void update() {
  }

  public void draw() {
    fill(128, 128, 0);
    rect(x, y, w, h);
  }
}

class Coin extends Item {
  Coin(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.itemId = ItemID.COIN;
  }
  
  public void update() {
  }

  public void draw() {
    fill(255, 200, 0);
    rect(x, y, w, h);
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
    if (keysPressed[27]) return true;
    return false;
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
    this.pos.set(x + 10, y + 10);
    /*Zoekt van de Wall en Rock objecten alle hoekpunten op
     Schiet hier een ray naar toe met elk twee extra rays die net zijonder en zijboven zitten van de orginele ray
     Dit helpt met de vloeiendheid wanneer de emitter beweegt en de schaduwen van plek veranderen*/
    for (Object object : objectHandler.walls) {
      if (object.objectId == ObjectID.WALL || object.objectId == ObjectID.ROCK) {
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
        if (object.objectId == ObjectID.WALL || object.objectId == ObjectID.ROCK) { //Safe wall dat hij alleen de waardes pakt van Wall en Rock
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
 
  PImage newMap; 
  int tileSize; 
  float mapScrollSpeed; 
  float mapPositionTracker; 
  float offSet; 
  int mapAmount; 
 
  MapHandler(int sizeOfTiles) { 
    mapPositionTracker = 0; 
    tileSize = sizeOfTiles; 
    mapScrollSpeed = MAP_SCROLL_SPEED; 
    offSet = MAP_OFFSET; 
    mapAmount = LEVELS; 
  } 
 
  public void update() { 
    mapPositionTracker -= mapScrollSpeed; 
    if (mapPositionTracker <= 0) {  
      generateMap(game.objectHandler); 
      //println("Generating new map"); 
    } 
  } 
 
  public void generateMap(ObjectHandler objectHandler) { 
    loadMapImage(); 
    loadMap(newMap.pixels, newMap.width, newMap.height, tileSize, tileSize, objectHandler, offSet);
    mapPositionTracker += offSet; 
    //println("mapWidth = " + newMap.width); 
    offSet = newMap.width * tileSize; 
    //println("offSet = " + offSet); 
  } 
 
  public void loadMapImage() { 
    int mapFileNumber = PApplet.parseInt(random(1, mapAmount)); 
    newMap = loadImage("data/maps/map" + mapFileNumber + ".png"); 
    newMap.loadPixels(); 
  } 
}

//Code credit Winand Metz
//Het bepalen van de plaatsing van objecten in het level dmv aflezen pixel colorcodes(android graphics color) en dit omzetten in een grid van 15 bij 8
public void loadMap(int[] pixels, int w, int h, int tw, int th, ObjectHandler objectHandler, float offSet) {
  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++ ) {
      int loc = x + y * w;
      float c = pixels[loc];
      //Hexcode = 7f0622
      if (c == 0xFF7F0622) {
        objectHandler.addWall(x * tw + offSet, y * th, tw, th);
      }
      //Hexode = 000000
      if (c == 0xFF000000) {
        objectHandler.addSpider(x * tw + offSet, y * th, tw, th);
      }
      //Hexode = 00a0c8
      if (c == 0xFF00a0c8) {
        objectHandler.addGhost(x * tw + offSet, y * th, tw, th);
      }
      //Hexcode = ffdf8f
      if (c == 0xFFffdf8f) {
        //objectHandler.addMummy(x * tw + offSet, y * th, tw, th);
        objectHandler.addBreakableWall(x * tw + offSet, y * th, tw, th);
      }
      //Hexcode = E4B6AD
      if (c == 0xFFE4B6AD) {
        objectHandler.addPoltergeist(x * tw + offSet, y * th, tw, th);
      }
      //Hexcode = 515151
      if (c == 0xFF515151) {
        objectHandler.addRock(x * tw + offSet, y * th, tw, th);
      }
    }
  }
}
//Code credit Jordy Post, Winand Metz, Ruben Verheul, Ole Neuman

class Mummy extends Entity {

  int health = MUMMY_HEALTH;
  int roamingTimer = MUMMY_ROAMING;
  int velX = MUMMY_MOVEMENT_SPEED;
  int velY = MUMMY_MOVEMENT_SPEED;

  Mummy(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.entityId = EntityID.MUMMY;
    savedTime = millis();
  }

  public void update() {
    movement();
    bombDamage();

    x = x + speedX;
    y = y + speedY;

    if (collisionDetection()) {
      x = oldX - MAP_SCROLL_SPEED;
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
    if (dist(getPlayerX(), getPlayerY(), x, y) < PLAYER_DETECTION_DISTANCE) {
      hunt();
    } else {
      if (passedTime > roamingTimer) {
        speedX = velX * randomOnes();
        speedY = velY * randomOnes();
        savedTime = millis();
      }
    }
  }

  //Method voor destruction
  public void bombDamage() {
    if (insideExplosion) {
      health -= BOMB_DAMAGE;
      insideExplosion = false;
    }
    if (health <= 0) {
      objectHandler.removeEntity(this);
    }
  }

  public void hunt() {
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

  public void draw() {
    //println(health);
    fill(128);
    rect(x, y, w, h);
  }
}

//-----------------------------Special mummy---------------------------------

//Code credit Jordy Post
class SMummy extends Mummy {

  int shield;

  SMummy(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.entityId = EntityID.SMUMMY;
    savedTime = millis();
    shield = SMUMMY_SHIELD;
  }

  //Method voor destruction
  public void bombDamage() {
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
    fill(158);
    rect(x, y, w, h);
  }
}
//Code credit Winand Metz

//Kan gebruikt worden in schrijven van collision methods, maar ook andere scripting usages, eigenlijk andere manier van classes, game objecten, oproepen
enum ObjectID {
  WALL, PLAYER, ENTITY, BOMB, SPIDER_BOMB, ROCK, BBLOCK, ITEM
}

enum ItemID {
  BOOTS, SPARKLER, BPOTION, SHIELD, CLOAK, HEART, COIN
}

enum EntityID {
  GHOST, MUMMY, SMUMMY, SPIDER, EXPLOSIVE_SPIDER, POLTERGEIST, SPIDER_BOSS, WALL_BOSS
}

//Basis class voor alle gameobjecten
abstract class Object {

  PVector lb, rb, ro, lo, or, left, right, up, down;

  float x, y;
  int w, h;
  ObjectID objectId;
  ItemID itemId;
  EntityID entityId;
  ObjectHandler objectHandler;
  TextureAssets sprites;

  Object(float x, float y, int w, int h, ObjectID objectId, ObjectHandler objectHandler, TextureAssets sprites) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.objectId = objectId;
    this.objectHandler = objectHandler;
    this.sprites = sprites;
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

  public abstract void ifTouching(Object crate);

  public void moveMap() { 
    x -= MAP_SCROLL_SPEED;
  } 

  public void getVector() {
    lb.set(x, y);
    rb.set(x + w, y);
    ro.set(x + w, y + h);
    lo.set(x, y + h);
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

  //Geeft aan of twee objecten met elkaar kruizen, is niet echt bruikbaar buiten een crawler
  public boolean intersection(Object other) {
    return other.w > 0 && other.h > 0 && w > 0 && h > 0
      && other.x < x + w && other.x + other.w > x
      && other.y < y + h && other.y + other.h > y;
  }

  //Gebruikt bovenstaande methode om te kijken of objecten elkaar doorkruizen
  //Zal kijken of ik nog een kan schrijven die ook de objectID's erbij betrekt, zodat je specifieke collision kan vinden
  public boolean collisionDetection() {
    ArrayList<Object> entityObjects = objectHandler.entities;
    ArrayList<Object> wallObjects = objectHandler.walls;
    for (int i = 0; i < entityObjects.size(); i++) {
      for (int j = 0; j < wallObjects.size(); j++) {
        Object wallObject = wallObjects.get(j);
        Object entityObject = entityObjects.get(i);
        if (!entityObject.equals(this) && intersection(wallObject) && entityObject.objectId != ObjectID.BOMB && entityObject.entityId != EntityID.GHOST) {
          return true;
        }
      }
    }
    return false;
  }

  public boolean rockCollisionDetection() {
    ArrayList<Object> entityObjects = objectHandler.entities;
    ArrayList<Object> wallObjects = objectHandler.walls;
    for (int i = 0; i < entityObjects.size(); i++) {
      for (int j = 0; j < wallObjects.size(); j++) {
        Object wallObject = wallObjects.get(j);
        Object entityObject = entityObjects.get(i);
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

  int eSD = ENTITY_SIZE_DIVIDER;

  ArrayList<Object> walls =  new ArrayList<Object>();
  ArrayList<Object> entities = new ArrayList<Object>();

  Player player = null;

  TextureAssets sprites;

  ObjectHandler(TextureAssets sprites) {
    this.sprites = sprites;
  }

  //Method voor het creëren van de muren, input lijkt me vanzelf sprekend
  public void addWall(float x, float y, int w, int h) {
    Wall wall = new Wall(x, y - OBJECT_Y_OFFSET, w, h, this, sprites);
    walls.add(wall);
  }

  //Method voor de rockwall onder- en bovenkant van het scherm 
  public void addRock(float x, float y, int w, int h) {
    Rock rock = new Rock(x, y - OBJECT_Y_OFFSET, w, h, this, sprites);
    walls.add(rock);
  }

  public void addBreakableWall(float x, float y, int w, int h) {
    BreakableBlock breakableBlock = new BreakableBlock(x, y - OBJECT_Y_OFFSET, w, h, this, sprites);
    walls.add(breakableBlock);
  }

  //Method voor plaatsen van de player
  public void addPlayer(Highscore highscore) {
    Player player = new Player(PLAYER_X_SPAWN, PLAYER_Y_SPAWN, PLAYER_SIZE, PLAYER_SIZE, this, sprites, highscore);
    entities.add(player);
    println("spawned");
  }

  //Method voor plaatsen Ghosts
  public void addGhost(float x, float y, int w, int h) {
    Ghost ghost = new Ghost(x, y - OBJECT_Y_OFFSET, w / eSD, h / eSD, this, sprites);
    entities.add(ghost);
  }

  //Method voor plaatsen Poltergeists
  public void addPoltergeist(float x, float y, int w, int h) {
    Poltergeist poltergeist = new Poltergeist(x, y - OBJECT_Y_OFFSET, w / eSD, h / eSD, this, sprites);
    entities.add(poltergeist);
  }

  //Method voor plaatsen Mummies
  public void addMummy(float x, float y, int w, int h) {
    Mummy mummy = new Mummy(x, y - OBJECT_Y_OFFSET, w / eSD, h / eSD, this, sprites);
    entities.add(mummy);
  }

  //Method voor plaatsen SMummies
  public void addSMummy(float x, float y, int w, int h) {
    SMummy sMummy = new SMummy(x, y - OBJECT_Y_OFFSET, w / eSD, h / eSD, this, sprites);
    entities.add(sMummy);
  }

  //Method voor plaatsen van Spiders
  public void addSpider(float x, float y, int w, int h) {
    Spider spider = new Spider(x, y - OBJECT_Y_OFFSET, w / eSD, h / eSD, this, sprites);
    entities.add(spider);
  }

  //Method voor plaatsen Explosive_Spiders
  public void addExplosiveSpider(float x, float y, int w, int h) {
    ExplosiveSpider explosiveSpider = new ExplosiveSpider(x, y - OBJECT_Y_OFFSET, w / eSD, h / eSD, this, sprites);
    entities.add(explosiveSpider);
  }

  //Method voor plaatsen van een Bomb
  public void addBomb(float x, float y, int w, int h) {
    Bomb bomb = new Bomb(x, y, w / eSD, h / eSD, this, sprites);
    entities.add(bomb);
  }

  public void addC4(float x, float y, int w, int h) {
    C4 c4 = new C4(x, y, w / eSD, h / eSD, this, sprites);
    entities.add(c4);
  }

  public void addLandmine(float x, float y, int w, int h) {
    Landmine landmine = new Landmine(x, y, w / eSD, h / eSD, this, sprites);
    entities.add(landmine);
  }

  //Method voor plaatsen van een SpiderBomb
  public void addSpiderBomb(float x, float y, int w, int h) {
    SpiderBomb spiderBomb = new SpiderBomb(x, y, w / eSD, h / eSD, this, sprites);
    entities.add(spiderBomb);
  }

  public void addBoots(float x, float y, int w, int h) {
    Boots boots = new Boots(x, y, w / eSD, h / eSD, this, sprites);
    entities.add(boots);
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
      //entityObjects.get(i).getVector();
    }

    ArrayList<Object> wallObjects = walls;
    for (int i = 0; i < wallObjects.size(); i++) {
      if (i >= wallObjects.size()) {
        break;
      }
      wallObjects.get(i).moveMap();
      wallObjects.get(i).update();
      wallObjects.get(i).getVector();
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

  boolean speedBonus = false;
  boolean start = true;

  int speedX, speedY, startTime;
  int speedBonusTimer = 1000;
  int velX = PLAYER_SPEED;
  int velY = PLAYER_SPEED;
  int health = PLAYER_HEALTH;
  float oldX, oldY;
  int bombCooldown = 0;

  Player(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, Highscore highscore) {
    super(x, y, w, h, ObjectID.PLAYER, objectHandler, sprites);
    timer = new Timer();
    this.highscore = highscore;
  }

  public void update() {
    playerControls();
    powerUpDetection();
    powerUps();

    if (speedX != 0) {
      speedY = 0;
    } else if (speedY != 0) {
      speedX = 0;
    }

    x = x + speedX;
    y = y + speedY;

    if (collisionDetection()) {
      x = oldX - MAP_SCROLL_SPEED;
      y = oldY;
    }

    oldX = x;
    oldY = y;

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
    if (input.zDown() && bombCooldown == 0) {
      objectHandler.addBomb(x + w / 4, y + h / 4, BOMB_SIZE, BOMB_SIZE);
      bombCooldown = BOMB_COOLDOWN_TIME;
    }
    if (input.sDown()&& bombCooldown == 0) {
      objectHandler.addC4(x + w / 4, y + h / 4, BOMB_SIZE, BOMB_SIZE);
      bombCooldown = BOMB_COOLDOWN_TIME;
    }
    if (input.aDown()&& bombCooldown == 0) {
      objectHandler.addLandmine(x + w / 4, y + h / 4, BOMB_SIZE, BOMB_SIZE);
      bombCooldown = BOMB_COOLDOWN_TIME;
    }
  }

  public void ifTouching(Object crate) {
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
  }

  public void powerUpDetection() {
    ArrayList<Object> objects = objectHandler.entities;
    for (int i = 0; i < objects.size(); i++) {
      Object item = objects.get(i);
      if (!item.equals(this) && intersection(item) && item.itemId == ItemID.BOOTS) {
        println("NYOOM");
        velX += 2;
        velY += 2;
        speedBonus = true;
        objectHandler.removeEntity(item);
      }
      
      if (!item.equals(this) && intersection(item) && item.itemId == ItemID.COIN) {
        highscore.addScore(COIN_SCORE);
        objectHandler.removeEntity(item);
      }
    }
  }

  public void draw() {
    //rect(x, y, w, h);
    image(sprites.getPlayer(), x, y);
  }
}

//Code credit Jordy Post, Winand Metz, Ruben Verheul, Ole Neuman

class Spider extends Entity {

  int health = SPIDER_HEALTH;
  int roamingTimer = SPIDER_ROAMING;
  int velX = SPIDER_MOVEMENT_SPEED ;
  int velY = SPIDER_MOVEMENT_SPEED ;

  Spider(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.entityId = EntityID.SPIDER;
    savedTime = millis();
  }

  public void update() {
    movement();
    bombDamage();
    x = x + speedX;
    y = y + speedY;

    if (collisionDetection()) {
      x = oldX - MAP_SCROLL_SPEED;
      y = oldY;
    }

    oldX = x;
    oldY = y;
  }

  //Method voor destruction
  public void bombDamage() {
    if (insideExplosion) {
      health -= BOMB_DAMAGE;
      insideExplosion = false;
    }
    if (health <= 0) {
      objectHandler.removeEntity(this);
    }
  }

  public void movement() {
    //Timer voor basic willekeurig ronddwalen over speelveld elke twe seconden gaat hij andere kant op
    //Zodra hij binnen 400 pixels van de player komt gaat hij achter de player aan
    //Moet nog in dat hij om muren heen navigeert ipv tegenaanstoot en stil staat
    int passedTime = millis() - savedTime;
    if (dist(getPlayerX(), getPlayerY(), x, y) < PLAYER_DETECTION_DISTANCE) {
      hunt();
    } else {
      if (passedTime > roamingTimer) {
        speedX = velX * randomOnes();
        speedY = velY * randomOnes();
        savedTime = millis();
      }
    }
  }

  public void hunt() {
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

  public void draw() {
    fill(32);
    rect(x, y, w, h);
  }
}

//-----------------------------Special spider---------------------------------

class ExplosiveSpider extends Entity{
  
  int health = EXPLOSIVE_SPIDER_HEALTH;
  int roamingTimer = EXPLOSIVE_SPIDER_ROAMING;
  int velX = EXPLOSIVE_SPIDER_MOVEMENT_SPEED;
  int velY = EXPLOSIVE_SPIDER_MOVEMENT_SPEED;
  
  ExplosiveSpider(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.entityId = EntityID.EXPLOSIVE_SPIDER;
    savedTime = millis();
  }
  
  public void update() {
    movement();
    bombDamage();
    x = x + speedX;
    y = y + speedY;
    
    if (collisionDetection()) {
      x = oldX - MAP_SCROLL_SPEED;
      y = oldY;
    }
    
    oldX = x;
    oldY = y;
  }
  
  public void bombDamage() {
    if (insideExplosion) {
      health -= BOMB_DAMAGE;
      insideExplosion = false;
    }
    if (health <= 0) {
      objectHandler.addSpiderBomb(x + w / 4, y + h / 4, BOMB_SIZE, BOMB_SIZE);
      objectHandler.removeEntity(this);
    }
  }
  
  public void movement() {
    int passedTime = millis() - savedTime;
    if (dist(getPlayerX(), getPlayerY(), x, y) < PLAYER_DETECTION_DISTANCE) {
      hunt();
    } else {
      if (passedTime > roamingTimer) {
        speedX = velX * randomOnes();
        speedY = velY * randomOnes();
        savedTime = millis();
      }
    }
  }
  
  public void hunt() {
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
      speedY = velY;
    }
    if (getPlayerX() < x && getPlayerY() > y) {
      speedX = -velX;
      speedY = velY;
    }
  }
  
  public void draw() {
    fill(174);
    rect(x, y, w, h);
  }
}
class UserInterface {
  TextureAssets assetLoader;
  Player player;
  Highscore highscore;

  UserInterface(TextureAssets assetLoader, Player player, Highscore highScore) {
    this.assetLoader = assetLoader;
    this.player = player;
    this.highscore = highScore;
  }

  public void update() {
  }

  public void draw() {
  }
}
  public void settings() {  size(1920, 1080, P2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "BombsMain" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
