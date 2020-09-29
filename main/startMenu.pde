class startMenu {
  int highlightPosition = 0;
  final InputHandler inputHandler;

  startMenu(InputHandler inputHandler) {
    this.inputHandler = inputHandler;
  }

  void menu() {
    background(0);

    rectMode(CENTER);
    fill(30);
    stroke(255);
    strokeWeight(5);

    rect(width/2, height-272, 300, 50);
    rect(width/2, height-210, 250, 35);
    rect(width/2, height-160, 250, 35);
    rect(width/2, height-106, 100, 25);


    textAlign(CENTER);
    fill(255);
    noStroke();

    textSize(45);
    text("Speedy Bombs", width/2, height-600);
    text("START", width/2, height-255);
    textSize(32);
    text("How to play", width/2, height-200);
    text("Highscores", width/2, height-150);
    textSize(20);
    text("Exit", width/2, height-100);

    switch(highlightPosition) {
    case 0:
      stroke(255, 0, 0);
      strokeWeight(5);
      noFill();
      rect(width/2, height-272, 300, 50);

      if (keyPressed)
      {
        if (inputHandler.aa)
        {
          stage = 1;
        }
        if (key == CODED)
        {
          if (keyCode == DOWN)
          {
            highlightPosition = 1;
            keyPressed = false;
          }
        }
      }
      return;
    case 1:
      stroke(255, 0, 0);
      strokeWeight(5);
      noFill();
      rect(width/2, height-210, 250, 35);

      if (keyPressed)
      {
        if (key == 'a')
        {
          stage = 2;
        }
        if (key == CODED)
        {
          if (keyCode == UP)
          {
            highlightPosition = 0;
            keyPressed = false;
          }
          if (keyCode == DOWN)
          {
            highlightPosition = 2;
            keyPressed = false;
          }
        }
      }
      return;
    case 2:
      stroke(255, 0, 0);
      strokeWeight(5);
      noFill();
      rect(width/2, height-160, 250, 35);

      if (keyPressed)
      {
        if (key == 'a')
        {
          stage = 3;
        }
        if (key == CODED)
        {
          if (keyCode == UP)
          {
            highlightPosition = 1;
            keyPressed = false;
          }
          if (keyCode == DOWN)
          {
            highlightPosition = 3;
            keyPressed = false;
          }
        }
      }
      return;
    case 3:
      stroke(255, 0, 0);
      strokeWeight(5);
      noFill();
      rect(width/2, height-106, 100, 25);

      if (keyPressed)
      {
        if (key == 'a')
        {
          exit();
        }
        if (key == CODED)
        {
          if (keyCode == UP)
          {
            highlightPosition = 2;
            keyPressed = false;
          }
        }
      }
      return;
    }
  }
}
