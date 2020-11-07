//Code credit Winand Metz & Ole Neuman
//Class for moving shadow emitter
class Emitter {

  ObjectHandler objectHandler;

  ArrayList<Ray> rays = new ArrayList<Ray>(); 
  ArrayList<PVector> lightVertices = new ArrayList<PVector>();
  ArrayList<PVector> sortedLightVertices = new ArrayList<PVector>();

  PVector pos;

  PShape lightPoly;

  Emitter(ObjectHandler objectHandler) {
    this.objectHandler = objectHandler;
    this.pos = new PVector(width / 2, height / 2);
  }

  void update(float x, float y) {
    //Bepaald de plek van de emitter
    this.pos.set(x + 10, y + 10);
    /*Zoekt van de Wall en Rock objecten alle hoekpunten op
     Schiet hier een ray naar toe met elk twee extra rays die net zijonder en zijboven zitten van de orginele ray
     Dit helpt met de vloeiendheid wanneer de emitter beweegt en de schaduwen van plek veranderen*/
    for (Object object : objectHandler.entries) {
      if (object.objectId == ObjectID.WALL || object.objectId == ObjectID.ROCK) {
        if (dist(pos.x, pos.y, object.x, object.y) < RAY_DISTANCE) { //checkt alleen rays voor objecten binnen RAY_DISTANCE pixels van de emitter
          rays.add(new Ray(pos, object.lb.x, object.lb.y));
          rays.add(new Ray(pos, object.rb.x, object.rb.y));
          rays.add(new Ray(pos, object.ro.x, object.ro.y));
          rays.add(new Ray(pos, object.lo.x, object.lo.y));

          rays.add(new Ray(pos, object.lb.x + 0.001, object.lb.y + 0.001));
          rays.add(new Ray(pos, object.rb.x + 0.001, object.rb.y + 0.001));
          rays.add(new Ray(pos, object.ro.x + 0.001, object.ro.y + 0.001));
          rays.add(new Ray(pos, object.lo.x + 0.001, object.lo.y + 0.001));

          rays.add(new Ray(pos, object.lb.x - 0.001, object.lb.y - 0.001));
          rays.add(new Ray(pos, object.rb.x - 0.001, object.rb.y - 0.001));
          rays.add(new Ray(pos, object.ro.x - 0.001, object.ro.y - 0.001));
          rays.add(new Ray(pos, object.lo.x - 0.001, object.lo.y - 0.001));
        }
      }
    }
  }

  //Method voor bepalen van waar de rays een ander object doorkruizen
  void cast(ArrayList<Object> entries) {
    for (Ray ray : rays) {
      PVector closest = null;
      float record = width; //Voor optimization redenen staat deze op width, bepaald hoe ver de ray max mag komen
      for (Object object : entries) {
        if (object.objectId == ObjectID.WALL || object.objectId == ObjectID.ROCK) { //Safe wall dat hij alleen de waardes pakt van Wall en Rock
          PVector intUp = ray.getIntersection(object.lb, object.rb); //Checkt intersectie met bovenkant
          PVector intRight = ray.getIntersection(object.rb, object.ro); //Checkt intersectie met rechterkant
          PVector intDown = ray.getIntersection(object.ro, object.lo); //Checkt intersectie met onderkant
          PVector intLeft = ray.getIntersection(object.lo, object.lb); //Checkt intersectie met linkerkant
          if (intUp != null ) { //Als er een intersectie plaatsvind bij bovenkant ga verder
            float d = PVector.dist(this.pos, intUp); //Afstand tussen de emitter en intersectie
            if (d < record) { //Als afstand kleiner is dan de width ga verder
              record = d;
              closest = intUp; //Closest is uitkomst van intersectie punt
            }
          }  
          if (intRight != null ) {
            float d = PVector.dist(this.pos, intRight);
            if (d < record) {
              record = d;
              closest = intRight;
            }
          }  
          if (intDown != null ) {
            float d = PVector.dist(this.pos, intDown);
            if (d < record) {
              record = d;
              closest = intDown;
            }
          }  
          if (intLeft != null ) {
            float d = PVector.dist(this.pos, intLeft);
            if (d < record) {
              record = d;
              closest = intLeft;
            }
          }
        }
      }
      //Safe wall voor toevoegen closest aan de list met vertices
      if (closest != null) { 
        lightVertices.add(closest);
      }
    }
    //Schoon de rays arraylist
    rays.clear();
    //Sorteer alle punten op hoek tegenover de emitter
    sortList();
  }

  void sortList() {
    while (lightVertices.size() > 0) {
      float biggestAngle = 0;
      int biggestAngleIndex = 0;
      float currentVertexAngle = 0;
      for (int i = 0; i < lightVertices.size(); i++ ) {
        currentVertexAngle = angleCalculationMagic(lightVertices.get(i));
        if (currentVertexAngle > biggestAngle) {
          biggestAngle = currentVertexAngle;
          biggestAngleIndex = i;
        }
      }
      sortedLightVertices.add(lightVertices.get(biggestAngleIndex));
      lightVertices.remove(biggestAngleIndex);
    }
  }

  float angleCalculationMagic(PVector vertex) {
    boolean aboveEmitter;
    boolean rightOfEmitter;

    float vertexX = vertex.x;
    float vertexY = vertex.y;

    float distanceX = 0;
    float distanceY = 0;

    float basicRadiansBetweenEmitterAndVertex = 0;
    float trueRadiansBetweenEmitterAndVertex = 0;

    if (vertexX > pos.x) {
      distanceX = vertexX - pos.x;
      rightOfEmitter = true;
    } else {
      distanceX = pos.x - vertexX;
      rightOfEmitter = false;
    }

    if (vertexY > pos.y) {
      distanceY = vertexY - pos.y;
      aboveEmitter = true;
    } else {
      distanceY = pos.y - vertexY;
      aboveEmitter = false;
    }

    basicRadiansBetweenEmitterAndVertex = atan(distanceY/distanceX);
    if (rightOfEmitter && aboveEmitter) {
      trueRadiansBetweenEmitterAndVertex = HALF_PI - basicRadiansBetweenEmitterAndVertex;
    } else if (rightOfEmitter && !aboveEmitter) {
      trueRadiansBetweenEmitterAndVertex = HALF_PI + basicRadiansBetweenEmitterAndVertex;
    } else if (!rightOfEmitter && !aboveEmitter) {
      trueRadiansBetweenEmitterAndVertex = PI + HALF_PI - basicRadiansBetweenEmitterAndVertex;
    } else {
      trueRadiansBetweenEmitterAndVertex = PI + HALF_PI + basicRadiansBetweenEmitterAndVertex;
    }
    return trueRadiansBetweenEmitterAndVertex;
  }

  //Maken van de lightpoly op basis van de sorted light vertices, neemt de grijswaarde in
  PShape getShape(int col) {
    lightPoly = createShape();
    lightPoly.beginShape();
    lightPoly.noStroke();
    lightPoly.fill(col);
    for (PVector vertex : sortedLightVertices) {
      lightPoly.vertex(vertex.x, vertex.y);
    }
    lightPoly.endShape();
    sortedLightVertices.clear();
    lightVertices.clear();

    return lightPoly;
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
    //Ray in parametric: Point + Delta*T1
    float r_px = pos.x;
    float r_py = pos.y;
    float r_dx = dir.x - pos.x;
    float r_dy = dir.y - pos.y;

    //Wall in parametric: Point + Delta*T2
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
    float T1 = (s_px + s_dx * T2-r_px) / r_dx;

    //Must be within the parametic whatevers for ray/wall
    if (T1 < 0) { 
      return null;
    }
    if (T2 < 0 || T2 > 1) {
      return null;
    } else {
      // Return the point of intersection
      PVector pt = new PVector();
      pt.x = r_px+r_dx * T1;
      pt.y = r_py+r_dy * T1;
      //pt.z = T1;

      return pt;
    }
  }
}
