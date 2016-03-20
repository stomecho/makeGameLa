int[][] imageCell(PImage p, int w, int h){
  PGraphics g = createGraphics(w, h);
  g.noSmooth();
  g.beginDraw();
  g.image(p,0,0,w,h);
  g.endDraw();
  g.loadPixels();
  int[][] pat = new int[h][w];
  for(int i=0;i<h;i++) {
    for(int j=0;j<w;j++){
      pat[i][j] = red(g.pixels[i*w+j])>128?1:0;
    }
  }
  return pat;
}