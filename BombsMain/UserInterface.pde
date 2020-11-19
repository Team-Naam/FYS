
int  cdBlockX = width/2;
int  cdBlockY = height/2;
int  cdBlockWidth = 50;
int  cdBlockHeight = 0;
int  cdBlockTransparency = 200;

int  uiBlockX = width/2;
int  uiBlockY = height/2;
int  uiBlockWidth = 50;
int  uiBlockHeight = 50;

int  timeInterval = 2000;
int  timeCheck = millis();

class UserInterface {
  TextureAssets assetLoader;
  Player player;
  Highscore highscore;

  UserInterface(TextureAssets assetLoader, Player player, Highscore highScore) {
    this.assetLoader = assetLoader;
    this.player = player;
    this.highscore = highScore;
  }

  void draw() {
    uiBlock();
    cooldownActivator();
  }
}
void cooldownActivator()
{
  if (clicCooldown() == true)
  {
    cooldownIndicator();
  }
}

void cooldownIndicator()
{
  fill(255, cdBlockTransparency);
  cdBlockHeight++;
  rect(cdBlockX, cdBlockY, cdBlockWidth, cdBlockHeight);
  if (cdBlockHeight > 50)
  {
    cdBlockHeight = 0;
  }
}

void uiBlock()
{
  fill(255, 0, 0);
  rect(uiBlockX, uiBlockY, uiBlockWidth, uiBlockHeight);
}


boolean clicCooldown()
{
  if (keyPressed && millis() > timeInterval + timeCheck)
  {
    return true;
  } else return false;
}
