ArrayList<Particle> particles = new ArrayList<Particle>();

void setup()
{
  size(500, 500);
}

void draw()
{
  background(204);
  translate(width/2, height/2);
  if (frameCount % 4 == 0)
  {
    particles.add(new NormalParticle(0, 0, 5));
  }

  for (int i = 0; i < particles.size(); i++)
  {
    Particle particle = particles.get(i);
    particle.move();
    particle.show();
  }
}

class NormalParticle implements Particle
{
  float x, y, theta, size;
  NormalParticle(float x, float y, float size)
  {
    this.x = x;
    this.y = y;
    this.theta = (float)(Math.random()*2*3.1415);
    this.size = size;
  }

  void move()
  {
    float radius = sqrt(x*x + y*y);
    x = (float)((radius+1) * Math.cos(theta));
    y = (float)((radius+1) * Math.sin(theta));
  }

  void show()
  {
    ellipse(x, y, size, size);
  }
}

interface Particle
{
	void move();
  void show();
}

class OddballParticle implements Particle
{
  void move()
  {

  }

  void show()
  {

  }
}

class JumboParticle extends NormalParticle
{
  JumboParticle(float x, float y)
  {
    super(x, y, 100.0);
  }
}
