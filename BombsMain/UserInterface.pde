class UserInterface {

  // de visual cooldown ui waardoor de player kan zien of de (activate) knop toegankelijk is
  int ActiveBlockX = width-250;
  int ActiveBlockY = height-130;
  int ActiveBlockWidth = 80;
  int ActiveBlockHeight = 35;

  // de visual cooldown ui voor de bomb dat na 1.5 seconden afgaat
  int AcdBlockX = width-350;
  int AcdBlockY = height-90;
  int AcdBlockWidth = 80;
  float AcdBlockHeight = 0;

  // de visual cooldown ui voor de bomb dat pas afgaat als de speler op de (activate) knop drukt
  int BcdBlockX = width-250;
  int BcdBlockY = height-90;
  int BcdBlockWidth = 80;
  float BcdBlockHeight = 0;

  // de visual cooldown ui voor de bomb dat pas afgaat als een enemy erop gaat lopen
  int CcdBlockX = width-150;
  int CcdBlockY = height-90;
  int CcdBlockWidth = 80;
  float CcdBlockHeight = 0;

  int cdBlockTransparency = 200;

  //de locatie van de blokjes over het beeldscherm. Voor elk verschillend bomb hun eigen blok.
  int ActiveuiBlockX = width-250;
  int ActiveuiBlockY = height-130;
  int ActiveuiBlockWidth = 80;
  int ActiveuiBlockHeight = 35;

  int AuiBlockX = width-350;
  int AuiBlockY = height-90;
  int AuiBlockWidth =  80;
  int AuiBlockHeight = 80;

  int BuiBlockX = width-250;
  int BuiBlockY = height-90;
  int BuiBlockWidth =  80;
  int BuiBlockHeight = 80;

  int CuiBlockX = width-150;
  int CuiBlockY = height-90;
  int CuiBlockWidth = 80;
  int CuiBlockHeight = 80;

  TextureAssets assetLoader;
  Player player;
  Highscore highscore;
  CooldownA cooldowna;
  CooldownB cooldownb;
  CooldownC cooldownc;
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
    cooldowna = new CooldownA();
    cooldownb = new CooldownB();
    cooldownc = new CooldownC();
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

    cooldowna.update();
    cooldownb.update();
    cooldownc.update();
    healthUI.update();
  }

  void draw()
  {
    uiBlocks();
    cooldowna.display();
    cooldownb.display();
    cooldownc.display();
    activateBomb.display();
    healthUI.display();
    powerUPS.display();
    showText();
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
    rect(AuiBlockX, AuiBlockY, AuiBlockWidth, AuiBlockHeight);
    rect(BuiBlockX, BuiBlockY, BuiBlockWidth, BuiBlockHeight);
    rect(CuiBlockX, CuiBlockY, CuiBlockWidth, CuiBlockHeight);
    fill(20);
    rect(ActiveuiBlockX, ActiveuiBlockY, ActiveuiBlockWidth, ActiveuiBlockHeight);
    noStroke();
  }

  // de texten worden geshowed als er iets specifieks gebeurt
  void showText() {
    fill(255);
    textSize(30);
    text("HighScore: ", 10, height-10);
    text("Your Score: "+ highscore.score, 10, height-45);
    
    //als de cooldown ready is ==> showt een ready text
    if (cooldownReady()) {
      fill(0);
      textSize(18);
      text("Ready!", AcdBlockX + 11, AcdBlockY + 50);
      text("Ready!", BcdBlockX + 11, BcdBlockY + 50);
      text("Ready!", CcdBlockX + 11, CcdBlockY + 50);
    }
    
    //als de player een bomb geplaatst heeft dat alleen af gaat als ie op de trigger knop drukt ==> showt een BOOM! text zodat de player weet dat de bommen af kunnen gaan
    if (highscore.score >= 1000) {
      fill(0);
      textSize(18);
      text("BOOM!", ActiveuiBlockX + 11, ActiveuiBlockY + 25);
    }
    
    noFill();
  }

  class CooldownA {
    CooldownA() {
    }
    
    void display() {
      fill(255, cdBlockTransparency);
      rect(AcdBlockX, AcdBlockY, AcdBlockWidth, AcdBlockHeight);
    }
    
    void update() {
      if (!cooldownReady()) {
        // de snelheid van het optellen van de cooldown. bij 80 stopt ie met tellen en dus is de cooldown ready
        AcdBlockHeight += 1.325;
        if (cooldownReady()) {
          AcdBlockHeight = 80;
        }
      }
      
      //Als de cooldown voorbij is en de player drukt op de actie knop (bomb plaatsen) start de cooldown weer van 0
      if (cooldownReady() && keyPressed && (key == 'A' || key == 'a')) {
        if (keyPressed)
        {
          AcdBlockHeight = 0;
          BcdBlockHeight = 0;
          CcdBlockHeight = 0;
          keyPressed = false;
        }
      }
    }
  }

  class CooldownB {
    
    CooldownB() {
    }
    
    void display() {
      fill(255, cdBlockTransparency);
      rect(BcdBlockX, BcdBlockY, BcdBlockWidth, BcdBlockHeight);
    }
    
    void update() {
      // de snelheid van het optellen van de cooldown. bij 80 stopt ie met tellen en dus is de cooldown ready
      if (!cooldownReady()) {
        BcdBlockHeight += 1.325;
        if (cooldownReady()) {
          BcdBlockHeight = 80;
        }
      }
      
      //Als de cooldown voorbij is en de player drukt op de actie knop (bomb plaatsen) start de cooldown weer van 0
      if (cooldownReady() && keyPressed && (key == 'S' || key == 's')) {
        if (keyPressed) {
          AcdBlockHeight = 0;
          BcdBlockHeight = 0;
          CcdBlockHeight = 0;
          keyPressed = false;
        }
      }
    }
  }

  class CooldownC {
    CooldownC() {
    }
    
    void display() {
      fill(255, cdBlockTransparency);
      rect(CcdBlockX, CcdBlockY, CcdBlockWidth, CcdBlockHeight);
    }
    
    void update() {
      // de snelheid van het optellen van de cooldown. bij 80 stopt ie met tellen en dus is de cooldown ready
      if (!cooldownReady()) {
        CcdBlockHeight += 1.325;
        if (cooldownReady()) {
          CcdBlockHeight = 80;
        }
      }
      
      //Als de cooldown voorbij is en de player drukt op de actie knop (bomb plaatsen) start de cooldown weer van 0
      if (cooldownReady() && keyPressed && (key == 'Z' || key == 'z')) {
        if (keyPressed) {
          AcdBlockHeight = 0;
          BcdBlockHeight = 0;
          CcdBlockHeight = 0;
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
      if (highscore.score >= 1000) {
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
      rect(475, height-75, health * 50, 60);
      fill(200);
      stroke(150);
      strokeWeight(5);
      rect(475, height-100, shield * 50, 25);
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
      line(450, height-90, 450, height);
      line(800, height-90, 800, height);
      line(1500, height-90, 1500, height);
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
    if (AcdBlockHeight >= 80) {
      return true;
    } else {
      return false;
    }
  }
}
