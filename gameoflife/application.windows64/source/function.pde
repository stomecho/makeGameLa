int[][] mats = new int[][]{
  {0, 1, 1, 0}, 
  {1, 0, 0, -1}, 
  {0, -1, -1, 0}, 
  {-1, 0, 0, 1}, 
};
int dir = 0;
boolean fillMode = true;
void paint(picture p, int x, int y) {
  map = paint(map, p, x, y, true, p.solid);
}
void prepaint(picture p, int x, int y) {
  prelook = paint(prelook, p, x, y, false, false);
}

boolean[][] paint(boolean[][] map, picture p, int x, int y, boolean setSleep, boolean mode) {
  if (p==null) return null;
  int[][] image = p.data;
  if (image==null) return null;
  for (int i=0; i<image.length; i++) {
    for (int j=0; j<image[0].length; j++) {
      int nx = matx(i, j, mats[dir])+x;
      int ny = maty(i, j, mats[dir])+y;
      if (0<=nx&&nx<map.length&&0<=ny&&ny<map[0].length) {
        if (image[i][j]==0) continue;
        map[nx][ny] = fillMode;
        if(mode) n[nx][ny]=2;
        if(setSleep)
        for (int xx=nx-1; xx<=nx+1; xx++)for (int yy=ny-1; yy<=ny+1; yy++) {
          if (xyOk(xx, yy)) {
            if (sleep!=null)sleep[xx][yy] = mode?sleepTime:0;
          }
        }
      }
    }
  }
  return map;
}


/*
void prepaint(picture p, int x, int y) {
  if (p==null) return;
  int[][] image = p.data;
  if (image==null) return;
  for (int i=0; i<image.length; i++) {
    for (int j=0; j<image[0].length; j++) {
      int nx = matx(i, j, mats[dir])+x;
      int ny = maty(i, j, mats[dir])+y;
      if (xyOk(nx, ny))
        prelook[nx][ny] = image[i][j]==1;
    }
  }
}*/