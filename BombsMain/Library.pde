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
