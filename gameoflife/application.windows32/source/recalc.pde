int recalcX(int x){
  return (int)((x-width*0.5-cx*s)/s);
}

int recalcY(int y){
  return (int)((y-height*0.5-cy*s)/s);
}

int calcX(int x){
  return (int)(x*s+cx*s+width*0.5);
}

int calcY(int y){
  return (int)(y*s+cy*s+height*0.5);
}