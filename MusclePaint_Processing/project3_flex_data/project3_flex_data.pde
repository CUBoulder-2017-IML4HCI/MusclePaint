import oscP5.*; 
import netP5.*;
OscP5 oscP5; 
NetAddress dest, dest2;
OscMessage myMessage, myMessage2;
float val1, val2;

void setup(){
  size(300, 300);
  oscP5 = new OscP5(this, 8888);
  dest = new NetAddress("127.0.0.1", 6448);
  dest2 = new NetAddress("127.0.0.1", 6449);
}

void draw(){
}

void oscEvent(OscMessage theOscMessage) {
  println(theOscMessage);
  myMessage = new OscMessage("/wek/inputs");
  myMessage2 = new OscMessage("/wek/inputs");
  val1 = theOscMessage.get(0).floatValue();
  val2 = theOscMessage.get(3).floatValue();
  myMessage.add(val1);
  myMessage.add(val2);
  myMessage2.add(val2);
  oscP5.send(myMessage, dest);
  oscP5.send(myMessage2, dest2);
}