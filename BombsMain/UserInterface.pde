class UserInterface {

  // de visual cooldown ui waardoor de player kan zien of de (activate) knop toegankelijk is
  int ActiveBlockX = width-150;
  int ActiveBlockY = height-130;
  int ActiveBlockWidth = 80;
  int ActiveBlockHeight = 35;

  // de visual cooldown ui voor de bomb dat na 1.5 seconden afgaat
  int cdBlockX = width-150;
  int cdBlockY = height-90;
  int cdBlockWidth = 80;
  float cdBlockHeight = 0;

  int cdBlockTransparency = 200;

  //de locatie van de blokjes over het beeldscherm. Voor elk verschillend bomb hun eigen blok.
  int ActiveuiBlockX = width-150;
  int ActiveuiBlockY = height-130;
  int ActiveuiBlockWidth = 80;
  int ActiveuiBlockHeight = 35;

  int uiBlockX = width-150;
  int uiBlockY = height-90;
  int uiBlockWidth =  80;
  int uiBlockHeight = 80;

  TextureAssets assetLoader;
  Player player;
  Highscore highscore;
  Cooldown cooldown;

  ActivateBomb activateBomb;
  HealthUI healthUI;
  PowerUPS powerUPS;
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
    cooldown = new Cooldown();
    activateBomb = new ActivateBomb();
    healthUI = new HealthUI();
    powerUPS = new PowerUPS();
  }

  void update() {
    ArrayList<Object> entityObjects = objectHandler.entities;
    Object playerEntity = entityObjects.get(0);

    //println(checkC4(entityObjects));

    bombCooldown = ((Player)playerEntity).bombCooldown;
    health = ((Player)playerEntity).health;
    shield = ((Player)playerEntity).shield;
    speedBonus = ((Player)playerEntity).speedBonus;
    sparklerBonus = ((Player)playerEntity).sparklerBonus;
    undefeatabaleBonus = ((Player)playerEntity).undefeatabaleBonus;
    shieldBonus = ((Player)playerEntity).shieldBonus;

    cooldown.update();
    healthUI.update();
  }

  void draw()
  {
  //  uiBlocks();
   // cooldown.display();
  //  activateBomb.display();
    healthUI.display();
    powerUPS.display();


    //Lives/armor is (0, 0) tot en met (3, 0), highscore is (0, 1) tot (0, 3)
    //Detonation device off is (4, 0) en on is (5, 0)
    //Hud bomb icons zijn C4(6, 0), dynamite(7, 0) en landmine(7, 1)

    //Landmine (0, 0), dynamite (1, 0), c4 (2, 0)

    //Z (0), x (2), s (4), a (6), on colum 7 (row, voor non-pressed, + 1 for pressed)
    //Esc on colum 6 (row 0, + 1 for pressed)

    // de stats blok
    image(textureAssets.getUserHud(0, 0), 0, height-125);
    image(textureAssets.getUserHud(1, 0), 128, height-125);
    image(textureAssets.getUserHud(2, 0), 256, height-125);
    image(textureAssets.getUserHud(3, 0), 384, height-125);

    //de highscore blok
    image(textureAssets.getUserHud(0, 1), 0, height-240);
    image(textureAssets.getUserHud(1, 1), 128, height-240);
    image(textureAssets.getUserHud(2, 1), 256, height-240);
    image(textureAssets.getUserHud(3, 1), 384, height-240);
    showText();

    //de bommen
    image(textureAssets.getUserHud(7, 0), width-400, height-125);
    image(textureAssets.getUserHud(7, 1), width-275, height-125);
    image(textureAssets.getUserHud(6, 0), width-150, height-125);
    
    //de activate knop sprite
    image(textureAssets.getUserHud(4, 0), width-125, height-250);
    if (checkC4(objectHandler.entities)) {
        image(textureAssets.getUserHud(5, 0), width-125, height-250);
      }

    //de buttons
    image(textureAssets.getBombItem(0, 7), width-325, height-50);
    image(textureAssets.getBombItem(6, 7), width-200, height-50);
    image(textureAssets.getBombItem(4, 7), width-75, height-50);
    
    image(textureAssets.getBombItem(2, 7), width-50, height-150);
  }

  void keyReleased()
  {
    if (key == 'A' || key == 'a') {
      keyPressed = false;
    }
    if (key == 'S' || key == 's') {
      keyPressed = false;
    }
    if (key == 'Z' || key == 'z') {
      keyPressed = false;
    }
  }


  //alle visual blokken in de ui scherm
  void uiBlocks()
  {
    stroke(150, 0, 0);
    strokeWeight(10);
    fill(255, 0, 0);
    rect(uiBlockX, uiBlockY, uiBlockWidth, uiBlockHeight);
    fill(20);
    rect(ActiveuiBlockX, ActiveuiBlockY, ActiveuiBlockWidth, ActiveuiBlockHeight);
    noStroke();
  }

  // de texten worden geshowed als er iets specifieks gebeurt
  void showText() {
    fill(255);
    textSize(30);
    text("HighScore: ", 20, height-140);
    text("Your Score: "+ highscore.score, 20, height-180);

    //als de cooldown ready is ==> showt een ready text
    if (cooldownReady()) {
      fill(0);
      textSize(18);
      text("Bomb", cdBlockX + 12, cdBlockY + 33);
      text("Ready!", cdBlockX + 11, cdBlockY + 57);
    }

    //als de player een bomb geplaatst heeft dat alleen af gaat als ie op de trigger knop drukt ==> showt een BOOM! text zodat de player weet dat de bommen af kunnen gaan
    if (checkC4(objectHandler.entities)) {
      fill(0);
      textSize(12);
      text("DETONATE!", ActiveuiBlockX + 6, ActiveuiBlockY + 22);
    }

    noFill();
  }

  class Cooldown {
    Cooldown() {
    }

    void display() {
      fill(255, cdBlockTransparency);
      rect(cdBlockX, cdBlockY, cdBlockWidth, cdBlockHeight);
    }

    void update() {
      if (!cooldownReady()) {
        // de snelheid van het optellen van de cooldown. bij 80 stopt ie met tellen en dus is de cooldown ready
        cdBlockHeight += 1.325;
        if (cooldownReady()) {
          cdBlockHeight = 80;
        }
      }

      //Als de cooldown voorbij is en de player drukt op de actie knop (bomb plaatsen) start de cooldown weer van 0
      if (cooldownReady() && keyPressed && (key == 'A' || key == 'a' || key == 'S' || key == 's' || key == 'Z' || key == 'z' )) {
        if (keyPressed)
        {
          cdBlockHeight = 0;
          keyPressed = false;
        }
      }
    }
  }


  class ActivateBomb {
    ActivateBomb() {
    }

    void display() {
      //Als er een bomb geplaatst is dat alleen af kan gaan als de player op de trigger drukt, wordt de ui gehighlight dat de bomb af kan gaan.
      if (checkC4(objectHandler.entities)) {
        fill((random(50, 255)));
        rect(ActiveBlockX, ActiveBlockY, ActiveBlockWidth, ActiveBlockHeight);
        noFill();
      }
    }
  }

  class HealthUI {
    HealthUI() {
    }

    void display() {
      fill(255, 0, 0);
      stroke(200, 0, 0);
      strokeWeight(5);
      rect(80, height-80, health * 20, 20);
      fill(0, 255, 255);
      stroke(0, 255, 255);
      strokeWeight(5);
      rect(80, height-30, shield * 20, 15);
      noFill();
      noStroke();
    }

    void update() {
    }
  }

  class PowerUPS {
    PowerUPS() {
    }

    void display() {
      stroke(255);
      strokeWeight(5);
      //line(450, height-90, 450, height);
      //line(800, height-90, 800, height);
      //line(1500, height-90, 1500, height);
      noStroke();

      if (speedBonus) {
        fill(125, 125, 255); //lichtpaars/blauw
        rect(875, height-75, 50, 50);
        noFill();
      }

      if (sparklerBonus) {
        fill(255, 255, 0); //paars/pink
        rect(950, height-75, 50, 50);
        noFill();
      }

      if (undefeatabaleBonus) {
        fill(255, 0, 255); // geel
        rect(1025, height-75, 50, 50);
        noFill();
      }

      if (shieldBonus) {
        fill(0, 255, 255);  //cyan
        rect(1100, height-75, 50, 50);
        noFill();
      }
    }
  }

  //Checkt of er een C4 geplaatst is door de speler
  boolean checkC4(ArrayList<Object> entityObjects) {
    for (Object c4 : entityObjects) {
      if (c4.bombId == BombID.CFOUR) {
        return true;
      }
    }
    return false;
  }

  //checkt of de rectangle bij de lengte is van de lengte van de ui ==> checkt dus of de cooldown voorbij is en ready is is voor de volgende bomb
  boolean cooldownReady() {
    if (cdBlockHeight >= 80) {
      return true;
    } else {
      return false;
    }
  }
}
