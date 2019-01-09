import gab.opencv.*;
import SimpleOpenNI.*;
import KinectProjectorToolkit.*;

SimpleOpenNI kinect;
OpenCV opencv;
KinectProjectorToolkit kpc;
ArrayList<ArrayList<ProjectedContour>> allProjectedContours;
float blobDilate = 1;
int numframes = 60;

void setup() {
  size(1280, 720, P2D); 

  // setup Kinect
  kinect = new SimpleOpenNI(this); 
  kinect.enableDepth();
  kinect.enableUser();
  kinect.alternativeViewPointDepthToImage();
  
  // setup OpenCV
  opencv = new OpenCV(this, kinect.depthWidth(), kinect.depthHeight());
  //opencv = new OpenCV(this, 640, 480);

  // setup Kinect Projector Toolkit
  //kpc = new KinectProjectorToolkit(this, 640, 480);
  kpc = new KinectProjectorToolkit(this, kinect.depthWidth(), kinect.depthHeight());// kinect.depthWidth(), kinect.depthHeight());
  kpc.loadCalibration("calibration.txt");
  kpc.setContourSmoothness(3);  
  
  // archive of projected contours
  allProjectedContours = new ArrayList<ArrayList<ProjectedContour>>();
}

void draw() {  
  background(255,0,0);
  
  kinect.update();  
  kpc.setDepthMapRealWorld(kinect.depthMapRealWorld()); 
  kpc.setKinectUserImage(kinect.userImage());
  opencv.loadImage(kpc.getImage());
  
  // get projected contours
  ArrayList<ProjectedContour> projectedContours = new ArrayList<ProjectedContour>();
  
  ArrayList<Contour> contours = opencv.findContours();
  for (Contour contour : contours) {
    if (contour.area() > 2000) {
      ArrayList<PVector> cvContour = contour.getPoints();
      ProjectedContour projectedContour = kpc.getProjectedContour(cvContour, blobDilate);
      projectedContours.add(projectedContour);
    }
  }
     
  // add to running list of projected contours
  allProjectedContours.add(projectedContours);
  while (allProjectedContours.size() > numframes)  allProjectedContours.remove(0);
  
  // render bodies
  for (int i=0; i<projectedContours.size(); i++) {
    ProjectedContour projectedContour = projectedContours.get(i);
    fill(0);
    noStroke();
    beginShape();
    for (PVector p : projectedContour.getProjectedContours()) {
      PVector pt = projectedContour.getTextureCoordinate(p);
      vertex(p.x, p.y, width * pt.x, height * pt.y);
    }
    endShape();
  }

}
