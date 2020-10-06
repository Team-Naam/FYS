class EnemieSpawn {
  ArrayList<Enemies> enemies;
  int spawnTimer, spawnTime, spawnSec;

  EnemieSpawn() {
    enemies = new ArrayList<Enemies>();
    spawnSec = 10;
    spawnTimer = 0;
    spawnTime = spawnSec * 60;
  }

  void newEnemie() {
    enemies.add(new Enemies());
  }

  void update() {
    spawnTimer++;
    if (spawnTimer == spawnTime) {
      newEnemie();
      spawnTimer = 0;
    }
    for (int i = enemies.size() - 1; i >= 0; i--) {
      Enemies enemie = enemies.get(i);
      enemie.update();
      enemie.blockCollision();

      if (enemie.HP <= 0) {
        enemies.remove(i);
      }
    }
  }

  void draw() {
    for (int i = 0; i < enemies.size(); i++) {
      enemies.get(i).draw();
    }
  }

  void enemieHit(int enemie, int dmg) {
    enemies.get(enemie).HP -= dmg;
  }
}
