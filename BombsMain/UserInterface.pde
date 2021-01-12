//Page code credit Alex Tarnòki, Winand Metz

//Code credit Alex Tarnòki
class UserInterface {
  final color HP_COLOR_BASE = color(255, 0, 0);
  final color HP_COLOR_LIGHT = color(200, 0, 0);
  final int HP_BAR_SIZE = 80;
  final int HP_BAR_HEIGHT = 20;
  final int HP_LINE_WEIGHT = 5;

  final int SHIELD_SIZE = 80;
  final int SHIELD_WEIGHT = 5;
  final color SHIELD_BAR_SEC_COLOR = color(0, 200, 200);
  final color SHIELD_BAR_COLOR = color(0, 255, 255);


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

  //Code credit Winand metz 
  void update() {
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

  //Code credit Alex Tarnòki
  void draw()
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

  void showHP()
  {
    int hpBarLength = health * HP_BAR_HEIGHT;
    if (hpBarLength > PLAYER_HEALTH * HP_BAR_HEIGHT) hpBarLength = PLAYER_HEALTH * HP_BAR_HEIGHT;
    //Een rectangle voor HP \\\ Per extra opgepakte HP, wordt de lengte vd rectangle vergroot met de toegegeven waarde
    fill(HP_COLOR_BASE);
    stroke(HP_COLOR_LIGHT);
    strokeWeight(HP_LINE_WEIGHT);
    rect(HP_BAR_SIZE, height - HP_BAR_SIZE, hpBarLength, HP_BAR_HEIGHT);
    noFill();
    noStroke();
  }

  void showShield()
  {
    //Een rectangle voor de shield \\\ Per extra opgepakte shield, wordt de lengte vd rectangle vergroot met toegegeven waarde
    fill(SHIELD_BAR_COLOR);
    stroke(SHIELD_BAR_SEC_COLOR);
    strokeWeight(SHIELD_WEIGHT);

    rect(SHIELD_SIZE, height - 30, shield * 20, 15);
    noFill();
    noStroke();
  }

  void showButtons()
  {
    //Pakt de Z, A, S en de X knop uit Assets
    image(textureAssets.getBombItem(0, 4), width-325, height-50);
    image(textureAssets.getBombItem(0, 5), width-200, height-50);
    image(textureAssets.getBombItem(0, 6), width-75, height-50);
    image(textureAssets.getBombItem(0, 3), width-50, height-150);
  }

  void showScoreBoard()
  {
    //Pakt de Score bord uit Assets van kolom 1, rij 0 tm 3
    image(textureAssets.getUserHud(0, 1), 0, 0);
    image(textureAssets.getUserHud(1, 1), 128, 0);
    image(textureAssets.getUserHud(2, 1), 256, 0);
    image(textureAssets.getUserHud(3, 1), 384, 0);

    //Bijbehorende score text
    fill(255);
    textSize(30);
    //text("HighScore: ", 20, height-140);
    text("Your Score: "+ highscore.score, 20, 70);
    noFill();
  }

  void showStatsBoard()
  {
    //Pakt de Stats bord uit Assets van kolom 0, rij 0 tm 3
    image(textureAssets.getUserHud(0, 0), 0, height-125);
    image(textureAssets.getUserHud(1, 0), 128, height-125);
    image(textureAssets.getUserHud(2, 0), 256, height-125);
    image(textureAssets.getUserHud(3, 0), 384, height-125);
  }

  void showUI()
  {
    //Pakt de plaatjes uit Assets voor Dynamite, Landmine, C4
    image(textureAssets.getUserHud(7, 0), width-400, height-109, 64, 64);
    image(textureAssets.getUserHud(7, 1), width-275, height-109, 64, 64);
    image(textureAssets.getUserHud(6, 0), width-150, height-109, 64, 64);

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

  //Code credit Winand Metz
  //Checkt of er een C4 geplaatst is door de speler
  boolean checkC4(ArrayList<Object> entityObjects) {
    for (Object c4 : entityObjects) {
      if (c4.bombId == BombID.CFOUR) {
        return true;
      }
    }
    return false;
  }
}
