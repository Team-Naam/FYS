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
    //Een rectangle voor HP \\\ Per extra opgepakte HP, wordt de lengte vd rectangle vergroot met de toegegeven waarde
    fill(255, 0, 0);
    stroke(200, 0, 0);
    strokeWeight(5);
    rect(80, height-80, health * 20, 20);
    noFill();
    noStroke();
  }

  void showShield()
  {
    //Een rectangle voor de shield \\\ Per extra opgepakte shield, wordt de lengte vd rectangle vergroot met toegegeven waarde
    fill(0, 255, 255);
    stroke(0, 200, 200);
    strokeWeight(5);
    rect(80, height-30, shield * 20, 15);
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
