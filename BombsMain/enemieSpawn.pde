class EnemieSpawn {
  ArrayList<Enemies> enemies;

  EnemieSpawn() {
    enemies = new ArrayList<Enemies>();
    
  }

//spawnt een nieuwe spider op de gegeven locatie
  void newSpider(int x, int y, int w, int h, ObjectHandler objectHandler, Sprites sprites, Object player) {
    enemies.add(new Spider(x, y, w, h, objectHandler, sprites, player));
  }
  //spawnt een nieuwe mummie op de gegeven locatie
  void newMummie(int x, int y, int w, int h, ObjectHandler objectHandler, Sprites sprites, Object player) {
    enemies.add(new Mummie(x, y, w, h, objectHandler, sprites, player));
  }
  //spawnt een nieuwe geest op de gegeven locatie
  void newGhost(int x, int y, int w, int h, ObjectHandler objectHandler, Sprites sprites, Object player) {
    enemies.add(new Ghosts(x, y, w, h, objectHandler, sprites, player));
  }

  void update() {
    for (int i = enemies.size() - 1; i >= 0; i--) {
      Enemies enemie = enemies.get(i);
      enemie.update();
      
      //geeft enemies mee voor de enemie/enemie collision
      for (int j = enemies.size() - 1; j >= 0; j--){
        if (i != j){
          enemie.enemieCollision(enemies.get(j));
        }
      }
      //enemies verdwijnen als ze dood zijn
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
//haalt hp van de enemies af
  void enemieHit(int enemie, int dmg) {
    enemies.get(enemie).HP -= dmg;
  }
}
