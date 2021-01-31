import peasy.*;
///PeasyCam library
ArrayList<Spheres> sphereList = new ArrayList<Spheres>();


String projectTitle = "Particle Simulation.";

PeasyCam cam;
//Spheres need to have a:
//Size, Color, Position, Velocity
class Spheres{
  float radius;
  color c;
  float[] position = new float[3];
  float[] velocity = new float[3];
  float rando;
  boolean fall;
  boolean goOut;
  float alpha;
  public Spheres(float radius, color c, float[] position, float[] velocity, float lifeSpan, boolean fall, boolean goOut, float alpha){
    this.radius = radius;
    this.c = c;
    this.position = position;
    this.velocity = velocity;
    this.rando = lifeSpan;
    this.fall = fall;
    this.goOut = goOut;
    this.alpha = alpha;
  }
 
  public void setPosition(float x, float y, float z){
    position[0] = x;
    position[1] = y;
    position[2] = z;
  }
 
  public void setVelocity(float x, float y, float z){
    velocity[0] = x;
    velocity[1] = y;
    velocity[2] = z;
  }
 
  public void setColor(float r, float g, float b){
    c = color(r, g, b);
  }
}
//Reflection = Velocity - 2(velocity dot normal) * normal

float curTime = 0;
float prevTime = 0;
float radius = 0.5;
float genRate = 1500;
float floor = -3;
float maxLifeSpan = 10;
PShape fountain, ball;

void setup(){
  size(1000, 1000, P3D);
  smooth(8);
  cam = new PeasyCam(this, 200);
  perspective(PI/3.0,(float)width/height,1,100000);
  //camera(0, 100, 50.0, 500, 500, 0.0, 1.0, 1.0, 1.0);
  frameRate(144);
  fountain = loadShape("C:\\Users\\chris\\Downloads\\fountainOBJ\\fountain.obj");
}
//add space bar function for camera
float thisTime = 0;
void draw(){

  background(color(135,206,250));
 
  pushMatrix();
  rotate(-1 * PI);
  shape(fountain, 0, 0.5);
  popMatrix();
  pushMatrix();
  lights();
  translate(25, -10, 0);
  noStroke();
  fill(128, 128, 128);
  sphere(10);
  popMatrix();
  
  if (keyPressed){
  float[] angleD = cam.getLookAt();
  float[] posD = cam.getPosition();
  float[] newThing = sub(angleD[0], angleD[1], angleD[2], posD[0], posD[1], posD[2]);
  float[] up = {0, 1, 0};
  newThing = cross(up, newThing);
  newThing = normalize(newThing);

  if (keyPressed && keyCode == RIGHT){
    //pushMatrix();
    beginCamera();
    translate(5 * newThing[0], 5 * newThing[1], 5* newThing[2]);
    endCamera();
        translate(-5 * newThing[0], -5 * newThing[1], -5* newThing[2]);

    //popMatrix();
  }
  else if (keyPressed && keyCode == LEFT){
    //pushMatrix();
    beginCamera();
    translate(-5 * newThing[0], -5 * newThing[1], -5* newThing[2]);
    endCamera();
    translate(5 * newThing[0], 5 * newThing[1], 5* newThing[2]);
    //popMatrix();
  }
  else if (keyPressed && keyCode == UP){
    //pushMatrix();
    beginCamera();
    translate(0, 5, 0);
    endCamera();
    translate(0, -5, 0);
    //popMatrix();
  }
  else if (keyPressed && keyCode == DOWN){
    //pushMatrix();
    beginCamera();
    translate(0, -5, 0);
    endCamera();
    //popMatrix();
    translate(0, 5, 0);
  }
  }
  pushMatrix();
  noStroke();
  rectMode(CENTER);
  fill(20, 150, 70);
  box(1000, 0, 1000);
  popMatrix();
  curTime = millis();
  //have a function that updates motion
  //for loop -> for all spheres in sphere list -> translate -> check for life span -> delete if necessary -> spawn new ones
 
  float dt = (curTime - prevTime)/1000;
  thisTime += dt;
  if (thisTime > 5){
    println("Total balls in scene currently: " + sphereList.size());
    println("Frames: " + frameRate);
    thisTime = 0;
  }

  beginShape(POINTS);
  //stroke(color(120, 120, 255));
  //tint(255, 127);  // Display at half opacity
  float dist = (float) cam.getDistance();
  strokeWeight(5 / (dist * .002));

  for (int i = 0; i < sphereList.size(); i++){
    if (sphereList.size() > 50000){
      sphereList.remove(i);
      i--;
    }
    else {
        //stroke(color(235 * sphereList.get(i).position[1] / -36, 235 * sphereList.get(i).position[1] / -36, 255));
        stroke(sphereList.get(i).c, sphereList.get(i).alpha);
        computePhysics(dt, sphereList.get(i));
        vertex((sphereList.get(i)).position[0], (sphereList.get(i)).position[1], (sphereList.get(i)).position[2]);
    }
  }
 
  //strokeWeight(10);
   // stroke(color(255,0,0));

  /*
  vertex(-25, -36, 0);
  vertex(0, -30, 0);
  vertex(25, -36, 0);
  vertex(0, -36, 25);
  vertex(0, -36, -25);
  vertex(0, -36, 0);
 
  vertex(-35, -1, 0);
  */
 // vertex(0, -36, 0);
  endShape();

  spawnParticles(dt);
  prevTime = curTime;
}

void computePhysics(float dt, Spheres curSphere){
  float acceleration = 9.8;
  curSphere.position[0] += curSphere.velocity[0] * dt;
  curSphere.position[1] += curSphere.velocity[1] * dt;
  curSphere.position[2] += curSphere.velocity[2] * dt;
 
  float distance = sqrt(sq(curSphere.position[0]) + sq(curSphere.position[2]));
  // BOTTOM DISC
  if (distance < 35 && abs(curSphere.position[1] - floor) <= radius){
    curSphere.position[1] = floor - radius  - 1;
    float[] arr = mult(curSphere.velocity[0], curSphere.velocity[1]*.1, curSphere.velocity[2], -1);
    curSphere.setVelocity(arr[0], 0.0000, arr[2]);
    curSphere.fall = false;
    curSphere.goOut = false;
   
   }
  if (distance > 35 && !curSphere.goOut){
    curSphere.position[1] = floor - radius  - 1;
    float[] arr = mult(curSphere.velocity[0], curSphere.velocity[1]*.1, curSphere.velocity[2], -1);
    curSphere.setVelocity(arr[0], 0.0000, arr[2]);
    curSphere.fall = false;
    curSphere.goOut = false;
  }
  else{
  // TOP DISC
    distance = sqrt(sq(curSphere.position[0]) + sq(curSphere.position[2]));
    if (distance < 26 && abs(curSphere.position[1] - (-36)) <= radius){
      curSphere.position[1] = -36;
      float [] normal = {0, -1, 0};
      float [] arr = reflection(curSphere, normal);
      curSphere.goOut = false;
      curSphere.setVelocity(arr[0], arr[1] * .1, arr[2]);
      curSphere.c = color(232 - 232*(distance/(50*curSphere.rando)), 244 - 244*(distance/(50 * curSphere.rando)), 248);
  }
  }
  
  float sphereDist = sqrt(sq(curSphere.position[0] - 25) + sq(curSphere.position[1] - (-10)) + sq(curSphere.position[2]));
  if (sphereDist <= 10 + (5/(float) cam.getDistance() * .002)){//(5 / ((float) cam.getDistance() * .002))){
    float wanted = 10 + (5/ (float) cam.getDistance() * .002);
    float curDist = wanted - sphereDist;
    float normX = curSphere.position[0] - 25;
    float normY = curSphere.position[1] - (-10);
    float normZ = curSphere.position[2] - 0;
    float[] arr = {normX, normY, normZ};
    arr = normalize(arr);
    float[] change = mult(arr[0], arr[1], arr[2], curDist);
    curSphere.position[0] += change[0];
    curSphere.position[1] += change[1];
    curSphere.position[2] += change[2];
    curSphere.goOut = true;
    float[] newArr = reflection(curSphere, arr);
    curSphere.setVelocity(newArr[0]*.3, newArr[1] *.2, newArr[2]*.3);
  }
  if (curSphere.position[1] > floor){
    curSphere.position[1] = floor;
  }

  //Reflection = Velocity - 2(velocity dot normal) * normal
  if (curSphere.fall){
    curSphere.velocity[1] += acceleration * dt;
    curSphere.c = color(232 - 232*(distance/(50*curSphere.rando)), 244 - 244*(distance/(50 * curSphere.rando)), 248);

  }
}

void spawnParticles(float dt){
  float numParticles = dt * genRate;
  float fracPart = numParticles - int(numParticles);
  numParticles = int(numParticles);
  if (random(0,1) < fracPart)
    numParticles += 1;
  for (int i = 0; i < numParticles; i++){
     float[] pos = rndPosition();
     float[] vel = {2.2*random(-1, 1), -15, 2.2*random(-1,1)};
     color c = color(232, 244, 248);
     //color should be based off position
     //life span?
     float alpha = random(0, 255);
     Spheres newSphere = new Spheres(radius, c, pos, vel, random(0.5,1), true, false, alpha);
     sphereList.add(newSphere);
  }
}

//Currently am using a 1 x 1 grid to spawn points off of.  This is a disc.
float[] rndPosition(){
     float r = 5 * random(0, 0.3);
     float theta = 2 * PI * random(0, 1);
     float x = sqrt(r) * sin(theta);
     float y = sqrt(r) * cos(theta);
     float[] pos = {x, -36.5, y};
     return pos;
}

  public float dot(float x1, float y1, float z1, float x2, float y2, float z2){
    float newX = x1 * x2;
    float newY = y1 * y2;
    float newZ = z1 * z2;
    return newX + newY + newZ;
}
 
  public float[] mult(float x, float y, float z, float scalar){
    float newX = x * scalar;
    float newY = y * scalar;
    float newZ = z * scalar;
    float arr[] = {newX, newY, newZ};
    return arr;
}
 
  public float[] sub(float x1, float y1, float z1, float x2, float y2, float z2){
    float newX = x1 - x2;
    float newY = y1 - y2;
    float newZ = z1 - z2;
    float arr[] = {newX, newY, newZ};
    return arr;
}

  public float[] normalize(float[] toBeNorm){
    float mag = sqrt(sq(toBeNorm[0]) + sq(toBeNorm[1]) + sq(toBeNorm[2]));
    float arr[] = new float[3];
    arr[0] = toBeNorm[0] / mag;
    arr[1] = toBeNorm[1] / mag;
    arr[2] = toBeNorm[2] / mag;
    return arr;
  }
  public float[] reflection(Spheres curSphere, float[] normal){
      float vel[];
      float result = dot(curSphere.velocity[0], curSphere.velocity[1], curSphere.velocity[2], normal[0], normal[1], normal[2]);
      result = 2 * result;
      vel = sub(curSphere.velocity[0], curSphere.velocity[1], curSphere.velocity[2], normal[0] * result, normal[1] * result, normal[2] * result);
      return vel;
  }
  
  public float[] cross(float[] arr1, float[] arr2){
    float[] newarr = {arr1[1]*arr2[2] - arr1[2]*arr2[1], arr1[2]*arr2[0] - arr1[0] * arr2[2], arr1[0]*arr2[1] - arr1[1]*arr2[0]};
    return newarr;
  }
