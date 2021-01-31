PShape goku;
void setup(){
  size(1000, 1000, P3D);  
  goku = loadShape("C:\\Users\\chris\\Downloads\\goku\\source\\untitled\\untitled.obj");
  
}

void draw(){
  
  shape(goku, 0, 0);
  
}
