import processing.sound.*;

import peasy.*;

//Individually update color
//Individually update size
//Individually update transparency

//Add some form of interraction with non-floor?

String projectTitle = "Kamehameha";
ArrayList<Spheres> sphereListFront = new ArrayList<Spheres>();
ArrayList<Spheres> sphereListBottom = new ArrayList<Spheres>();
ArrayList<Spheres> sphereListMiddle = new ArrayList<Spheres>();
ArrayList<Spheres> sphereListBack = new ArrayList<Spheres>();
ArrayList<Spheres> sphereListTLD = new ArrayList<Spheres>();
ArrayList<Spheres> sphereListTRD = new ArrayList<Spheres>();
ArrayList<Spheres> sphereListBLD = new ArrayList<Spheres>();
ArrayList<Spheres> sphereListBRD = new ArrayList<Spheres>();


ArrayList<ArrayList<Spheres>> allSpheres = new ArrayList<ArrayList<Spheres>>();

ArrayList<Spheres> Kamehameha = new ArrayList<Spheres>();

PeasyCam cam;
enum Direction{
  
    UP, DOWN, LEFT, RIGHT, DEFAULT, DL, DR, UL, UR 
  }
class Spheres{
  float radius;
  float[] position = new float[3];
  float[] velocity = new float[3];
  float[] origVel = new float[3];
  float thicc;
  float lifeSpan;
  Direction direction;
  float alpha;
  color c;
  float[] dest = new float[3];
  
  public Spheres(float radius,float[] position, float[] velocity, float origVel[], float thicc, float lifeSpan, Direction direction, float alpha, color c, float[] dest){
    this.radius = radius;
    this.position = position;
    this.velocity = velocity;
    this.origVel = origVel;
    this.thicc = thicc;
    this.lifeSpan = lifeSpan;
    this.direction = direction;
    this.alpha = alpha;
    this.c = c;
    this.dest = dest;
  }
}
 


float curTime = 0;
float prevTime = 0;
float radius = 0.1;
float genRate = 5000;
float kgenRate = 2000;
float floor = 0;
float thisTime;
PShape goku;
float discRadius = 15;
float timeStoodStill = 0;
SoundFile kidGoku;
PShape tree;
float maxDistance;
float dt;
boolean mouseMode = true;

void setup(){
  size(2000, 2000, P3D);
  //perspective(PI/3.0, (float) width/height, 1, 100000);

  kidGoku = new SoundFile(this, "KidGoku.mp3");
  goku = loadShape("C:\\Users\\chris\\Downloads\\Goku (1)\\Goku\\goku-1d.obj");
  goku.scale(5);
  kidGoku.play();
  maxDistance = 5000;
  //tree = loadShape("C:\\Users\\chris\\Desktop\\Tree\\Tree_OBJ.obj");
  //tree.scale(0.5);
  allSpheres.add(sphereListFront);  //0
  allSpheres.add(sphereListBottom); //1
  allSpheres.add(sphereListMiddle); //
  allSpheres.add(sphereListBack);   //
  allSpheres.add(sphereListTLD);    //4
  allSpheres.add(sphereListTRD);    //
  allSpheres.add(sphereListBLD);    //6
  allSpheres.add(sphereListBRD);    //
  
}

void draw(){
  curTime = millis();
  background(color(25,25,112));
  dt = (curTime - prevTime)/1000;
  
  pushMatrix();
  
  rotateX(radians(180));
  rotateY(radians(90));
  translate(0, -1 * mouseY, mouseX);
  shape(goku, 0, 0); 

  popMatrix();
  /*
  //shape(tree, 0, 0);
  noStroke();
  fill(150, 75, 0);
  rect(600, 1000, 200, 1000);
  pushMatrix();
  fill(0, 170, 0);
  circle(500, 800, 700);
  circle(900, 1000, 500);
  circle(900, 700, 300);
  fill(0, 200, 0);
  noStroke();
  ellipse(1000, 2000, 2200, 700);

  popMatrix();
*/
  thisTime += dt;
  if (thisTime >= 3){
    println("Total balls in scene currently: " + getSpheres());
    
    thisTime = 0;
  }
  if (mouseX == pmouseX && mouseY == pmouseY)
    timeStoodStill += dt;
  else
    timeStoodStill = 0;
    
    for (int i = 0; i < 8; i++){
      for (int j = 0; j < allSpheres.get(i).size(); j++){ 
        Spheres curSphere = allSpheres.get(i).get(j);
         if ((abs(mouseX - curSphere.position[0]) > 600 || abs(mouseY - curSphere.position[1]) > 400) && curSphere.lifeSpan > 1.0|| curSphere.lifeSpan > 1.0){
           allSpheres.get(i).remove(j);
           j--;
         }
         else{
            beginShape(POINTS);
            stroke(curSphere.c, curSphere.alpha);
            strokeWeight(curSphere.thicc);
            computePhysics(dt, curSphere);
            vertex(curSphere.position[0], curSphere.position[1], curSphere.position[2]);  
            endShape();

        }
      }
    }
    
    for (int i = 0; i < Kamehameha.size(); i++){

      Spheres curSphere = Kamehameha.get(i);
      if ((abs(curSphere.dest[2] - curSphere.position[0]) > 1000 || abs(curSphere.dest[0] - curSphere.position[1]) > 1000) && curSphere.lifeSpan > 1.0 || curSphere.lifeSpan > 1.0){
        Kamehameha.remove(i);
        i--;
      }
      else{
      beginShape(POINTS);

      strokeWeight(curSphere.thicc);
      stroke(curSphere.c, curSphere.alpha);
      kcomputePhysics(dt, curSphere);
      vertex(curSphere.position[0], curSphere.position[1], curSphere.position[2]);
      endShape();

      }
    }

  spawnKamehameha(dt); 
  spawnParticles(dt);
  prevTime = curTime;
}

float[] rndPos(float offsetX, float offsetY){
  float r = 0.1 * discRadius * sqrt(random(0, 1));
  float theta =  2 * PI  * random(0, 1); //Controls how much of the sphere
  float x = 2 * PI * r * sin(theta);
  float z = 2 * PI * r * cos(theta);
  float y = sqrt(sq(discRadius) - sq(x) - sq(z));
  float num = random(-1, 1);
  if (num < 0)
    num = -1;
  if (num >= 0)
    num = 1;
  y = y * num;
  float[] pos = {x + mouseX + offsetX, y + mouseY + offsetY, z};
  return pos;
}

float [] krndPos(){
  float r = 5 * discRadius * sqrt(random(0,1));
  float theta = 2 * PI * random(0,1);
  float x = r * sin(theta);
  float y = r * cos(theta);
  float num = random(-1, 1);
    if (num < 0)
    num = -1;
  if (num >= 0)
    num = 1;
  y = y * num;
  float[] pos = {x + mouseX + random(100, 150), y + mouseY - 300, 100};
  return pos;
  
}
void spawnKamehameha(float dt){
  float numParticles = dt * kgenRate;
  float fracPart = numParticles - int(numParticles);
  numParticles = int(numParticles);
  if (random(0,1) < fracPart)
    numParticles ++;
  for (int i = 0; i < numParticles; i ++){
    float[] pos = krndPos();
    float[] vel = {20*random(-1,1), 5000*random(-1,0), 2.5*random(-1,1)};
    float where = mouseY - 350;
    float start = mouseY;
    float[] thing = {start, where, mouseX};
    Spheres newSphere = new Spheres(radius, pos, vel, vel, 20, 0, Direction.DEFAULT, 255, color(255, 0, 0), thing);
    Kamehameha.add(newSphere);
  }
}

void kcomputePhysics(float dt, Spheres curSphere){
    //float divisor = (mouseX - curSphere.position[0])
    
    if (mouseX == pmouseX && mouseY == pmouseY){
      curSphere.velocity[0] = curSphere.origVel[0];
      curSphere.velocity[1] = curSphere.origVel[1];
    }
    else {
      curSphere.velocity[0] = mouseX - pmouseX;
      curSphere.velocity[1] = mouseY - pmouseY;
    }
      float dist = abs(curSphere.position[1] - curSphere.dest[1]);


      
      
    float distance = sq(mouseX - curSphere.position[0]) + sq(mouseY - curSphere.position[1]);
    distance = sqrt(distance);
    curSphere.thicc *= 1 - (2*distance/maxDistance);
    curSphere.alpha = 255 - 255*(distance/1600);
    //float blue = distance/800;
    //1900 1600
    if (random(0, 1) > 0.95 && dist < 150){
       curSphere.c = color(245 - 150*(dist/150), 245 - 150*(dist/150), 245 - 150*(dist/150));
       //curSphere.alpha = random (0, 255);
    }
    else if (abs(curSphere.position[1] - curSphere.dest[1]) < 225){
      curSphere.c = color(255, 0 + 1.2 * abs(curSphere.position[1] - curSphere.dest[1]) , 0);
    }
    else{
      //println("dist " + dist);
      curSphere.c = color(245 - 150*(dist/150), 245 - 150*(dist/150), 245 - 150*(dist/150));
      curSphere.alpha = random(0, 255);
    }

    
    curSphere.position[0] += curSphere.velocity[0] * dt;
    curSphere.position[1] += curSphere.velocity[1] * dt;
    curSphere.position[2] += curSphere.velocity[2] * dt;
    curSphere.lifeSpan += dt;
    
}

void spawnParticles(float dt){
  float numParticles = dt * genRate;
  float fracPart = numParticles - int(numParticles);
  numParticles = int(numParticles);
  float [] pos = new float[3];
  float [] vel = new float[3];
  if (random(0,1) < fracPart)
    numParticles += 1;
  for (int i = 0; i < 8; i++){
    for (int j = 0; j < numParticles/8; j++){
     if (i == 0){
       pos = rndPos(-150, 0);
       float [] arr = {100*random(-1,1), 25*random(-1,1), 2.5*random(-1,1)};
       vel = arr;
     }
     else if (i == 1){
       pos = rndPos(0, 100);
       float [] arr = {100*random(-1,1), 25*random(-1,1), 2.5*random(-1,1)};
       vel = arr;
     }
     else if (i == 2){
       pos = rndPos(0, 0);
       float [] arr = {100*random(-1,1), 40*random(-1,1), 2.5*random(-1,1)};
       vel = arr;
     }
     else if (i == 3){
       pos = rndPos(150, 0);
       float[] arr = {100*random(-1,1), 40*random(-1,1), 2.5*random(-1,1)};
       vel = arr;
      }
     else if (i == 4){
       pos = rndPos(-100, -50);
       float[] arr = {100*random(-1,1), 40*random(-1,1), 2.5*random(-1,1)};
       vel = arr;

     }
     else if (i == 5){
       pos = rndPos(100, -50);
       float [] arr = {100*random(-1,1), 40*random(-1,1), 2.5*random(-1,1)};
       vel = arr;
     }
     else if (i == 6){
       pos = rndPos(100, 50);
       float [] arr = {100*random(-1,1), 40*random(-1,1), 2.5*random(-1,1)};
       vel = arr;
     }
     else if (i == 7){
       pos = rndPos(-100, 50);
       float[] arr = {100*random(-1,1), 40*random(-1,1), 2.5*random(-1,1)};
       vel = arr;

     }
       Spheres newSphere = new Spheres(radius, pos, vel, vel,80, 0, Direction.DEFAULT, 255, color(255, 215, 0), vel);
       (allSpheres.get(i)).add(newSphere);
    }
  }
}


void computePhysics(float dt, Spheres curSphere){
    if (mouseX == pmouseX && mouseY == pmouseY){
      curSphere.velocity[0] = curSphere.origVel[0];
      curSphere.velocity[1] = curSphere.origVel[1];
    }
    else {
      curSphere.velocity[0] = mouseX - pmouseX;
      curSphere.velocity[1] = mouseY - pmouseY;
    }
    float distance = sq(mouseX - curSphere.position[0]) + sq(mouseY - curSphere.position[1]);
    distance = sqrt(distance);
    curSphere.thicc *= 1 - (distance/maxDistance);
    curSphere.alpha = 255 - 255*(distance/800);
    float blue = 255 * (distance/800);
    curSphere.c = color( 255, 215, blue);
    curSphere.position[0] += curSphere.velocity[0] * dt;
    curSphere.position[1] += curSphere.velocity[1] * dt;
    curSphere.position[2] += curSphere.velocity[2] * dt;
    curSphere.lifeSpan += dt; 
}


int getSpheres(){
  int sum = 0;
  for (int i = 0; i < 8; i++){
    sum += allSpheres.get(i).size();
  }
  return sum;
}
