//Misschien Herbruikbaar, als je dingen hebt die je misschien kan hergebruiken in toekomst voeg toe

//Voor opzoeken locaties van game objecten (Moet in object tab), code credit Winand Metz
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

//Voor inspawnen test enemy (Moet in objecthandler), code credit Winand Metz
//void addEnemy(int x, int y, int w, int h) {
//  Enemy enemy = new Enemy(x, y - 100, w / 2, h / 2, this, sprites);
//  entries.add(enemy);
//}

//(Moet in game bij maploader), code credit Winand Metz
//Hexcode = 
//if (c == 0xFF) {
//  objectHandler.addEnemy(x * tw, y * th, tw, th);
//}

//Graphics engine compiling code
//      lightMap.beginDraw();
//      lightMap.clear();
//      lightMap.background(0);
//      lightMap.shape(emitterPlayer.getShape(255));
//      lightMap.endDraw();

//      lightMapOutput.beginDraw();
//      lightMapOutput.clear();
//      lightMapOutput.background(0);
//      lightMapOutput.imageMode(CENTER);
//      lightMapOutput.image(invLight, playerPos.x, playerPos.y);
//      lightMapOutput.endDraw();

//      lightMap.mask(lightMapOutput);

//      shadowMask.beginDraw();
//      shadowMask.clear();
//      shadowMask.background(0);
//      shadowMask.image(lightMap, 0, 0);
//      shadowMask.endDraw();

//      shadowMap.mask(shadowMask);

//      lightMask.beginDraw();
//      lightMask.clear();
//      lightMask.background(240);
//      lightMask.image(shadowMap, 0, 0);
//      lightMask.endDraw();

//      shadowMapTwo.mask(lightMask);

//      invLightMap.beginDraw();
//      invLightMap.clear();
//      invLightMap.background(0);
//      invLightMap.imageMode(CENTER);
//      invLightMap.image(invLight, playerPos.x, playerPos.y);
//      invLightMap.endDraw();

//      invLightMap.mask(lightMask);
      
//      shadowMapThree.mask(invLightMap);

//      //image(lightMap, 0, 0);
//      //image(lightMapOutput, 0, 0);
//      //image(shadowMask, 0, 0);
//      //image(shadowMap, 0, 0);
//      //image(lightMask, 0, 0);
//      image(shadowMapTwo, 0, 0);
//      //image(invLightMap, 0, 0);
//      //image(shadowMapThree, 0, 0);
