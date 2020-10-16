class explode
{
  float x;
  float y;
  float size;

  Particle[] particles = new Particle[250];

  explode(float x, float y, float size)
  {
    this.x = x;
    this.y = y;
    this.size = size;

    for ( int i = 0; i < particles.length; i++)
    {
      particles[i] = new Particle();
    }
  }

  void drawParticle()
  {
    fill(255, 0, 0);
    ellipse(x, y, size/2, size/2);
    noFill();
  }
}
