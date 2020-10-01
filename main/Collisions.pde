// auteur : Jordy Post

class Collisions {
  //word teruggegeven als boolean
  
  //werkt alleen als de objecten van de corner getekent worden
  boolean collisionCorner(float firstX, float firstY, float firstSizeX, float firstSizeY, float otherX, float otherY, float otherSizeX, float otherSizeY){
    boolean collide = false;
    if ((((firstX >= otherX && firstX <= (otherX + otherSizeX)) || ((firstX + firstSizeX >= otherX) && (firstX + firstSizeX) <= (otherX + otherSizeX))) && ((firstY >= otherY && firstY <= otherY + otherSizeY) || ((firstY + firstSizeY >= otherY) && (firstY + firstSizeY) <= (otherY + otherSizeY))))) collide = true;
    return collide;
  }
  
  //werkt alleen als object 1 van de corner getekent word en object 2 van de center
  boolean collisionCornerCenter(float firstX, float firstY, float firstSizeX, float firstSizeY, float otherX, float otherY, float otherSizeX, float otherSizeY){
    boolean collide = false;
    if ((((firstX >= otherX - (otherSizeX / 2) && firstX <= (otherX + (otherSizeX / 2))) || ((firstX + firstSizeX >= otherX- (otherSizeX / 2)) && (firstX + firstSizeX) <= (otherX + (otherSizeX / 2)))) && ((firstY >= otherY - (otherSizeY / 2) && firstY <= otherY + (otherSizeY / 2)) || ((firstY + firstSizeY >= otherY - (otherSizeY / 2)) && (firstY + firstSizeY) <= (otherY + (otherSizeY / 2)))))) collide = true;
    return collide;
  }
  
  //werkt alleen als de objecten van de center getekent worden
  boolean collisionCenter(float firstX, float firstY, float firstSizeX, float firstSizeY, float otherX, float otherY, float otherSizeX, float otherSizeY){
     boolean collide = false;
    if ((((firstX - (firstSizeX / 2) >= otherX - (otherSizeX / 2) && firstX - (firstSizeX / 2) <= (otherX + (otherSizeX / 2))) || ((firstX + (firstSizeX / 2) >= otherX - (otherSizeX / 2)) && (firstX + (firstSizeX / 2)) <= (otherX + (otherSizeX / 2)))) && ((firstY - (firstSizeY / 2) >= otherY - (otherSizeY / 2) && firstY - (firstSizeY / 2) <= otherY + (otherSizeY / 2)) || ((firstY + (firstSizeY / 2) >= otherY - (otherSizeY / 2)) && (firstY + (firstSizeY / 2)) <= (otherY + (otherSizeY / 2)))))) collide = true;
    return collide;
  }
  
}
