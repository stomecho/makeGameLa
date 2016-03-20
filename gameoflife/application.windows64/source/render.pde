boolean debug = false;

float depthView = 0;
boolean enable3D = false;

float depthViewY = 0.1;
float depthViewX = 0.1;

boolean autoRotateMode = false;
void render() {
  pushMatrix();
  //fill(0,192);
  //rect(0,0,width,height);
  translate(width*0.5-cx*s, height*0.5-cy*s);
  if (enable3D) depthView+=(10-depthView)*0.2;
  else depthView+= (0-depthView)*0.2;
  if(autoRotateMode)depthViewX = cos(t*0.01)*0.1;
  
  if (depthView>=0.1) {
    
    rotateX(depthView*depthViewY);
    rotateZ(depthView*depthViewX);
  }
  translate(-s*map.length*0.5, -s*map[0].length*0.5);
  background(0);
  
  for (int i=0; i<map.length; i++) for (int j=0; j<map[0].length; j++) {
    noStroke();
    fill(255);

    if (map[i][j]) {
      pushMatrix();
      if (sleep[i][j]>=sleepTime) fill(0, 0, 255);
      else if (sleep[i][j]>sleepTime*0.6) fill(0, 255, 0);
      else if (sleep[i][j]>sleepTime*0.3)  fill(255, 0, 0);
      else if (map[i][j]) fill(255);

      if (showSelect && mx<=i&&i<=mex && my<=j && j<=mey) fill(255, 0, 0);
      
      if (depthView>=0.5) {
        translate(0, 0, n[i][j]*depthView*s);
        stroke(255);
        if (i%4==0&&j%4==0)
          line(i*s+s*0.5, j*s+s*0.5, 0, i*s+s*0.5, j*s+s*0.5, -sleep[i][j]*depthView*s);
      }
      noStroke();
      rect(i*s, j*s, s, s);

      popMatrix();
    }

    if (prelook[i][j]) {
      fill(0, 64);
      stroke(255);
      rect(i*s, j*s, s, s);
    }
  }

  if (debug)for (singleLifeBlock b : blocks)b.showGrid();

  
  pushStyle();
  noFill();
  stroke(255, 0, 0);
  if (showSelect)rect(mx*s, my*s, mex*s-mx*s+s, mey*s-my*s+s, depthView);
  stroke(255);
  rect(0, 0, map.length*s, map[0].length*s);
  popStyle(); 
  popMatrix();
  guimDraw();
  
  fill(255);
  textSize(16);
  if (mainPattern!=null)
    text(mainPattern.name, mouseX-20, mouseY-20);
}