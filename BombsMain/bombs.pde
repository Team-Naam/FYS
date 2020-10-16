class Bombs
{
  int[][] pose= new int[10][10];
  boolean m;
  int locX = 50;
  int locY = 50;
  int size = 100;

  Explode[] explode;

  void setup() 
  {
    size(1600, 900);

    explode = new Explode[10];
    for (int i = 0; i < explode.length; i ++)
    {
      explode[i] = new Explode(locX, locY, size);
    }
  }

  void draw() 
  {
    background(0);
    noFill();
    stroke(255);
    strokeWeight(5);
    rectMode(CENTER);
    rect(locX, locY, size, size);
    noStroke();
    fill(255);
    bombes();
    location();
    explosion();
  }

  void bombes() 
  {

    for (int i=0; i<10; i++)
    {
      if (pose[i][0]==1) 
      {
        ellipseMode(CENTER);
        ellipse(pose[i][1], pose[i][2], 50, 50);
      }
    }
  }

  void location() 
  {
    if (clic()==true)
    {
      int i=0;
      while (pose[i][0]==1)
      {
        i++;
      }

      pose[i][0]=1;
      pose[i][1]=locX;
      pose[i][2]=locY;
      pose[i][3]=millis() + 5000;
    }
  }

  boolean clic() 
  {
    if (keyPressed==false) 
    {
      m=true;
    }
    if (m == true && keyPressed == true && key == 'b') 
    {
      m=false;
      return true;
    } else 
    {
      return false;
    }
  }

  void explosion()
  {
    for (int i=0; i<10; i++)
    {
      if (pose[i][3]<(millis()) && pose[i][0]!=0) 
      {
        for (int j=0; j<4; j++) 
        {
          pose[i][j]=0;
          background(255);
        }
      }
    }
  }
}
