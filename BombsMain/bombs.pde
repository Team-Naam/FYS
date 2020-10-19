class Bomb extends Object {

  int bombTimer = 5000;
  int bombOpacity = 255;
  int startTime;
  int explosionOpacity = 255;
  int explosionRadius = 0;


  Bomb(int x, int y, int w, int h, ObjectHandler objectHandler, Sprites sprites) {
    super (x, y, w, h, ObjectID.BOMB, objectHandler, sprites);
    startTime = millis();
  }

  void ifTouching(Object crate) {
  }

  void update() {
    if ( bombExploded()) {
      if (explosionRadius < 400) explosionRadius += 25;
      if (explosionRadius >= 200){
        explosionOpacity -=5;
        bombOpacity = 0;
      }
      if (explosionOpacity <= 0) objectHandler.removeEntry(this);
    }
  }

  void draw() {

    fill(0, bombOpacity);
    if(bombOpacity == 0) noStroke();
    rect(x, y, 32, 32);
    fill(235, 109, 30, explosionOpacity);
    noStroke();
    circle(x + w, y + h, explosionRadius);
    stroke(1);
  }

  boolean bombExploded() {
    if ( millis() > startTime + bombTimer) return true;
    return false;
  }

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
  //  if (input.xDown()) {
  //    int i=0;
  //    while (pose[i][0]==1)
  //    {
  //      i++;
  //    }

  //    pose[i][0]=1;
  //    pose[i][1]=playerPosX;
  //    pose[i][2]=playerPosY;
  //    pose[i][3]=millis() + 5000;
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
  //      }
  //    }
  //  }
  //}
}
//  void draw() 
//  {
//    bombes();
//    location();
//    explosion();
//  }





//  boolean clic() 
//  {
//    if (keyPressed==false) 
//    {
//      m=true;
//    }
//    if (m == true && keyPressed == true && key == 'b') 
//    {
//      m=false;
//      return true;
//    } else 
//    {
//      return false;
//    }
//  }


//}
