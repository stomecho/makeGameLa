int calcX(int x){
  return (int)((x-cx)*s+width*0.5);
}

int calcY(int y){
  return (int)((y-cy)*s+height*0.5);
}

int recalcX(int x){
  return (int)((x-width*0.5)/s+cx+(map.length)*0.5);
}

int recalcY(int y){
  return (int)((y-height*0.5)/s+cy+(map[0].length)*0.5);
}