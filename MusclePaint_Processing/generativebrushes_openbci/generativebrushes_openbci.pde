/*********************************************************************
 
 Name: Jason Barles / Interaction Designer
 Date: 31/Aug/2013
 
 Description: A generative art drawing tool with several patterns of
 choice. Press 'c', delete, or backspace to clear the screen. 
 Press numbers, or buttons, 1 through to 5 to change the 
 brush stroke pattern.
 
 Button code obtained and modified from 
 http://processing.org/examples/button.html
 
 Modified for OpenBCI project for IML4HCI
 Name: Annie Kelly
 Date: 20/Feb/2017
 
 **********************************************************************/
import oscP5.*; 
 
OscP5 oscP5; 
 
int currentTool = 1; // Set the default tool to be the first pattern
ArrayList history;   // Define the history for pattern3 

float virtualMouseX = width/2;
float virtualMouseY = height/2;
float pVirtualMouseX = width/2;
float pVirtualMouseY = height/2;
int acc = 1;

boolean clear = false;

float val1, val2, val3, val4, val5;

color background = color(0, 0, 0);

void setup() {
  size(800, 600);
  oscP5 = new OscP5(this, 8080);
  background(0);
  smooth();
  history  = new ArrayList();     
}

void draw() {
  if (clear == true){
    background(background);
    clear = false;
  }
  
  if (virtualMouseY >= height || virtualMouseY <= 0){
    acc *= -1;
  }
  virtualMouseY += 5 * acc;
  
  switch(currentTool) {      
    case 1:      
      pattern1(virtualMouseX, virtualMouseY, 5, 18, color(204, 102, 0), color(0, 102, 153));
      break;
    case 2:      
      pattern2();
      break;      
    case 3:
      pattern3(10);
      break;    
    case 4:
      pattern4();
      break;  
    case 5:
      pattern5();
      break;              
    }
}


/* 
 Drawing tools
 */
// A recursive pattern that draws a spray of circles mirrored across the
// x-axis. 
void pattern1(float x, float y, int r, int num, color fromC, color toC) {  
  color interA = lerpColor(fromC, toC, .12); // get the inbetween colour
  noStroke();
  fill(fromC, 80);
  ellipse(x, y, r, r); 
  stroke(fromC); 
  ellipse(width-x, y, r, r);  // draw the mirror of the ellipse
  if (num > 0) {
    float newY = y + sin(random(0, TWO_PI)) * 12.0;    
    // recursive call
    pattern1(x+(num/3), newY, int(random(r/2, r+(num/5))), num-1, interA, toC);
  }
}

// pattern2 draws a rainbow web. Code inspired by Mr Doob's project harmony.
// http://www.mrdoob.com/projects/harmony/
void pattern2() {
  int extra = 3;
  // Randomise the colours during each frame
  stroke(random(0,255), random(0,255), random(0,255));
  strokeWeight(0.2);
  line(virtualMouseX, virtualMouseY, pVirtualMouseX, pVirtualMouseY);
  line(width-virtualMouseX, virtualMouseY, width-pVirtualMouseX, virtualMouseY); // Mirror

  for(int i = 0; i < history.size(); i++){
    PVector p = (PVector) history.get(i);
    
    // Draw a line from the current mouse point to 
    // the historical point if the distance is less
    // than 50
    if(dist(virtualMouseX, virtualMouseY, p.x, p.y) < 50){
      line(virtualMouseX, virtualMouseY, p.x + extra, p.y + extra);
    } 
    // repeat for the mirror line
    if(dist(width-virtualMouseX, virtualMouseY, p.x, p.y) < 50){
      line(width-virtualMouseX, virtualMouseY, p.x + extra, p.y + extra);
    }      
  }
  
  // Add the current point to the history
  history.add(new PVector(virtualMouseX, virtualMouseY));
  history.add(new PVector(width-virtualMouseX, virtualMouseY));
}

// pattern3 draws hundreds and thousands food dressing
void pattern3(int offset) {
  strokeWeight(0.5);
  for (int i = 0; i < 5; i++) {
    // Randomise the colours during each frame
    stroke(random(0,255), random(0,255), random(0,255));
    // Draw a line of various lengths at the mouse point  
    line(random(virtualMouseX, virtualMouseX+offset), random(virtualMouseY, virtualMouseY+offset), 
         random(pVirtualMouseX, pVirtualMouseX+offset), random(pVirtualMouseY, pVirtualMouseY+offset));
    offset = offset+10;
  }
}

// pattern4 draws circles that seem to fade in towards the middle
void pattern4(){
  noStroke();
  fill(random(0,255), random(0,255), random(0,255),10);
  // alter the width size
  float widthDistance = abs(width/2 - virtualMouseX);
  ellipse(virtualMouseX, virtualMouseY, widthDistance, widthDistance); 
}

// Code inspired by Mr Doob's project harmony.
// http://www.mrdoob.com/projects/harmony/
void pattern5(){
  // Randomise the colours during each frame
  stroke(255);
  line(virtualMouseX, virtualMouseY, pVirtualMouseX, pVirtualMouseY);

  for(int i = 0; i < history.size(); i++){
    PVector p = (PVector) history.get(i);
    float d = dist(virtualMouseX, virtualMouseY, p.x, p.y);
    // Adjust the stroke weight according to the distance
    strokeWeight(1/d);
    
    // Draw a line from the current mouse point to 
    // the historical point if the distance is less
    // than 25
    if(d < 25){
     if(random(10) < 5) // Skip some lines randomly
        line(virtualMouseX, virtualMouseY, p.x + 2, p.y + 2);
    } 
  }
  
  // Add the current point to the history
  history.add(new PVector(virtualMouseX, virtualMouseY));
  strokeWeight(0.2);
}

void keyPressed(){
  switch(key){
    case 'c':
      clear = true;
  }
}

void oscEvent(OscMessage theOscMessage) {
  //println(theOscMessage);
  if(theOscMessage.checkAddrPattern("/clear") == true){
     clear = true;
     background = color(random(0, 255), random(0, 255), random(0, 255));
   }
  else if(theOscMessage.checkAddrPattern("/switch") == true){ 
      if (currentTool == 2){
        currentTool = 1;
      } else {
        currentTool = 2;
      }
   }
  else if(theOscMessage.checkAddrPattern("/continuous") == true){
    virtualMouseX = map(theOscMessage.get(0).floatValue(), 0.0, 1.0, width/2, width);
  }
}