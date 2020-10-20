import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class BombsMain extends PApplet {

//Porject FYS Winand Metz 500851135, Ole Neuman 500827044, 
//Ruben Verheul 500855129, Jordy Post 500846919, Alex Tarnòki 500798826

//Code credit Winand Metz, Ole Neuman

//Voor main menu etc
Game game;
InputHandler input;

final int KEY_LIMIT = 1024;
boolean[] keysPressed = new boolean[KEY_LIMIT];

public void setup() {
  
  frameRate(60);
  game = new Game(128, width, height);
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

//Muren, moet nog collision op
class Wall extends Object {
  Wall(int x, int y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super(x, y, w, h, ObjectID.WALL, objectHandler, sprites);
  }

  public void ifTouching(Object crate) {
  }

  public void update() {
  }

  //Inladen van de texture voor de muur en plaatsing
  public void draw() {
    image(sprites.getWall(), x, y);
  }
}

//Breekbare blocks, alles moet nog 
class BreakableBlocks extends Object {
  BreakableBlocks(int x, int y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super(x, y, w, h, ObjectID.BBLOCKS, objectHandler, sprites);
  }

  public void ifTouching(Object crate) {
  }

  public void update() {
  }

  public void draw() {
  }
}

//Onder en boven muren
class Rock extends Object {
  Rock(int x, int y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super(x, y, w, h, ObjectID.ROCK, objectHandler, sprites);
  }

  public void ifTouching(Object crate) {
  }

  public void update() {
  }

  public void draw() {
    image(sprites.getWall(), x, y);
  }
}
//Code credit Alex Tarnòki, Ole Neuman

class Bomb extends Object {

  int bombTimer = 5000;
  int bombOpacity = 255;
  int startTime;
  int explosionOpacity = 255;
  int explosionRadius = 0;
  int damage = 5;


  Bomb(int x, int y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super (x, y, w, h, ObjectID.BOMB, objectHandler, sprites);
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
      if (explosionOpacity <= 0) {
        objectHandler.removeEntry(this);
      }
    }
  }

  public void draw() {
    fill(0, bombOpacity);
    if (bombOpacity == 0) noStroke();
    rect(x, y, 32, 32);
    fill(235, 109, 30, explosionOpacity);
    noStroke();
    circle(x + w, y + h, explosionRadius);
    stroke(1);
  }

  //Kijkt of object een enemy is
  public void enemyDetection() {
    for (Object enemy : objectHandler.entries) {
      if ( !enemy.equals(this) && enemy.objectId == ObjectID.ENEMY) {
        if (circleRectangleOverlap(enemy.x, enemy.y, enemy.w, enemy.h)) {
          ((Enemy)enemy).insideExplosion = true;
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
//Code credit Jordy Post, Winand Metz, Ruben Verheul, Ole Neuman

//Main Enemy class voor Ghost, Spider, Mummy
class Enemy extends Object {

  int health;
  int roamingTimer;
  int speedX;
  int speedY;
  int velX;
  int velY;
  int savedTime;
  int oldX, oldY;

  boolean insideExplosion = false;
  boolean touching = false;

  Enemy(int x, int y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super(x, y, w, h, ObjectID.ENEMY, objectHandler, sprites);
    savedTime = millis();
  }

  //Nieuw collision system waarbij hij terug wordt gezet naar de oude positie
  public void update() {
    movement();

    x = x + speedX;
    y = y + speedY;

    if (collisionDetection()) {
      x = oldX;
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
        speedX = velX * randomSignum();
        speedY = velY * randomSignum();
        savedTime = millis();
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
    fill(20);
    rect(x, y, w, h);
  }
}
//Code credit Winand Metz

//Alles game gerelateerd
class Game {
  ObjectHandler objectHandler;
  Sprites sprites;

  final int width, height;

  //Inladen van alle assets voor de game en level creation dmv inladen van een png map, op basis van pixels plaatsing van objecten
  //TileSize is grote van de blokken in het plaatsingsgrid (tegelgrote)
  Game(int tileSize, int width, int height) {
    this.width =  width;
    this.height = height;
    sprites = new Sprites("data/text/textures.png", tileSize);
    objectHandler = new ObjectHandler(this.sprites);
    PImage map = loadImage("data/maps/map1.png");
    objectHandler.addPlayer();
    map.loadPixels();
    loadMap(map.pixels, map.width, map.height, tileSize, tileSize, this.objectHandler);
  }

  //Oproepen van objecten in de game zodat ze worden getekend
  public void update() {
    objectHandler.update();
  }

  public void draw() {
    background(128);
    objectHandler.draw();
  }
}

//Het bepalen van de plaatsing van objecten in het level dmv aflezen pixel colorcodes(android graphics color) en dit omzetten in een grid van 15 bij 8
public void loadMap(int[] pixels, int w, int h, int tw, int th, ObjectHandler objectHandler) {
  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++ ) {
      int loc = x + y * w;
      float c = pixels[loc];
      //Hexcode = 7f0622
      if (c == 0xFF7F0622) {
        objectHandler.addWall(x * tw, y * th, tw, th);
      }
      //Hexode = 000000
      if (c == 0xFF000000) {
        objectHandler.addSpider(x * tw, y * th, tw, th);
      }
      //Hexode = 00a0c8
      if (c == 0xFF00a0c8) {
        objectHandler.addGhost(x * tw, y * th, tw, th);
      }
      //Hexcode = ffdf8f
      if (c == 0xFFffdf8f) {
        objectHandler.addMummy(x * tw, y * th, tw, th);
      }
      //Hexcode = 515151
      if (c == 0xFF515151) {
        objectHandler.addRock(x * tw, y * th, tw, th);
      }
    }
  }
}
//Code credit Jordy Post, Winand Metz, Ruben Verheul

class Ghost extends Enemy {

  int health = 20;
  int roamingTimer = 3000;
  int velX = 2;
  int velY = 2;

  Ghost(int x, int y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super(x, y, w, h, objectHandler, sprites);
    savedTime = millis();
  }

  public void update() {
    bombDamage();
    movement();

    x = x + speedX;
    y = y + speedY;
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
        speedX = velX * randomSignum();
        speedY = velY * randomSignum();
        savedTime = millis();
      }
    }
  }

  //Method voor destruction
  public void bombDamage() {
    if (insideExplosion) {
      health -= 2;
      insideExplosion = false;
    }
    if (health <= 0) {
      objectHandler.removeEntry(this);
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
//Code credit Ole Neuman

/* Hierin beschrijven wat alle keys doen dus up, down, left, right, a, z, s, x, escape
 dus dan hoef je alleen method op te roepen voor true of false */
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
//Code credit Winand

//Random getal van -1 tot 1
public int randomSignum() {
  return (int) random(3) - 1;
}
//Code credit Jordy Post, Winand Metz, Ruben Verheul, Ole Neuman

class Mummy extends Enemy {

  int health = 3;
  int roamingTimer = 2000;
  int velX = 1;
  int velY = 1;

  Mummy(int x, int y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super(x, y, w, h, objectHandler, sprites);
    savedTime = millis();
  }

  public void update() {
    movement();
    bombDamage();

    x = x + speedX;
    y = y + speedY;

    if (collisionDetection()) {
      x = oldX;
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
        speedX = velX * randomSignum();
        speedY = velY * randomSignum();
        savedTime = millis();
      }
    }
  }

  //Method voor destruction
  public void bombDamage() {
    if (insideExplosion) {
      health -= 2;
      insideExplosion = false;
    }
    if (health <= 0) {
      objectHandler.removeEntry(this);
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
    println(health);
    fill(128);
    rect(x, y, w, h);
  }
}
//Code credit Winand Metz

//Basis class voor alle gameobjecten
abstract class Object {
  int x, y, w, h;
  ObjectID objectId;
  ObjectHandler objectHandler;
  Sprites sprites;

  Object(int x, int y, int w, int h, ObjectID objectId, ObjectHandler objectHandler, Sprites sprites) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.objectId = objectId;
    this.objectHandler = objectHandler;
    this.sprites = sprites;
  }

  public abstract void update();

  public abstract void draw();

  public abstract void ifTouching(Object crate);

  //Position crawler voor de player X
  //Gaat door de objecthandler z'n list heen en zoekt naar object met het ID player om vervolgens x op te vragen
  public int getPlayerX() {
    int pX = 0;
    ArrayList<Object> objects = this.objectHandler.entries;
    for (int i = 0; i < objects.size(); i++) {
      Object gameObject = objects.get(i);
      if (gameObject.objectId == ObjectID.PLAYER) {
        pX = gameObject.x;
      }
    }
    return pX;
  }

  //Position crawler voor de player Y
  public int getPlayerY() {
    int pY = 0;
    ArrayList<Object> objects = this.objectHandler.entries;
    for (int i = 0; i < objects.size(); i++) {
      Object gameObject = objects.get(i);
      if (gameObject.objectId == ObjectID.PLAYER) {
        pY = gameObject.y;
      }
    }
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
    ArrayList<Object> objects = this.objectHandler.entries;
    for (int i = 0; i < objects.size(); i++) {
      Object gameObject = objects.get(i);
      if (!gameObject.equals(this) && intersection(gameObject) && gameObject.objectId != ObjectID.BOMB) {
        return true;
      }
    }
    return false;
  }
}
//Code credit Winand Metz

//Class voor het creëren en opslaan van de objecten
class ObjectHandler {

  //Opzetten van object array voor muren en breekbare blocks
  ArrayList<Object> entries = new ArrayList<Object>();
  Player player = null;

  Sprites sprites;

  ObjectHandler(Sprites sprites) {
    this.sprites = sprites;
  }

  //Method voor het creëren van de muren, input lijkt me vanzelf sprekend
  public void addWall(int x, int y, int w, int h) {
    Wall wall = new Wall(x, y - 100, w, h, this, sprites);
    entries.add(wall);
  }

  //Method voor de rockwall onder- en bovenkant van het scherm 
  public void addRock(int x, int y, int w, int h) {
    Rock rock = new Rock(x, y - 100, w, h, this, sprites);
    entries.add(rock);
  }

  //Method voor plaatsen van de player
  public void addPlayer() {
    Player player = new Player(0, 156, 64, 64, this, sprites);
    entries.add(player);
    println("spawned");
  }

  //Method voor plaatsen Ghosts
  public void addGhost(int x, int y, int w, int h) {
    Ghost ghost = new Ghost(x, y - 100, w / 2, h / 2, this, sprites);
    entries.add(ghost);
  }

  //Method voor plaatsen Mummies
  public void addMummy(int x, int y, int w, int h) {
    Mummy mummy = new Mummy(x, y - 100, w / 2, h / 2, this, sprites);
    entries.add(mummy);
  }

  //Method voor plaatsen van Spiders
  public void addSpider(int x, int y, int w, int h) {
    Spider spider = new Spider(x, y - 100, w / 2, h / 2, this, sprites);
    entries.add(spider);
  }

  //Method voor plaatsen van een Bomb
  public void addBomb(int x, int y, int w, int h){
   Bomb bomb = new Bomb(x, y, w / 2, h / 2, this, sprites);
   entries.add(bomb);
  }
  //Method van verwijderen objecten uit array (not used , can be called in object child classes) 
  public void removeEntry(Object entry) {
    entries.remove(entry);
  }

  //Updates elke list entry
  public void update() {
    ArrayList<Object> objects = entries;
    for (int i = 0; i < objects.size(); i++) {
      if (i >= objects.size()) {
        break;
      }
      objects.get(i).update();
    }
  }

  //Draw method voor elk onderdeel in de list
  public void draw() {
    ArrayList<Object> objects = entries;
    for (int i = 0; i < objects.size(); i++) {
      if (i >= objects.size()) {
        break;
      }
      objects.get(i).draw();
    }
  }
}
//Code credit Winand Metz

//Kan gebruikt worden in schrijven van collision methods, maar ook andere scripting usages, eigenlijk andere manier van classes, game objecten, oproepen
enum ObjectID {
  WALL, BBLOCKS, PLAYER, ENEMY, BOMB, ROCK
}
//Code credit Ruben Verheul, Winand Metz

class Player extends Object {

  int speedX = 0;
  int speedY = 0;
  int velX = 2;
  int velY = 2;
  int health = 3;
  int oldX, oldY;
  int bombCooldown = 0;

  Player(int x, int y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super(x, y, w, h, ObjectID.PLAYER, objectHandler, sprites);
  }

  public void update() {
    playerControls();

    if (speedX != 0) {
      speedY = 0;
    } else if (speedY != 0) {
      speedX = 0;
    }

    x = x + speedX;
    y = y + speedY;

    if (collisionDetection()) {
      x = oldX;
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
      objectHandler.addBomb(x + w / 4, y + h / 4, 32, 32);
      bombCooldown = 60;
    }
  }

  public void ifTouching(Object crate) {
  }

  public void draw() {
    //rect(x, y, w, h);
    image(sprites.getPlayer(), x, y);
  }
}
//Code credit Jordy Post, Winand Metz, Ruben Verheul, Ole Neuman

class Spider extends Enemy {

  int health = 1;
  int roamingTimer = 1000;
  int velX = 3;
  int velY = 3;

  Spider(int x, int y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super(x, y, w, h, objectHandler, sprites);
    savedTime = millis();
  }

  public void update() {
    movement();
    bombDamage();
    x = x + speedX;
    y = y + speedY;

    if (collisionDetection()) {
      x = oldX;
      y = oldY;
    }

    oldX = x;
    oldY = y;
  }

  //Method voor destruction
  public void bombDamage() {
    if (insideExplosion) {
      health -= 2;
      insideExplosion = false;
    }
    if (health <= 0) {
      objectHandler.removeEntry(this);
    }
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
        speedX = velX * randomSignum();
        speedY = velY * randomSignum();
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
//Code credit Winand Metz

//Inladen en tijdelijk opslaan textures
class Sprites {

  //array voor x en y positie in grid
  final PImage[][] sprites;

  //Class neemt filepath in en de groote van de gridtegels
  Sprites(String path, int tileSize) {
    sprites = loadSprites(path, tileSize);
  }

  //Laden van de wall op x 0 en y 0, oftwel eerste vak van het grid met tiles van 128 by 128 pixels
  public PImage getWall() {
    return sprites[0][0];
  }

  public PImage getPlayer() {
    return sprites[1][1];
  }

  //functie voor het inladen van de verschillende textures in de array
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
//Misschien Herbruikbaar

//Voor opzoeken locaties van game objecten (Moet in object tab)
//void positionCrawler() {
//  ArrayList<Object> objects = entries;
//  for (int i = 0; i < objects.size(); i++) {
//    Object gameObject = objects.get(i);
//    if (gameObject.objectId == ObjectID.PLAYER) {
//      int pX = gameObject.get_x();
//      int pY = gameObject.get_y();
//      println("player x position = " + pX + ", y position = " + pY);
//    }
//  }
//}


//Voor inspawnen test enemy (Moet in objecthandler)
//void addEnemy(int x, int y, int w, int h) {
//  Enemy enemy = new Enemy(x, y - 100, w / 2, h / 2, this, sprites);
//  entries.add(enemy);
//}

//(Moet in game bij maploader)
//Hexcode = 
//if (c == 0xFF) {
//  objectHandler.addEnemy(x * tw, y * th, tw, th);
//}

//boolean goesBoom() {
//  ArrayList<Object> objects = this.objectHandler.entries;
//  for (int i = 0; i < objects.size(); i++) {
//    Object gameObject = objects.get(i);
//    if (!gameObject.equals(this) && intersection(gameObject) && gameObject.objectId == ObjectID.BOMB) {
//      return true;
//    }
//  }
//  return false;
//}
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
