//Code credit Winand Metz

//Muren, moet nog collision op
class Wall extends Object {
  Ray leftRay;
  Ray rightRay;
  Ray upRay;
  Ray downRay;

  boolean leftCon = false;
  boolean rightCon = false;
  boolean upCon = false;
  boolean downCon = false;

  Wall(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, ObjectID.WALL, objectHandler, sprites);
  }

  void update() {
    lb = new PVector(x, y);
    rb = new PVector(x + w, y);
    ro = new PVector(x + w, y + h);
    lo = new PVector(x, y + h);

    or = new PVector((lb.x + rb.x) / 2, (lb.y + lo.y) / 2);

    left = new PVector(x - 5, (lb.y + lo.y) / 2);
    right = new PVector(x + w + 5, (lb.y + lo.y) / 2);
    up = new PVector((lb.x + rb.x) / 2 - 1, y - 5);
    down = new PVector((lb.x + rb.x) / 2 + 1, y + h + 5);

    for (Object wallObject : objectHandler.walls) {
      if (wallObject.objectId == ObjectID.WALL || wallObject.objectId == ObjectID.ROCK) {
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

  //Inladen van de texture voor de muur en plaatsing
  void draw() {
    //stroke(255, 0, 0);
    //line(or.x, or.y, x - 5, (lb.y + lo.y) / 2);
    //stroke(0, 255, 0);
    //line(or.x, or.y, x + w + 5, (lb.y + lo.y) / 2);
    //stroke(0, 0, 255);
    //line(or.x, or.y, (lb.x + rb.x) / 2, y - 5);
    //stroke(255, 255, 0);
    //line(or.x, or.y, (lb.x + rb.x) / 2, y + h + 5);


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

//Onder en boven muren
class Rock extends Object {

  Rock(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, ObjectID.ROCK, objectHandler, sprites);
  }

  void update() {
    lb = new PVector(x, y);
    rb = new PVector(x + w, y);
    ro = new PVector(x + w, y + h);
    lo = new PVector(x, y + h);

    or = new PVector((lb.x + rb.x) / 2, (lb.y + lo.y) / 2);

    left = new PVector(x - 5, (lb.y + lo.y) / 2);
    right = new PVector(x + w + 5, (lb.y + lo.y) / 2);
    up = new PVector((lb.x + rb.x) / 2 - 1, y - 5);
    down = new PVector((lb.x + rb.x) / 2 + 1, y + h + 5);
  }

  void draw() {
    image(sprites.getRock(), x, y);
  }
}

//-----------------------------Breakable blocks---------------------------------

class Path extends Object {
  Ray leftRay;
  Ray rightRay;
  Ray upRay;
  Ray downRay;

  boolean leftCon = false;
  boolean rightCon = false;
  boolean upCon = false;
  boolean downCon = false;

  Path(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, ObjectID.PATH, objectHandler, sprites);
  }

  void update() {
    if (x == -128) {
      x = 2048;
    }

    stroke(0);
    strokeWeight(1);
    fill(255, 0, 0);
    rect(x, y, w, h);

    lb = new PVector(x, y);
    rb = new PVector(x + w, y);
    ro = new PVector(x + w, y + h);
    lo = new PVector(x, y + h);

    or = new PVector((lb.x + rb.x) / 2, (lb.y + lo.y) / 2);

    left = new PVector(x - 5, (lb.y + lo.y) / 2);
    right = new PVector(x + w + 5, (lb.y + lo.y) / 2);
    up = new PVector((lb.x + rb.x) / 2 - 1, y - 5);
    down = new PVector((lb.x + rb.x) / 2 + 1, y + h + 5);

    for (Object wallObject : objectHandler.walls) {
      if (wallObject.objectId == ObjectID.WALL || wallObject.objectId == ObjectID.ROCK) {
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

  void draw() {
    stroke(255, 0, 0);
    line(or.x, or.y, x - 5, (lb.y + lo.y) / 2);
    stroke(0, 255, 0);
    line(or.x, or.y, x + w + 5, (lb.y + lo.y) / 2);
    stroke(0, 0, 255);
    line(or.x, or.y, (lb.x + rb.x) / 2, y - 5);
    stroke(255, 255, 0);
    line(or.x, or.y, (lb.x + rb.x) / 2, y + h + 5);
    
    fill(82, 51, 63);
    rect(x, y, w, h);
  }
}

//-----------------------------Breakable blocks---------------------------------

class BreakableWall extends Entity {

  int health = BBLOCK_HEALTH;

  //PVector lb, rb, ro, lo;

  BreakableWall(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.objectId = ObjectID.BBLOCK;
  }

  void update() {
    bombDamage();
  }

  void bombDamage() {
    if (insideExplosion) {
      health -= BOMB_DAMAGE;
      insideExplosion = false;
    }
    if (health <= 0) {
      objectHandler.addItem(x, y, 64, 64);
      objectHandler.removeWall(this);
    }
  }

  void draw() {
    fill(128, 24, 78);
    rect(x, y, w, h);
  }
}
