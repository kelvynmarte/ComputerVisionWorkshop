import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import java.util.*;

Capture video;
OpenCV opencv;

ArrayList<PImage> storedFaces = new ArrayList();

void setup() {

  size(640, 480);
  video = new Capture(this, 640, 480);
  opencv = new OpenCV(this, 640, 480);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  video.start();
}

void draw() {
  opencv.loadImage(video);
  image(video, 0, 0 );

  noFill();
  stroke(255, 255, 0);
  strokeWeight(3);
  Rectangle[] faces = opencv.detect();
  
  for(Rectangle face: faces){
    storedFaces.add(video.get(face.x, face.y, face.width, face.height));
  }
  int x = 0;
  int y = 0;
  
  Iterator<PImage> iter = storedFaces.iterator();
  boolean deleteFirst = false;
  while(iter.hasNext()){
    PImage face = iter.next();
    image(face, x, y, face.width, face.height);
    x += face.width;
    if(x > width){
      x = 0;
      y += face.height;
    }
    if(y > (height + 200)){
      // iter.remove();
      deleteFirst = true;
    } 
  }
  if(deleteFirst){
    storedFaces.remove(0);
  }
}

void captureEvent(Capture c) {
  c.read();
}