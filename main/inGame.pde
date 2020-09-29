class inGame
{
  inGame()
  {
  }
  void menu()
  {
    background(0);
    
    textAlign(CENTER);
    fill(255);
    noStroke();

    textSize(45);
    text("The inGame screen", width/2, height-600);
    text("press 'e' to go back", width/2, height-255);
    text("press 'z' to go to gameOver screen", width/2, height-200);
    
    if (keyPressed == true)
    {
      if (key == 'e')
      {
        stage = 0;
      }
      if (key == 'z')
      {
        stage = 4;
      }
    }
  }
}
