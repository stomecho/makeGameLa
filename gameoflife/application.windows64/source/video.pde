/*import gab.opencv.*;
import processing.video.*;
import java.awt.*;
Capture video;
OpenCV opencv;

PImage img;
Eye right,left;
float t=0,rx,ry;
float lx,ly,dist;
void videoSetup(){
  size(displayWidth,displayHeight,P3D);
  //orientation(LANDSCAPE);
  img = loadImage("face.png");
  video = new Capture(this, 640, 480);
  opencv = new OpenCV(this, 640, 480);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  video.start();
}

int count=0;
void videoDraw(){
  opencv.loadImage(video);
  image(img,0,0,displayWidth,displayHeight);
}*/