class gameOver
{
  gameOver()
  {
  }
  void menu()
  {
    background(0);
    
    textAlign(CENTER);
    fill(255);
    noStroke();

    textSize(45);
    text("u ded", width/2, height-600);
    text("press 'e' to go back to main menu", width/2, height-255);
    
    if (keyPressed == true)
    {
      if (key == 'e')
      {
        stage = 0;
      }
    }
  }
}
