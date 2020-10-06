//Alles game gerelateerd

class Game {


  void update() {
    player.update();
  }

  void draw() {
    player.draw();
    fill(200);
    rect(100, 100, 100, 100);
  }
}
