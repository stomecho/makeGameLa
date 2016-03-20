

class singleLifeBlock {
  int ex, ey;
  int sx, sy;
  int x, y, w, h;
  singleLifeBlock(int x, int y, int w, int h) {
    this.x=x;
    this.y=y;
    this.w=w;
    this.h=h;
  }

  void sum() {
    ex=x;
    ey=y;
    sx=w+x;
    sy=h+y;
    for (int i=x; i<x+w; i++) for (int j=y; j<y+h; j++) {
      if(sx<i&&i<ex&&sy<j&&j<ey){
        i=ex;
        j=ey;
      }
      if (!map[i][j]) continue;
      if (i>ex)ex=i;
      if (i<sx)sx=i;
      if (j>ey)ey=j;
      if (j<sy)sy=j;
    }
    if (sx>0)sx--;
    if (sy>0)sy--;
    if (ex<map.length-1)ex++;
    if (ey<map[0].length-1)ey++;
    
    for (int i=sx; i<=ex; i++) for (int j=sy; j<=ey; j++) {
      if(done[i][j]==1) continue;
      done[i][j] = 1;
      
      if (!xyOk(i,j)) continue;
      if (!map[i][j]) continue;
      for (int xx=i-1; xx<=i+1; xx++)for (int yy=j-1; yy<=j+1; yy++) {
        if (xx==i&&yy==j) continue;
        if (xyOk(xx,yy)) {
          if (sleep[xx][yy]>=sleepTime) continue;
          n[xx][yy]++;
        }
      }
    }
  }

  void update() {
    
    for (int i=sx; i<=ex; i++) for (int j=sy; j<=ey; j++) {
      boolean changed = false;
      
      if (sleep[i][j]>=sleepTime) continue;
      if (done[i][j]==2) continue;

      done[i][j] = 2;

      //game rule

      switch(n[i][j]) {
      case 2: 
        break;
      case 3: 
        if (!map[i][j]) changed=true; 
        map[i][j] = true; 
        break;
      default: 
        if (map[i][j])changed=true; 
        map[i][j] = false; 
        break;
      }

      /*
      if(map[i][j]){
       if(!( 2<=n[i][j] && n[i][j]<=3 )){
       map[i][j] = false;
       changed = true;
       }
       }else if(n[i][j]==3) {
       map[i][j] = true;
       changed = true;
       }*/


      if (changed)sleep[i][j] = 0;
      else if (sleep[i][j]<=sleepTime)sleep[i][j] ++;

      if (changed)
        for (int xx=i-1; xx<=i+1; xx++)for (int yy=j-1; yy<=j+1; yy++) {
          if (0<=xx&&xx<n.length&&0<=yy&&yy<n[0].length) {
            sleep[xx][yy] = 0;
          }
        }
    }
    
  }
  
  void showGrid(){
    pushStyle();
     noFill();
     
     stroke(0,255,0); //green line
     //rect(x*s,y*s,(w)*s,(h)*s);
     
     //stroke(255,0,0); //red line
     if(sx<=ex&&sy<=ey)
     rect(sx*s,sy*s,(ex-sx+1)*s,(ey-sy+1)*s);
     
     popStyle();
  }
}