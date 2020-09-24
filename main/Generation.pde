
class LevelGeneration {
  int[] placement = new int[8];
  int walls;
  int posY;
  HardBlock myHardBlock = new HardBlock(posY);

  void generation() {

    //fills array with 0 or 1 at random
    for (int i = 0; i < 0; i++) {
      placement[i] = -1 + (int)random(2) * 2;
      if (placement[i] == 1) {
        walls = HardBlock.blockCreation();
      }
    }
  }
}
