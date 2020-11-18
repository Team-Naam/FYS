/* Vanuit hier kun je methods gebruiken die geschreven zijn voor het project en op meerdere manieren gebruikt kunnen worden.
 Als je iets toevoegd, zet je credit erbij en een uitleg
 */

//Code credit Ole Neuman
class InputHandler {

  //checks if the leftArrow key is held down, and returns true if it is
  boolean leftDown() {
    if (keysPressed[37]) return true;
    return false;
  }

  //checks if the rightArrow key is held down, and returns true if it is
  boolean rightDown() {
    if (keysPressed[39]) return true;
    return false;
  }

  //checks if the upArrow key is held down, and returns true if it is
  boolean upDown() {
    if (keysPressed[38]) return true;
    return false;
  }

  //checks if the downArrow key is held down, and returns true if it is
  boolean downDown() {
    if (keysPressed[40]) return true;
    return false;
  }

  //checks if the A is held down, and returns true if it is
  boolean aDown() {
    if (keysPressed[65]) return true;
    return false;
  }

  //checks if the Z key is held down, and returns true if it is
  boolean zDown() {
    if (keysPressed[90]) return true;
    return false;
  }

  //checks if the S key is held down, and returns true if it is
  boolean sDown() {
    if (keysPressed[83]) return true;
    return false;
  }

  //checks if the X key is held down, and returns true if it is
  boolean xDown() {
    if (keysPressed[88]) return true;
    return false;
  }

  //checks if the ESCAPE key is held down, and returns true if it is
  boolean escapeDown() {
    if (keysPressed[27]) return true;
    return false;
  }
}

/*Code credit Winand
 Random getal van -1 tot 1*/
int randomOnes() {
  return (int) random(3) - 1;
}

class Timer {

  int startTime;
  boolean start = true;

  Timer() {
  }

  boolean startTimer(int countDownTime) {
    int time = millis();
    if (start) {
      startTime = millis();
      start = false;
    }
    int passedTime = time - startTime;
    if (passedTime > countDownTime) {
      startTime = 0;
      time = 0;
      start = true;
      return true;
    }
    return false;
  }
}

class Ray {

  PVector pos, dir;

  Ray(PVector pos, float dirX, float dirY) {
    this.pos = pos;
    dir = new PVector(dirX, dirY);
  }

  //Method die checkt of de ray een andere lijn snijd, input is beginpunt en eindpunt van een een lijn
  //Orginele bron, afgeleid van: https://ncase.me/sight-and-light/
  PVector getIntersection(PVector wall_a, PVector wall_b) {
    //Ray in parametric: Point + Delta * T1
    float r_px = pos.x;
    float r_py = pos.y;
    float r_dx = dir.x - pos.x;
    float r_dy = dir.y - pos.y;

    //Wall in parametric: Point + Delta * T2
    float s_px = wall_a.x;
    float s_py = wall_a.y;
    float s_dx = wall_b.x - wall_a.x;
    float s_dy = wall_b.y - wall_a.y;

    //Check if they are parrellel, if not, return null
    double r_mag = Math.sqrt(r_dx*r_dx+r_dy*r_dy);
    double s_mag = Math.sqrt(s_dx*s_dx+s_dy*s_dy);
    if (r_dx / r_mag == s_dx / s_mag && r_dy / r_mag == s_dy / s_mag) {
      return null;
    }

    //Check if the ray intersects the wall, T2 & T1 are the line's gradients (Slopes) 
    float T2 = (r_dx * (s_py - r_py) + r_dy * (r_px - s_px)) / (s_dx * r_dy - s_dy * r_dx);
    float T1 = (s_px + s_dx * T2 - r_px) / r_dx;

    //Must be within the parametic whatevers for ray/wall
    if (T1 < 0) { 
      return null;
    }
    if (T2 < 0 || T2 > 1) {
      return null;
    } else {
      // Return the point of intersection
      PVector pt = new PVector();
      pt.x = r_px + r_dx * T1;
      pt.y = r_py + r_dy * T1;
      //pt.z = T1;

      return pt;
    }
  }
}
