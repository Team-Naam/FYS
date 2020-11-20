int  cdBlockX = width/2;
int  cdBlockY = height/2;
int  cdBlockWidth = 50;
int  cdBlockHeight = 0;
int  cdBlockTransparency = 200;

int  uiBlockX = width/2;
int  uiBlockY = height/2;
int  uiBlockWidth = 50;
int  uiBlockHeight = 50;

class UserInterface {
  TextureAssets assetLoader;
  Player player;
  Highscore highscore;
  Cooldown cooldown;

  UserInterface(TextureAssets assetLoader, Player player, Highscore highScore) {
    this.assetLoader = assetLoader;
    this.player = player;
    this.highscore = highScore;
    cooldown = new Cooldown();
  }

  void draw()
  {
    uiBlock();
    cooldown.display();
    cooldown.update();
  }

  void uiBlock()
  {
    fill(255, 0, 0);
    rect(uiBlockX, uiBlockY, uiBlockWidth, uiBlockHeight);
  }

  class Cooldown
  {
    Cooldown()
    {
    }
    void display()
    {
      fill(255, cdBlockTransparency);
      rect(cdBlockX, cdBlockY, cdBlockWidth, cdBlockHeight);
    }
    void update()
    {
      if (!cooldownReady())
      {
        cdBlockHeight++;
        if (cdBlockHeight > 50)
        {
          cdBlockHeight = 50;
        }
      }
      if (cooldownReady() && keyPressed)
      {
        cdBlockHeight = 0;
      }
    }
  }

  boolean cooldownReady()
  {
    if (cdBlockHeight == 50)return true;
    else return false;
  }
}
