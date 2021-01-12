//Page code credit Winand Metz

class Wall extends Object {
  Ray leftRay;
  Ray rightRay;
  Ray upRay;
  Ray downRay;

  boolean leftCon, rightCon, upCon, downCon;
  

  Wall(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, ObjectID.WALL, objectHandler, sprites, soundAssets);
  }

  //De update wordt als eerste gerund en bepaald meerdere waardes die worden gebruikt in draw
  void update() {

    //Als het object zich buiten het scherm bevindt wordt hij verwijderd
    selfDestruct();

    //Alle connectie boolean values worden eerst op false gezet, zodat altijd opnieuw wordt bepaald of er een connectie is
    leftCon = false;
    rightCon = false;
    upCon = false;
    downCon = false;

    //Vectors voor de collision vierhoek van het object 
    lb = new PVector(x, y);
    rb = new PVector(x + w, y);
    ro = new PVector(x + w, y + h);
    lo = new PVector(x, y + h);

    //Vector voor bepalen van het middelpunt 
    or = new PVector((lb.x + rb.x) / NORMAL_DIVIDING, (lb.y + lo.y) / NORMAL_DIVIDING);

    //Vectors voor het einde van de connectie controle rays 
    left = new PVector(x - MINUS_OR_PLUS_FIVE, (lb.y + lo.y) / NORMAL_DIVIDING);
    right = new PVector(x + w + MINUS_OR_PLUS_FIVE, (lb.y + lo.y) / NORMAL_DIVIDING);
    up = new PVector((lb.x + rb.x) / NORMAL_DIVIDING - MINUS_OR_PLUS_ONE, y - MINUS_OR_PLUS_FIVE);
    down = new PVector((lb.x + rb.x) / NORMAL_DIVIDING + MINUS_OR_PLUS_ONE, y + h + MINUS_OR_PLUS_FIVE);

    /* Dit deel van de code schiet vier rays, één naar boven, beneden, links en rechts
     Hiermee wordt gecheckt of de objecten andere objecten aanraken en zet, als het zo is, de connection booleans op true
     
     Er zitten optimasation tweaks in, waaronder dat er alleen wordt gecheckt als de origins binnen een distance zitten van 138, of te wel direct naaste objecten */
    for (Object wallObject : objectHandler.walls) {
      if (wallObject.objectId == ObjectID.WALL || wallObject.objectId == ObjectID.ROCK || wallObject.objectId == ObjectID.BBLOCK) {
        if (dist(or.x, or.y, wallObject.or.x, wallObject.or.y) < 138) {

          leftRay = new Ray(or, left.x, left.y);
          rightRay = new Ray(or, right.x, right.y);
          upRay = new Ray(or, up.x, up.y);
          downRay = new Ray(or, down.x, down.y);

          float record = 69;

          PVector leftInt = leftRay.getIntersection(wallObject.rb, wallObject.ro);
          PVector rightInt = rightRay.getIntersection(wallObject.lb, wallObject.lo);
          PVector upInt = upRay.getIntersection(wallObject.lo, wallObject.ro);
          PVector downInt = downRay.getIntersection(wallObject.lb, wallObject.rb);

          if (leftInt != null) {
            float d = PVector.dist(this.or, leftInt);
            if (d < record) {
              leftCon = true;
            }
          }
          if (rightInt != null) {
            float d = PVector.dist(this.or, rightInt);
            if (d < record) {
              rightCon = true;
            }
          }
          if (upInt != null) {
            float d = PVector.dist(this.or, upInt);
            if (d < record) {
              upCon = true;
            }
          }
          if (downInt != null) {
            float d = PVector.dist(this.or, downInt);
            if (d < record) {
              downCon = true;
            }
          }
        }
      }
    }
  }

  //De connectie booleans bepalen welke texture uit de spritesheet wordt gebruikt zodat het lijkt alsof de muren verbonden zijn
  void draw() {
    if (rightCon && leftCon && downCon && !upCon) {
      image(sprites.getWall(2, 0), x, y);
    }
    if (rightCon && leftCon && !downCon && !upCon) {
      image(sprites.getWall(2, 1), x, y);
    }
    if (rightCon && !leftCon && !downCon && !upCon) {
      image(sprites.getWall(0, 1), x, y);
    }

    if (rightCon && leftCon && downCon && upCon) {
      image(sprites.getWall(0, 3), x, y);
    }
    if (!rightCon && !leftCon && !downCon && !upCon) {
      image(sprites.getWall(1, 1), x, y);
    }

    if (!rightCon && leftCon && downCon && upCon) {
      image(sprites.getWall(1, 2), x, y);
    }
    if (!rightCon && !leftCon && downCon && upCon) {
      image(sprites.getWall(1, 0), x, y);
    }
    if (!rightCon && !leftCon && !downCon && upCon) {
      image(sprites.getWall(0, 0), x, y);
    }

    if (!rightCon && leftCon && !downCon && !upCon) {
      image(sprites.getWall(0, 2), x, y);
    }
    if (!rightCon && !leftCon && downCon && !upCon) {
      image(sprites.getWall(3, 0), x, y);
    }
    if (rightCon && !leftCon && downCon && upCon) {
      image(sprites.getWall(2, 2), x, y);
    }

    if (rightCon && !leftCon && !downCon && upCon) {
      image(sprites.getWall(3, 3), x, y);
    }
    if (!rightCon && leftCon && !downCon && upCon) {
      image(sprites.getWall(3, 2), x, y);
    }
    if (rightCon && leftCon && !downCon && upCon) {
      image(sprites.getWall(3, 1), x, y);
    }

    if (rightCon && !leftCon && downCon && !upCon) {
      image(sprites.getWall(1, 3), x, y);
    }
    if (!rightCon && leftCon && downCon && !upCon) {
      image(sprites.getWall(2, 3), x, y);
    }
  }
}

//-----------------------------Rock top & bottom---------------------------------

class Rock extends Object {

  Rock(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, ObjectID.ROCK, objectHandler, sprites, soundAssets);
  }

  void update() {
    //Als het object zich buiten het scherm bevindt wordt hij verwijderd
    selfDestruct();

    //Vectors voor de collision vierhoek van het object 
    lb = new PVector(x, y);
    rb = new PVector(x + w, y);
    ro = new PVector(x + w, y + h);
    lo = new PVector(x, y + h);

    //Vector voor bepalen van het middelpunt 
    or = new PVector((lb.x + rb.x) / NORMAL_DIVIDING, (lb.y + lo.y) / NORMAL_DIVIDING);

    //Vectors voor het einde van de connectie controle rays 
    left = new PVector(x - MINUS_OR_PLUS_FIVE, (lb.y + lo.y) / NORMAL_DIVIDING);
    right = new PVector(x + w + MINUS_OR_PLUS_FIVE, (lb.y + lo.y) / NORMAL_DIVIDING);
    up = new PVector((lb.x + rb.x) / NORMAL_DIVIDING - MINUS_OR_PLUS_ONE, y - MINUS_OR_PLUS_FIVE);
    down = new PVector((lb.x + rb.x) / NORMAL_DIVIDING + MINUS_OR_PLUS_ONE, y + h + MINUS_OR_PLUS_FIVE);
  }

  void draw() {
    image(sprites.getRock(), x, y);
  }
}

//-----------------------------Path blocks---------------------------------

class Path extends Object {
  Ray leftRay;
  Ray rightRay;
  Ray upRay;

  int randomOverlayX, randomOverlayY;
  int rayOverlayRandomMin = 0;
  int rayOverlayRandomMax = 2;
  int pathLimit = -128;
  int respawnPoint = 2048;

  boolean leftCon, rightCon, upCon;

  Path(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, ObjectID.PATH, objectHandler, sprites, soundAssets);

    //Bepaald een random overlay x en y waarde, dit wordt later gebruikt in draw
    randomOverlayX = (int)random(rayOverlayRandomMin, rayOverlayRandomMax);
    randomOverlayY = (int)random(rayOverlayRandomMin, rayOverlayRandomMax);
  }

  void update() {
    //Als het path object zich links buiten het scherm bevind, wordt deze terug gezet naar de rechterkant
    if (x < -pathLimit) {
      x = respawnPoint;
    }

    //Connectie booleans
    leftCon = false;
    rightCon = false;
    upCon = false;

    //Vectors voor de collision vierhoek van het object 
    lb = new PVector(x, y);
    rb = new PVector(x + w, y);
    ro = new PVector(x + w, y + h);
    lo = new PVector(x, y + h);

    //Vector voor bepalen van het middelpunt 
    or = new PVector((lb.x + rb.x) / NORMAL_DIVIDING, (lb.y + lo.y) / NORMAL_DIVIDING);

    //Vectors voor het einde van de connectie controle rays 
    left = new PVector(x - MINUS_OR_PLUS_FIVE, (lb.y + lo.y) / NORMAL_DIVIDING);
    right = new PVector(x + w + MINUS_OR_PLUS_FIVE, (lb.y + lo.y) / NORMAL_DIVIDING);
    up = new PVector((lb.x + rb.x) / NORMAL_DIVIDING - MINUS_OR_PLUS_ONE, y - MINUS_OR_PLUS_FIVE);

    /* Dit deel van de code schiet drie rays, één naar boven, links en rechts
     Hiermee wordt gecheckt of de objecten andere objecten aanraken en zet, als het zo is, de connection booleans op true
     
     Er zitten optimasation tweaks in, waaronder dat er alleen wordt gecheckt als de origins binnen een distance zitten van 138, of te wel direct naaste objecten */
    for (Object wallObject : objectHandler.walls) {
      if (wallObject.objectId == ObjectID.WALL || wallObject.objectId == ObjectID.ROCK || wallObject.objectId == ObjectID.BBLOCK) {
        if (dist(or.x, or.y, wallObject.or.x, wallObject.or.y) < 138) {
          leftRay = new Ray(or, left.x, left.y);
          rightRay = new Ray(or, right.x, right.y);
          upRay = new Ray(or, up.x, up.y);

          float record = 69;

          PVector leftInt = leftRay.getIntersection(wallObject.rb, wallObject.ro);
          PVector rightInt = rightRay.getIntersection(wallObject.lb, wallObject.lo);
          PVector upInt = upRay.getIntersection(wallObject.lo, wallObject.ro);
          if (leftInt != null) {
            float d = PVector.dist(this.or, leftInt);
            if (d < record) {
              leftCon = true;
            }
          }
          if (rightInt != null) {
            float d = PVector.dist(this.or, rightInt);
            if (d < record) {
              rightCon = true;
            }
          }
          if (upInt != null) {
            float d = PVector.dist(this.or, upInt);
            if (d < record) {
              upCon = true;
            }
          }
        }
      }
    }
  }

  //De connectie booleans bepalen welke texture uit de spritesheet wordt gebruikt, zodat het lijkt alsof de muren een contact shadow hebben met de grond
  void draw() {
    if (upCon && rightCon && leftCon) {
      image(sprites.getBackground(1, 0), x, y);
    }
    if (upCon && !rightCon && !leftCon) {
      image(sprites.getBackground(0, 1), x, y);
    }

    if (upCon && rightCon && !leftCon) {
      image(sprites.getBackground(0, 2), x, y);
    }
    if (upCon && !rightCon && leftCon) {
      image(sprites.getBackground(1, 1), x, y);
    }

    if (!upCon && !rightCon && leftCon) {
      image(sprites.getBackground(2, 0), x, y);
    }
    if (!upCon && rightCon && !leftCon) {
      image(sprites.getBackground(1, 2), x, y);
    } 

    if (!upCon && rightCon && leftCon) {
      image(sprites.getBackground(2, 1), x, y);
    }

    if (!upCon && !rightCon && !leftCon) {
      image(sprites.getBackground(0, 0), x, y);
    }

    //Hier wordt een random overlay gepakt uit de spritesheet, waarmee wordt bepaald hoe het tegel patroon eruit ziet
    image(sprites.getBackgroundOverlay(randomOverlayX, randomOverlayY), x, y);
  }
}

//-----------------------------Breakable blocks---------------------------------

class BreakableWall extends Entity {
  Ray leftRay;
  Ray rightRay;
  Ray upRay;
  Ray downRay;

  boolean leftCon, rightCon, upCon, downCon;
  int originLimit = 138;

  BreakableWall(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.objectId = ObjectID.BBLOCK;
  }

  //Breakable wall is een entity maar moet de karakterstieken van een muur hebben, de update is dus overriden
  @Override
    void update() {
    //Als het object zich buiten het scherm bevindt wordt hij verwijderd
    selfDestruct();

    //Connectie booleans
    leftCon = false;
    rightCon = false;
    upCon = false;
    downCon = false;

    //Vectors voor de collision vierhoek van het object 
    lb = new PVector(x, y);
    rb = new PVector(x + w, y);
    ro = new PVector(x + w, y + h);
    lo = new PVector(x, y + h);

    //Vector voor bepalen van het middelpunt 
    or = new PVector((lb.x + rb.x) / NORMAL_DIVIDING, (lb.y + lo.y) / NORMAL_DIVIDING);

    //Vectors voor het einde van de connectie controle rays 
    left = new PVector(x - MINUS_OR_PLUS_FIVE, (lb.y + lo.y) / NORMAL_DIVIDING);
    right = new PVector(x + w + MINUS_OR_PLUS_FIVE, (lb.y + lo.y) / NORMAL_DIVIDING);
    up = new PVector((lb.x + rb.x) / NORMAL_DIVIDING - MINUS_OR_PLUS_ONE, y - MINUS_OR_PLUS_FIVE);
    down = new PVector((lb.x + rb.x) / NORMAL_DIVIDING + MINUS_OR_PLUS_ONE, y + h + MINUS_OR_PLUS_FIVE);

    /* Dit deel van de code schiet vier rays, één naar boven, beneden, links en rechts
     Hiermee wordt gecheckt of de objecten andere objecten aanraken en zet, als het zo is, de connection booleans op true
     
     Er zitten optimasation tweaks in, waaronder dat er alleen wordt gecheckt als de origins binnen een distance zitten van 138, of te wel direct naaste objecten */
    for (Object wallObject : objectHandler.walls) {
      if (wallObject.objectId == ObjectID.WALL || wallObject.objectId == ObjectID.ROCK || wallObject.objectId == ObjectID.BBLOCK) {
        if (dist(or.x, or.y, wallObject.or.x, wallObject.or.y) < originLimit) {

          leftRay = new Ray(or, left.x, left.y);
          rightRay = new Ray(or, right.x, right.y);
          upRay = new Ray(or, up.x, up.y);
          downRay = new Ray(or, down.x, down.y);

          float record = 69;

          PVector leftInt = leftRay.getIntersection(wallObject.rb, wallObject.ro);
          PVector rightInt = rightRay.getIntersection(wallObject.lb, wallObject.lo);
          PVector upInt = upRay.getIntersection(wallObject.lo, wallObject.ro);
          PVector downInt = downRay.getIntersection(wallObject.lb, wallObject.rb);

          if (leftInt != null) {
            float d = PVector.dist(this.or, leftInt);
            if (d < record) {
              leftCon = true;
            }
          }
          if (rightInt != null) {
            float d = PVector.dist(this.or, rightInt);
            if (d < record) {
              rightCon = true;
            }
          }
          if (upInt != null) {
            float d = PVector.dist(this.or, upInt);
            if (d < record) {
              upCon = true;
            }
          }
          if (downInt != null) {
            float d = PVector.dist(this.or, downInt);
            if (d < record) {
              downCon = true;
            }
          }
        }
      }
    }
    //Als het object in een explosie bevind, wordt het gebroken 
    bombDamage();
  }

  //Bij het breken van breekbare muren wordt een item gedropt
  @Override
    void bombDamage() {
    //Eerst wordt gecheckt of de object zich in de explosie circle bevind, waarna vervolgens de health ervan wordt afgetrokken
    if (insideExplosion) {
      health -= BOMB_DAMAGE;
      insideExplosion = false;
    }
    if (health <= 0) {
      //addItem wordt aangeroepen met de x en y van de muur
      objectHandler.addItem(x, y, ADD_ITEM_SIZE, ADD_ITEM_SIZE);
      //Object wordt uit de list gehaald en verwijderd
      objectHandler.removeWall(this);
    }
  }

  //De connectie booleans bepalen welke texture uit de spritesheet wordt gebruikt, zodat het lijkt alsof de breekbare muren verbonden zijn
  void draw() {
    if (rightCon && leftCon && !upCon && !downCon) {
      image(sprites.getBrokenWall(0, 0), x, y);
    }
    if (!rightCon && !leftCon && upCon && downCon) {
      image(sprites.getBrokenWall(1, 0), x, y);
    }
  }
}

//-----------------------------Breakable items---------------------------------

class BreakableObject extends Entity {

  int randomTexture;
  float randomPosQ, newX, newY;
  float widthHeightMultiplier = 0.9;

  BreakableObject(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    this.entityId = EntityID.BOBJECT;
  }

  void update() {
    //Als het object zich buiten het scherm bevindt wordt hij verwijderd
    selfDestruct();

    //Objectpositie wordt met een random offset opgeteld
    newX = x + randomPosQ;
    newY = y + randomPosQ;

    //Als het object in een explosie bevind, wordt het gebroken (zie Entity)
    bombDamage();
  }

  //Bij het breken van breekbare objecten wordt een item gedropt
  @Override
    void bombDamage() {
    //Eerst wordt gecheckt of de object zich in de explosie circle bevind, waarna vervolgens de health ervan wordt afgetrokken
    if (insideExplosion) {
      health -= BOMB_DAMAGE;
      insideExplosion = false;
    }
    if (health <= 0) {
      //addItem wordt aangeroepen met de x en y van de muur
      objectHandler.addItem(newX, newY, ADD_ITEM_SIZE, ADD_ITEM_SIZE);
      //Object wordt uit de list gehaald en verwijderd
      objectHandler.removeEntity(this);
    }
  }

  //De dropshadow (zie Object class) is voor de objecten anders i.v.m. de aparte vormen
  @Override
    void dropShadow() {
    noStroke();
    fill(0, 65);
    ellipse(newX + w / NORMAL_DIVIDING, newY + h * widthHeightMultiplier, w, w * widthHeightMultiplier);
  }
}

//-----------------------------Corpse---------------------------------

class Corpse extends BreakableObject {
  float ellipseMultiplierOne = 0.5;
  float ellipseMultiplierTwo = 0.6;
  

  Corpse(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
  }

  @Override
    void bombDamage() {
    if (insideExplosion) {
      health -= BOMB_DAMAGE;
      insideExplosion = false;
    }
    if (health <= 0) {
      objectHandler.addItem(x, y, ADD_ITEM_SIZE, ADD_ITEM_SIZE);
      objectHandler.removeEntity(this);
    }
  }

  @Override
    void dropShadow() {
    noStroke();
    fill(0, 65);
    ellipse(x + w / NORMAL_DIVIDING, y + h * ellipseMultiplierOne, w, w * ellipseMultiplierOne);
  }

  void draw() {
    image(sprites.getCorpse(0,0), x, y);
  }
}

//-----------------------------Vases---------------------------------

class Vases extends BreakableObject {
  int textureRandom = 9;
  int randomQPos = 1;
  int multiplierOne = 64;
  float multiplierTwo = 0.7;
  float multiplierThree = 0.9;

  Vases(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    randomTexture = (int)random(textureRandom);
    randomPosQ = random(randomQPos) * multiplierOne;

    //println(newX, newY);
  }

  @Override
    void dropShadow() {
    noStroke();
    fill(0, 112);
    ellipse(newX + w / NORMAL_DIVIDING, newY + h * multiplierTwo, w, w * multiplierThree);
  }

  void draw() {
    image(sprites.getObject(0, 0), newX, newY);
  }
}

class Backpack extends BreakableObject {
  int textureRandom = 9;
  int randomQpos = 1;
  int multiplierOne = 70;
  float multiplierTwo = 0.51;
  float multiplierThree = 0.7;
  float multiplierFour = 0.6;
  float multiplierFive = 0.5;

  Backpack(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    randomTexture = (int)random(textureRandom);
    randomPosQ = random(randomQpos) * multiplierOne;
  }

  @Override
    void dropShadow() {
    noStroke();
    fill(0, 112);
    ellipse(newX + w * multiplierTwo, newY + h * multiplierThree, w * multiplierFour, w * multiplierFive);
  }

  void draw() {
    image(sprites.getObject(1, 0), newX, newY);
  }
}
