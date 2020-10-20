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
