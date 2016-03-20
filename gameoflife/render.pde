boolean debug = false;

void render(){
  pushMatrix();
  //fill(0,192);
  //rect(0,0,width,height);
  translate(cx*s+width*0.5, cy*s+height*0.5);
  background(0);
  
  for (int i=0; i<map.length; i++) for (int j=0; j<map[0].length; j++) {
    noStroke();
    fill(255);
    if(map[i][j]) {
      
      if (sleep[i][j]>=sleepTime) fill(0, 0, 255);
      else if (sleep[i][j]>sleepTime*0.6) fill(0, 255, 0);
      else if (sleep[i][j]>sleepTime*0.3)  fill(255, 0, 0);
      else if (map[i][j]) fill(255);
      
      if(showSelect && mx<=i&&i<=mex && my<=j && j<=mey) fill(255,0,0);
      
      rect(i*s, j*s, s, s);
    }
    if(prelook[i][j]){
      fill(0,64);
      stroke(255);
      rect(i*s, j*s, s, s);
    }
  }
  
  if(debug)for(singleLifeBlock b : blocks)b.showGrid();
  
  pushStyle();
  noFill();
  stroke(255, 0, 0);
  if (showSelect)rect(mx*s, my*s, mex*s-mx*s+s, mey*s-my*s+s);
  stroke(255);
  rect(0, 0, map.length*s, map[0].length*s);
  popStyle();
  
  popMatrix();
  guimDraw();
  if(!run){
    fill(255);
    textSize(16);
    if(mainPattern!=null)
    text(mainPattern.name, mouseX-20, mouseY-20);
  }
}