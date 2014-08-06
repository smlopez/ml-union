int scr_sz_x=1920,scr_sz_y=1080; //-CONFIG- Tamaño de la pantalla en las coordenadas X e Y
int frames=30;  //-CONFIG- Frame por segundo
boolean scr_fullscr = true; //-CONFIG- Pantalla completa
PImage bg; //-MAP- Imagén de fondo

void setup(){
size(scr_sz_x,scr_sz_y);
frameRate(frames);
bg = loadImage("bg.png");
}
boolean sketchFullScreen() {
  return scr_fullscr;
}
void draw(){
background(0);
image(bg,0,0);
}
