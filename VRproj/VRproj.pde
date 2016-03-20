PGraphics leftEye;
PGraphics rightEye;
float halfWidth;
float halfHeight;
float quadWidth;
float depth = -20;
float t;

void setup(){
  size(1000, 600, P3D);
  leftEye = createGraphics(width/2,height,P3D);
  rightEye = createGraphics(width/2,height,P3D);
  halfWidth = width*0.5;
  halfHeight = height*0.5;
  quadWidth = halfWidth*0.5;
}

void drawVR(PGraphics g){
  g.fill(255);
  float s = 100;
  for(int i=-5;i<5;i+=2){
    for(int j=-5;j<5;j+=2){
      for(int k=-5;k<5;k+=2){
        g.pushMatrix();
        g.translate(i*s,j*s,k*s);
        g.box(s*0.1);
        g.popMatrix();
      }
    }
  }
  g.fill(255,0,0);
  g.translate(200,0,cos(t)*200);
  g.box(100);
}

void drawVR(PGraphics g,float x){
  g.beginDraw();
  g.background(255);
  g.pushMatrix();
  g.translate(quadWidth+x, halfHeight, -300);
  g.rotateY(atan2(-x, 300));
  drawVR(g);
  g.popMatrix();
  g.endDraw();
}

void draw(){
  drawVR(leftEye, depth);
  drawVR(rightEye, -depth);
  image(leftEye, 0,0);
  image(rightEye, halfWidth, 0);
  pushStyle();
  stroke(64);
  strokeWeight(10);
  line(halfWidth,0,halfWidth,height);
  popStyle();
  t+=0.1;
  
  if(t%0.1==0) 
  save("picture.png");
}