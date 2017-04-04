// Daniel Shiffman
// http://codingtra.in
// http://patreon.com/codingtrain
// Code for: https://youtu.be/h8tk0hmWB44


import processing.video.*;
import java.util.*;

// Variable for capture device
Capture video;
HashMap<Integer, Integer> drawnPixels = new HashMap();

// A variable for the color we are searching for.
color trackColor; 
boolean drawMode = false;


void setup() {
  size(1280, 720);
  String[] cameras = Capture.list();
  printArray(cameras);
  video = new Capture(this, cameras[0]);
  video.start();
  // Start off tracking for red
  trackColor = color(255, 0, 0);
}

void captureEvent(Capture video) {
  // Read image from the camera
  video.read();
}

void draw() {
  if (keyPressed) {
    if (key == 'p' || key == 'P') {
      drawMode = !drawMode;
      if(drawMode) {
        background(255);
        noStroke();
      }else{
        stroke(1);
        strokeWeight(4.0);
      }
      
      println(drawMode);
    }
  } 
  
  video.loadPixels();
  if(!drawMode) image(video, 0, 0);

  // Before we begin searching, the "world record" for closest color is set to a high number that is easy for the first pixel to beat.
  float worldRecord = 500; 

  // XY coordinate of closest color
  int closestX = 0;
  int closestY = 0;
  stroke(0);
  strokeWeight(0.0);
  
  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y * video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      // Using euclidean distance to compare colors
      float d = dist(r1, g1, b1, r2, g2, b2); // We are using the dist( ) function to compare the current color with the color we are tracking.

      // If current color is more similar to tracked color than
      // closest color, save current location and current difference
      if (d < 4.0) {
        drawnPixels.put(loc, currentColor);
      }
      if(drawnPixels.containsKey(loc)){
        fill(drawnPixels.get(loc), 200);
        rect(x,y,1,1);
      }
    }
  }

  // We only consider the color found if its color distance is less than 1000. 
  // This threshold of 1000 is arbitrary and you can adjust this number depending on how accurate you require the tracking to be.
  if (worldRecord < 1000) { 
    // Draw a circle at the tracked pixel
    fill(trackColor);
    strokeWeight(4.0);
    stroke(0);
    ellipse(closestX, closestY, 16, 16);
  }
  strokeWeight(1);
  fill(trackColor);
  rect(0,0,25,25);
  
}

void mousePressed() {
  if (mouseButton == LEFT) {
    int loc = mouseX + mouseY*video.width;
    trackColor = video.pixels[loc];
  } else if (mouseButton == RIGHT) {
    drawnPixels = new HashMap();
  } 
  // Save color where the mouse is clicked in trackColor variable
}