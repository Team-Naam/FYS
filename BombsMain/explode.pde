class Explode
{
  float x;
  float y;
  float size;

  Particle[] particles = new Particle[250];

  Explode(float x, float y, float size)
  {
    this.x = x;
    this.y = y;
    this.size = size;
    
    for ( int i = 0; i < particles.length; i++)
    {
      particles[i] = new Particle();
    }
  }
}
