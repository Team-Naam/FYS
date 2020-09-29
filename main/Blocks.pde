//Main class for the blocks
public class Block {
  int blockSize;
  int posX;
  int posY;
  int assetFill;

  Block() {
    posX = 1980;
    blockSize = 128;
  }

  void update(int tempPosY) {
    posX = posX - 1;
    posY = tempPosY;
  }

  void draw() {
    rectMode(CORNER);
    rect(posX, posY, blockSize, blockSize);
    fill(assetFill);
  }
}

//Softblock class based on block for breakable blocks
class SoftBlock extends Block {
  SoftBlock() {
    assetFill = color(255);
  };
}

//Hardblock class based on block for non breakable blocks
class HardBlock extends Block {
  HardBlock() {
    assetFill = color(200);
  };
}
