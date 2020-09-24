class Block {
  int blockSize = 128;
  int posX = 2000;
  int posY;

  Block(int tempPosY) {
    posY = tempPosY;
  }

  void blockCreation() {
    posX = posX - 1;
    rectMode(CORNER);
    rect(posX, posY, blockSize, blockSize);
  }
}

class SoftBlock extends Block {
  SoftBlock(int tempPosY) {
    super(tempPosY);
  };

  void blockColor() {
    fill(255);
  }
}

class HardBlock extends Block {
  HardBlock(int tempPosY) {
    super(tempPosY);
  };

  void blockColor() {
    fill(200);
  }
}
