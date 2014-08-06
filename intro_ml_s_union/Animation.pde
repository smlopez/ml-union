// Class for animating a sequence of GIFs

class Animation {
  PImage[] images;
  int imageCount;
  int frame=0;
  
  Animation(int count) {
    imageCount = count;
    images = new PImage[imageCount];

    for (int i = 0; i < imageCount-1; i++) {
      // Use nf() to number format 'i' into four digits
      String filename = nf(i+1, 2) + ".png";
      images[i] = loadImage(filename);
    }
  }

  void display(float xpos,float ypos) {
    frame = (frame+1) % imageCount;
    if(frame>=8)frame=0;
    image(images[frame], xpos, ypos);
    
  }
  
  int getWidth() {
    return images[0].width;
  }
}
