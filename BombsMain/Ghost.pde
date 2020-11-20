//Code credit Jordy Post, Winand Metz, Ruben Verheul

class Ghost extends Entity {

  Ghost(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.entityId = EntityID.GHOST;
    savedTime = millis();
    health = GHOST_HEALTH;
    roamingTimer = GHOST_ROAMING;
    velX = GHOST_MOVEMENT_SPEED;
    velY = GHOST_MOVEMENT_SPEED;
  }

  @Override
    void update() {
    bombDamage();
    movement();

    x = x + speedX;
    y = y + speedY;

    if (rockCollisionDetection()) {
      x = oldX - MAP_SCROLL_SPEED;
      y = oldY;
    }

    oldX = x;
    oldY = y;
  }

  void draw() {
    fill(225);
    rect(x, y, w, h);
  }
}

//-----------------------------Special ghost---------------------------------

//Code credit Ruben Verheul
class Poltergeist extends Entity {


  Poltergeist(float x, float y, int w, int h, ObjectHandler objectHandler, TextureAssets sprites) {
    super(x, y, w, h, objectHandler, sprites);
    this.entityId = EntityID.POLTERGEIST;
    savedTime = millis();
    health = POLTERGEIST_HEALTH;
    roamingTimer = POLTERGEIST_ROAMING;
    velX = POLTERGEIST_MOVEMENT_SPEED;
    velY = POLTERGEIST_MOVEMENT_SPEED;
  }

  @Override
    void update() {
    bombDamage();
    movement();

    x = x + speedX;
    y = y + speedY;

    if (rockCollisionDetection()) {
      x = oldX - MAP_SCROLL_SPEED;
      y = oldY;
    }
    oldX = x;
    oldY = y;
  }

  void draw() {
    fill(200, 200, 230);
    rect(x, y, w, h);
  }
}
