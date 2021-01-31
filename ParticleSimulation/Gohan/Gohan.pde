PShape gohan;
void setup(){
  size(1000, 1000, P3D);
  gohan = loadShape("C:\\Users\\chris\\Desktop\\Gohan\\Gohan_Texture_V2\\uploads_files_1825368_Gohan_kamehameha_V2.obj");
gohan.scale(100);
}

  
  void draw(){
    fill(0, 255, 0);
    rectMode(CENTER);
    box(200, 0, 200);
    shape(gohan, 500, 500);
    
  }
