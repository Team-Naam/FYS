class Spider extends Enemies {
  boolean slowPlayer;
  int slowTime;
  float slowAmount;
  int slowTimer;
  boolean slowed;

  Spider(float posX, float posY) {
    super(posX, posY);
    bSpeedX = 1.3;
    bSpeedY = 1.3;
    HP = 1;
    sizeX = 50;
    sizeY = 50;
    slowPlayer = false;
    slowTime = 360;
    slowAmount = 0.3;
    slowTimer = slowTime;
    slowed = false;
  }

  void update() {
    super.update();
    slowEffect();
  }

  void hitPlayer() {
    hitTimer++;

    //kijkt of er collision is met bomberman, zo ja haalt hij iedere seconde hp van bomberman eraf
    if (collision(player.posX, player.posY, player.playerWidth, player.playerHeight, posX, posY, sizeX, sizeY)) {
      speedY = 0;
      speedX = 0;
      if (hitTimer > 60) {
        //haal hp van bomberman eraf + slow
        player.playerHP -= 1;
        slowPlayer = true;
        hitTimer = 0;
      }
    } else {
      speedX = bSpeedX;
      speedY = bSpeedY;
    }
  }

//zorgt ervoor dat de speler tijdelijk langzamer word al de spin hem raakt
  void slowEffect() {
    slowTimer++;
    if (slowPlayer) {
      if (slowTimer >= slowTime) {
        player.speedX -= slowAmount;
        player.speedY -= slowAmount;
        slowed = true;
      }
      slowTimer = 0;
      slowPlayer = false;
    }
    if (slowTimer >= slowTime && slowed) {
      player.speedX += slowAmount;
      player.speedY += slowAmount;
      slowed = false;
    }
  }
}
