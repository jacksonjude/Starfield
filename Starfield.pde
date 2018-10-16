import processing.sound.*;
SoundFile file;

ArrayList<Particle> particles = new ArrayList<Particle>();

float speed = 2.0;

boolean playingSound = false;

void setup()
{
  size(500, 500);

  particles.add(new OddballParticle(0, 0));
}

void draw()
{
  background(0);
  translate(width/2, height/2);

  if (mousePressed)
  {
    speed = ((mouseButton == LEFT) ? 4 : ((mouseButton == RIGHT) ? 8 : 0));
    if (!playingSound)
    {
      playingSound = true;
      //file = new SoundFile(this, "Nyan.mp3");
      //file.play();
    }
  }
  else
  {
    speed = 2;
    playingSound = false;
  }

  if (frameCount % ceil(4.0/speed) == 0)
  {
    particles.add(new NormalParticle());
  }

  if (frameCount % ceil(512.0/speed) == 0)
  {
    particles.add(new JumboParticle());
  }

  for (int i = 0; i < particles.size(); i++)
  {
    Particle particle = particles.get(i);
    particle.move();
    particle.show();

    if (particle.isOffScreen())
    {
      particles.remove(i);
    }
  }
}

class NormalParticle implements Particle
{
  float x, y, size;
  float theta;
  float red, green, blue;

  NormalParticle()
  {
    this.x = 0;
    this.y = 0;
    this.theta = (float)(Math.random()*2*3.1415);
    this.size = 5;
  }

  void move()
  {
    float radius = sqrt(x*x + y*y);
    x = (float)((radius+speed) * Math.cos(theta));
    y = (float)((radius+speed) * Math.sin(theta));
  }

  void show()
  {
    updateRGB();
    fill(red, green, blue);
    ellipse(x, y, size, size);
  }

  void updateRGB()
  {
    int rgb = HSBtoRGB((float)(frameCount%(100/speed))/(100.0/speed), 1.0, 1.0);
    this.red = (rgb>>16)&0xFF;
    this.green = (rgb>>8)&0xFF;
    this.blue = rgb&0xFF;
  }

  boolean isOffScreen()
  {
    return (this.x < -(width/2)-(this.size/2) || this.x > (width/2)+(this.size/2) || this.y < -(height/2)-(this.size/2) || this.y > (height/2)+(this.size/2));
  }
}

interface Particle
{
	void move();
  void show();
  boolean isOffScreen();
}

class OddballParticle implements Particle
{
  float x, y;
  final float size = 10;
  final float xAttract = (float)(Math.random()*width)-width/2;
  final float yAttract = (float)(Math.random()*height)-height/2;

  OddballParticle(float x, float y)
  {
    this.x = x;
    this.y = y;
  }

  void move()
  {
    float xMult = (xAttract - x > 0) ? speed : -speed;
    float yMult = (yAttract - y > 0) ? speed : -speed;

    x += ((Math.random()*4*xMult)-(2/xMult));
    y += ((Math.random()*4*yMult)-(2/yMult));
  }

  void show()
  {
    beginShape();
    vertex(x - size, y - sqrt(3) * size);
    vertex(x + size, y - sqrt(3) * size);
    vertex(x + 2 * size, y);
    vertex(x + size, y + sqrt(3) * size);
    vertex(x - size, y + sqrt(3) * size);
    vertex(x - 2 * size, y);
    endShape(CLOSE);
  }

  boolean isOffScreen()
  {
    return (this.x < -(width/2)-(this.size/2) || this.x > (width/2)+(this.size/2) || this.y < -(height/2)-(this.size/2) || this.y > (height/2)+(this.size/2));
  }
}

class JumboParticle extends NormalParticle
{
  JumboParticle()
  {
    super();

    size = 25;
  }
}

int HSBtoRGB(float hue, float saturation, float brightness)
{
  if (saturation == 0)
    return convert(brightness, brightness, brightness, 0);
  if (saturation < 0 || saturation > 1 || brightness < 0 || brightness > 1)
    throw new IllegalArgumentException();
  hue = hue - (float) Math.floor(hue);
  int i = (int) (6 * hue);
  float f = 6 * hue - i;
  float p = brightness * (1 - saturation);
  float q = brightness * (1 - saturation * f);
  float t = brightness * (1 - saturation * (1 - f));
  switch (i)
  {
  case 0:
    return convert(brightness, t, p, 0);
  case 1:
    return convert(q, brightness, p, 0);
  case 2:
    return convert(p, brightness, t, 0);
  case 3:
    return convert(p, q, brightness, 0);
  case 4:
    return convert(t, p, brightness, 0);
  case 5:
    return convert(brightness, p, q, 0);
  default:
    throw new InternalError("impossible");
  }
}

int convert(float red, float green, float blue, float alpha)
{
  if (red < 0 || red > 1 || green < 0 || green > 1 || blue < 0 || blue > 1 || alpha < 0 || alpha > 1)
    throw new IllegalArgumentException("Bad RGB values");
  int redval = Math.round(255 * red);
  int greenval = Math.round(255 * green);
  int blueval = Math.round(255 * blue);
  int alphaval = Math.round(255 * alpha);
  return (alphaval << 24) | (redval << 16) | (greenval << 8) | blueval;
}
