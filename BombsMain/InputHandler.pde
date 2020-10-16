/* Hierin beschrijven wat alle keys doen dus up, down, left, right, a, z, s, x, escape
 dus dan hoef je alleen method op te roepen voor true of false */
class InputHandler {
  
  //checks if the leftArrow key is held down, and returns true if it is
  boolean leftDown(){
    if(keysPressed[37]) return true;
    return false;
  }
  
  //checks if the rightArrow key is held down, and returns true if it is
  boolean rightDown(){
   if(keysPressed[39]) return true;
   return false;
  }
  
  //checks if the upArrow key is held down, and returns true if it is
  boolean upDown(){
   if(keysPressed[38]) return true;
   return false;
  }
  
  //checks if the downArrow key is held down, and returns true if it is
  boolean downDown(){
   if(keysPressed[40]) return true;
   return false;
  }
  
  //checks if the A is held down, and returns true if it is
  boolean aDown(){
   if(keysPressed[65]) return true;
   return false;
  }
  
  //checks if the Z key is held down, and returns true if it is
  boolean zDown(){
   if(keysPressed[90]) return true;
   return false;
  }
  
  //checks if the S key is held down, and returns true if it is
  boolean sDown(){
   if(keysPressed[83]) return true;
   return false;
  }
  
  
  //checks if the X key is held down, and returns true if it is
  boolean xDown(){
   if(keysPressed[88]) return true;
   return false;
  }
  
  //checks if the ESCAPE key is held down, and returns true if it is
  boolean escapeDown(){
   if(keysPressed[27]) return true;
   return false;
  }
}
