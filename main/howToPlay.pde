class howToPlay
{
  howToPlay()
  {
  }
  void menu()
  {
    background(0);
    
    textAlign(CENTER);
    fill(255);
    noStroke();

    textSize(45);
    text("How to play", width/2, height-600);
    text("press 'e' to go back", width/2, height-255);
    
    if (keyPressed == true)
    {
      if (key == 'e')
      {
        stage = 0;
      }
    }
  }
}
