class Particle
{
  float x, xDiff;
  float y, yDiff;
  float size;
  color currentColor, startColor;

  boolean active = false;

  void activate(float x, float y)
  {
    this.x = x;
    this.y = y;
    active = true; 
    size = random(10, 50);
    currentColor = color(255, 64 + random(128), 0);
    startColor = currentColor;

    xDiff = random(1, 3);
    yDiff = random(2, 5);
  }

  void draw()
  {
    if (active)
    {
      update();
      fill(currentColor);
      circle(x, y, size/2);
    }
  }

  void update()
  {
    size -= 0.5;
    x -= Math.sin(size / 5) * xDiff;
    y -= yDiff;
    if (size <= 0)
    {
      active = false;
    }
    currentColor = lerpColor(color(0), startColor, size / 15);
  }
}
