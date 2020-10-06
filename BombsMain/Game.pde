//Alles game gerelateerd

class Game {


  void update() {
    player.update();
  }

  void draw() {
    background(220);
    player.draw();
    fill(200);
    rect(100, 100, 100, 100);
  }
}
