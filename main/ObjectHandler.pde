import java.util.List;
import java.util.ArrayList;

class ObjectHandler {

  List<Entity> entities = new ArrayList<Entity>();
  Player player = null;

  InputHandler inputHandler;

  ObjectHandler(InputHandler inputHandler) {
    this.inputHandler = inputHandler;
  }

  void addWall(int x, int y, int w, int h) {
    Wall wall = new Wall(x, y, w, h, this);
    entities.add(wall);
  }

  //void addGhost(int x, int y, int w, int h) {

  //  entities.add();
  //}

  //void addMummy(int x, int y, int w, int h) {

  //  entities.add();
  //}

  //void addSpider(int x, int y, int w, int h) {

  //  entities.add();
  //}

  //void addPlayer(int x, int y, int w, int h) {

  //  entities.add(player);
  //}

  void removeEntity(Entity entity) {
    entities.remove(entity);
  }

  void update() {
    List<Entity> objects = entities;
    for (int i = 0; i < objects.size(); i++) {
      if (i >= objects.size()) {
        break;
      }
      objects.get(i).update();
    }
  }

  void draw() {
    List<Entity> objects = entities;
    for (int i = 0; i < objects.size(); i++) {
      if (i >= objects.size()) {
        break;
      }
      objects.get(i).draw();
    }
  }
}

enum ObjectID {
  PLAYER, WALL
}
