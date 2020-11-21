class UserInterface {
  TextureAssets assetLoader;
  ObjectHandler objectHandler;
  Highscore highscore;

  boolean shieldBonus = false;
  boolean undefeatabaleBonus = false;
  boolean speedBonus = false;
  boolean sparklerBonus = false;

  int bombCooldown, health, shield;

  UserInterface(TextureAssets assetLoader, Highscore highScore, ObjectHandler objectHandler) {
    this.assetLoader = assetLoader;
    this.objectHandler = objectHandler;
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
    println(highscore.score);
  }

  void draw() {
    fill(255, 0, 0);
    rect(50, 50, 50, bombCooldown);
    
    rect(120, 50, health * 100, 60);
  }
}
