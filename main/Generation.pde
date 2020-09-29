public class LevelGeneration {
  int[] placement;
  boolean placeBlock;
  int yes;

  LevelGeneration() {
    placement = new int[8];
    yes = 1;
    placeBlock = false;
  }

  int randomMinOrOne() {
    return (int) random(2) * 2 - 1;
  }

  void update() {
    
    //fills array with -1 or 1 at random (for loop wilt niet?)
    for (int i = 0; i < 8; i++) {
      placement[i] = randomMinOrOne();
    }
    
    printArray(placement);
  }

  void draw() {
    for (int n : placement) {
      if (n == yes) {
        placeBlock = true;
        break;
      }
    }

    if (placeBlock) {
      myHardBlock.draw();
    }
  }
}
