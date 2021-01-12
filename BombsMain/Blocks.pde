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
    or = new PVector((lb.x + rb.x) / 2, (lb.y + lo.y) / 2);

    //Vectors voor het einde van de connectie controle rays 
    left = new PVector(x - 5, (lb.y + lo.y) / 2);
    right = new PVector(x + w + 5, (lb.y + lo.y) / 2);
    up = new PVector((lb.x + rb.x) / 2 - 1, y - 5);
    down = new PVector((lb.x + rb.x) / 2 + 1, y + h + 5);

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
    or = new PVector((lb.x + rb.x) / 2, (lb.y + lo.y) / 2);

    //Vectors voor het einde van de connectie controle rays 
    left = new PVector(x - 5, (lb.y + lo.y) / 2);
    right = new PVector(x + w + 5, (lb.y + lo.y) / 2);
    up = new PVector((lb.x + rb.x) / 2 - 1, y - 5);
    down = new PVector((lb.x + rb.x) / 2 + 1, y + h + 5);
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

  boolean leftCon, rightCon, upCon;

  Path(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, ObjectID.PATH, objectHandler, sprites, soundAssets);

    //Bepaald een random overlay x en y waarde, dit wordt later gebruikt in draw
    randomOverlayX = (int)random(0, 2);
    randomOverlayY = (int)random(0, 2);
  }

  void update() {
    //Als het path object zich links buiten het scherm bevind, wordt deze terug gezet naar de rechterkant
    if (x < -128) {
      x = 2048;
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
    or = new PVector((lb.x + rb.x) / 2, (lb.y + lo.y) / 2);

    //Vectors voor het einde van de connectie controle rays 
    left = new PVector(x - 5, (lb.y + lo.y) / 2);
    right = new PVector(x + w + 5, (lb.y + lo.y) / 2);
    up = new PVector((lb.x + rb.x) / 2 - 1, y - 5);

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
    or = new PVector((lb.x + rb.x) / 2, (lb.y + lo.y) / 2);

    //Vectors voor het einde van de connectie controle rays 
    left = new PVector(x - 5, (lb.y + lo.y) / 2);
    right = new PVector(x + w + 5, (lb.y + lo.y) / 2);
    up = new PVector((lb.x + rb.x) / 2 - 1, y - 5);
    down = new PVector((lb.x + rb.x) / 2 + 1, y + h + 5);

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
      objectHandler.addItem(x, y, 64, 64);
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
      objectHandler.addItem(newX, newY, 64, 64);
      //Object wordt uit de list gehaald en verwijderd
      objectHandler.removeEntity(this);
    }
  }

  //De dropshadow (zie Object class) is voor de objecten anders i.v.m. de aparte vormen
  @Override
    void dropShadow() {
    noStroke();
    fill(0, 112);
    ellipse(newX + w / 2, newY + h * 0.9, w, w * 0.9);
  }
}

//-----------------------------Corpse---------------------------------

class Corpse extends BreakableObject {

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
      objectHandler.addItem(x, y, 64, 64);
      objectHandler.removeEntity(this);
    }
  }

  @Override
    void dropShadow() {
    noStroke();
    fill(0, 112);
    ellipse(x + w / 2, y + h * 0.9, w, w * 0.9);
  }

  void draw() {
    fill(255);
    rect(x, y + 24, w, h);
  }
}

//-----------------------------Vases---------------------------------

class Vases extends BreakableObject {

  Vases(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    randomTexture = (int)random(9);
    randomPosQ = random(1) * 80;

    //println(newX, newY);
  }

  @Override
    void dropShadow() {
    noStroke();
    fill(0, 112);
    ellipse(newX + w / 2, newY + h * 0.7, w, w * 0.9);
  }

  void draw() {
    image(sprites.getObject(0, 0), newX, newY);
  }
}

class Backpack extends BreakableObject {

  Backpack(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites, SoundAssets soundAssets) {
    super(x, y, w, h, objectHandler, sprites, soundAssets);
    randomTexture = (int)random(9);
    randomPosQ = random(1) * 70;
  }

  @Override
    void dropShadow() {
    noStroke();
    fill(0, 112);
    ellipse(newX + w * 0.51, newY + h * 0.7, w * 0.6, w * 0.5);
  }

  void draw() {
    image(sprites.getObject(1, 0), newX, newY);
  }
}
