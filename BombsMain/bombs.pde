//int[][] pose= new int[10][10];
//boolean m;
//int x = 50;
//int y = 50;
//int size = 100;

//explode[] explode;

//void setup() 
//{
//  size(1600, 900);

//  explode = new explode[10];
//  for (int i = 0; i < explode.length; i ++)
//  {
//    explode[i] = new explode(x, y, size);
//  }
//}

//void draw() 
//{
//  background(0);
//  noFill();
//  stroke(255);
//  strokeWeight(5);
//  rectMode(CENTER);
//  rect(x, y, size, size);
//  noStroke();
//  fill(255);
//  bombes();
//  location();
//  explosion();
//  outOfBounds();
//}

//void outOfBounds() 
//{
//  if (x >=width)
//  {
//    x = size / 2;
//  }
//  if (x < 0)
//  {
//    x = width-size / 2;
//  }
//  if (y >=height)
//  {
//    y = size / 2;
//  }
//  if (y < 0)
//  {
//    y = height-size / 2;
//  }
//}
//void bombes() 
//{

//  for (int i=0; i<10; i++)
//  {
//    if (pose[i][0]==1) 
//    {
//      ellipseMode(CENTER);
//      ellipse(pose[i][1], pose[i][2], 50, 50);
//    }
//  }
//}

//void location() 
//{
//  if (clic()==true)
//  {
//    int i=0;
//    while (pose[i][0]==1)
//    {
//      i++;
//    }

//    pose[i][0]=1;
//    pose[i][1]=x;
//    pose[i][2]=y;
//    pose[i][3]=millis() + 5000;
//  }
//}

//boolean clic() 
//{
//  if (keyPressed==false) 
//  {
//    m=true;
//  }
//  if (m == true && keyPressed == true && key == 'b') 
//  {
//    m=false;
//    return true;
//  } else 
//  {
//    return false;
//  }
//}

//void explosion()
//{
//  for (int i=0; i<10; i++)
//  {
//    if (pose[i][3]<(millis()) && pose[i][0]!=0) 
//    {
//      for (int j=0; j<4; j++) 
//      {
//        pose[i][j]=0;
//        background(255);
//        drawParticle();
//      }
//    }
//  }
//}

//void keyPressed() 
//{
//  if (key == CODED)
//  {
//    if (keyCode == UP) 
//    {
//      y = y -100;
//    } else if (keyCode == DOWN)
//    {
//      y = y +100;
//    } 
//    if (keyCode == RIGHT)
//    {
//      x = x +100;
//    } else if (keyCode == LEFT) 
//    {
//      x = x -100;
//    }
//  }
//}
