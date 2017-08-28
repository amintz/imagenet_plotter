import processing.pdf.*;

XML     networkSVG;
XML     configXml;
String  networkSVGPath,
        imageFolderPath,
        PDFOutputPath;
int     PDFOutputWidth,
        PDFOutputHeight;
float   imageRealW,
        imageDrawW;

float   minX, maxX, minY, maxY;
float   imgDrawW, imgDrawH;
float   imgRealW;

XML[]   allImages;

PImage  curImg;

void settings() {
     configXml       = loadXML("config.xml");
     networkSVGPath  = configXml.getString("network-svg");
     imageFolderPath = configXml.getString("image-folder");
     PDFOutputPath   = configXml.getString("output-pdf");
     PDFOutputWidth  = configXml.getInt("output-width");
     PDFOutputHeight = configXml.getInt("output-height");
     imgRealW      = configXml.getFloat("image-real-width");
     imgDrawW      = configXml.getFloat("image-draw-width");
     
     size(PDFOutputWidth, PDFOutputHeight, PDF, PDFOutputPath);
}

void setup() {
     background(#FFFFFF);
     networkSVG = loadXML(networkSVGPath);
     networkSVG = networkSVG.getChild("g");
     allImages = networkSVG.getChildren("text");
     println(allImages.length);
     for (int i=0; i < allImages.length; i++) {
       float curX = allImages[i].getFloat("x");
       float curY = allImages[i].getFloat("y");
       if(i==0) {
         minX = curX;
         minY = curY;
         maxX = curX;
         maxY = curY;
       }
       else {
         minX = min(curX, minX);
         maxX = max(curX, maxX);
         minY = min(curY, minY);
         maxY = max(curY, maxY);
       }
     }
     maxX += 2*imgDrawW;
     maxY += 2*imgDrawW;
}

void draw() {
   for(int i=0; i < allImages.length; i++) {
      curImg = loadImage(imageFolderPath + trim(allImages[i].getContent()));
      curImg.resize(int(imgRealW),0);
      imgDrawH = curImg.height * (imgDrawW/curImg.width);
      float imgDrawX = map(allImages[i].getFloat("x"), minX, maxX, 0, width);
      float imgDrawY = map(allImages[i].getFloat("y"),minY, maxY, 0, height);
      image(curImg, imgDrawX, imgDrawY, imgDrawW, imgDrawH);
      println("Drawing image " + i + " of " + allImages.length + ".");
   }
   exit();
}