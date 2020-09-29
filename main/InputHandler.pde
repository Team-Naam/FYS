class InputHandler {
  boolean up, down, left, right, aa, ss, zz, xx;


  void keyPressed(int keyCode, char key) {
    input(keyCode, key, true);
  }

  void keyReleased(int keyCode, char key) {
    input(keyCode, key, false);
  }

  void input(int keyCode, char key, boolean enable) {
    if (keyCode == UP) {
      up = enable;
    }
    if (keyCode == DOWN) {
      down = enable;
    }
    if (keyCode == LEFT) {
      left = enable;
    }
    if (keyCode == RIGHT) {
      right = enable;
    }
    if (key == 'a') {
      aa = enable;
    }
    if (key == 's') {
      ss = enable;
    }
    if (key == 'z') {
      zz = enable;
    }
    if (key == 'x') {
      xx = enable;
    }
  }
}
