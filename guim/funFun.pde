boolean isBetween(float a, float b, float c){
  return a<=b && b<c;
}

boolean isBetween(PVector a, PVector b, PVector c){
  return isBetween(a.x,b.x,c.x) & isBetween(a.y,b.y,c.y);
}