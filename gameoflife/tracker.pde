void deleteSelect(){
  for (int i=mx; i<=mex; i++) for (int j=my; j<=mey; j++) {
    if (0<=i&&i<n.length&&0<=j&&j<n[0].length){
      map[i][j] = false;
      sleep[i][j] = 0;
    }
  }
}

void copySelect(){
  tracker();
  copy = new int[mey-my+1][mex-mx+1];
  for(int i=mx; i<=mex; i++) for (int j=my; j<=mey; j++) {
    if (xyOk(i,j)){
      copy[j-my][i-mx] = (map[i][j])?1:0;
    }
  }
}

int[][] selection(){
  int[][] copy = new int[mey-my+1][mex-mx+1];
  for (int i=mx; i<=mex; i++) for (int j=my; j<=mey; j++) {
    if (0<=i&&i<n.length&&0<=j&&j<n[0].length){
      copy[j-my][i-mx] = (map[i][j])?1:0;
    }
  }
  return copy;
}

void tracker(){
  int x = mx;
  int y = my;
  int w = mex-mx+1;
  int h = mey-my+1;
  int ex=x;
  int ey=y;
  int sx=w+x;
  int sy=h+y;
  for (int i=x; i<x+w; i++) for (int j=y; j<y+h; j++) {
    if (0<=i&&i<n.length&&0<=j&&j<n[0].length){
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
  }
  mx = min(sx,ex);
  my = min(sy,ey);
  mex = max(sx,ex);
  mey = max(sy,ey);
}