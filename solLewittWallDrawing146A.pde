// Attempting to recreate Sol Lewitt's Wall Drawing 146A
// http://www.massmoca.org/lewitt/walldrawing.php?id=146A



// wall for sol
// 152 x 100
// 150 x 90
// boxH = 92/3
float wallH = 97;
float wallW = 152;


//37.5x83 - door size in inches
// 1.64 x 1

// add lerp lines to this
// case 11???
/*
pushMatrix();
translate(boxW/2, boxH/2);
rotate(HALF_PI);
for(int i = 0; i < 8; i++) {
  lerp(i, )
    
}




*/

//Declare Globals
int rSn; // randomSeed number. put into var so can be saved in file name. defaults to 47
final float PHI = 0.618033989;

// Declare Font Variables
PFont mainTitleF;

boolean PDFOUT = false;

// Declare Positioning Variables
float margin;
float PLOT_X1, PLOT_X2, PLOT_Y1, PLOT_Y2, PLOT_W, PLOT_H;

int rows, cols;
color groundClr, figureClr;
int tileMargin;
int boxH, boxW;
int horizDashCount = 7;
int angledDashCount = 13;
float lineLen, lineBuff;
float angLineLen, angLineBuff;
int angDW; // was -> totalAngledLineLen

PGraphics angDashes;


/*////////////////////////////////////////
 SETUP
 ////////////////////////////////////////*/

void setup() {
  background(6, 83, 203);
  stroke(252, 252, 240);
  strokeWeight(3);

  if (PDFOUT) {
    size(800, 450, PDF, generateSaveImgFileName(".pdf"));
  } else {
    // size(1200, 600); // quarter page size
    size(1231, 725); // quarter page size
  }

//   noLoop();

  rows = 4;
  cols = 6;

  boxW = 200;
  boxH = boxW;

  // dashed Line vars
  lineLen = boxW/(horizDashCount + ((horizDashCount-1) * 0.25));
  lineBuff = lineLen * 0.25;
  angDW = int(sqrt(pow(boxW,2) + pow(boxH,2)));
  angDashes = createGraphics(angDW, angDW);
  angLineLen = angDW/(angledDashCount + ((angledDashCount-1) * 0.25));
  angLineBuff = angLineLen * 0.25;

  angDashes.beginDraw();
  angDashes.background(0,0);
  angDashes.stroke(252,252,240);
  angDashes.strokeWeight(3);
  // angDashes.strokeWeight(2);
  for (int i=0; i<angledDashCount+1; i++) {
    float lineX = lerp(0, (angDW+angLineBuff), i/(angledDashCount*1.0));
    angDashes.line(lineX, angDW/2, lineX+angLineLen, angDW/2);
  }
  angDashes.endDraw();

  

  // tileMargin = 25;

  rSn = 47; // 29, 18;
  // randomSeed(rSn);

  mainTitleF = createFont("Helvetica", 18);  //requires a font file in the data folder?

  println("setup done: " + nf(millis() / 1000.0, 1, 2));

  renderWall();
}


void renderWall(){
  println("renderWall()");
  int tileId1=0;
  // background(6, 83, 203);

  // background(255, 252, 237); // pearl
  background(#2756C9); // blue
  

  stroke(252, 252, 240); // pearl
  // stroke(255, 252, 237); // also pearl
  // stroke(#2756C9); // blue
  noFill();

  int tileX, tileY;
  for (int i = 0; i < cols; i++) {
    tileX = i*boxW;

    for (int j = 0; j < rows; j++) {
      tileY = j*boxH;
      pushMatrix();
        translate(tileX, tileY);
        // strokeWeight(.1);
        // rect(0, 0, boxW, boxH);
        strokeWeight(3);

        for (int k = 0; k < 2; k++) {
          int tileId = int(random(0,16));
          if(k==0) tileId1=tileId;
          for (int l = 0; l < 10; l++) {
            if(k==1 && tileId1 == tileId) tileId = int(random(0,16));
          }

          println("tileId: "+tileId);
            float arcOrigY = 0 + sqrt(pow(boxW, 2) - pow(boxW / 2, 2)); // yay for Pythagorean theorem.
            float arcOrigX = 0;
            // float origEstimate = boxH + boxH / 2.75;
            // float leftArcEst = PI + QUARTER_PI + QUARTER_PI/PI;
            float leftArc = (PI + HALF_PI - (HALF_PI / 3));
            float rightArc = (PI + HALF_PI + (HALF_PI / 3));

            // println("arcOrigY: "+arcOrigY);
            // println("origEstimate: "+origEstimate);
            // println("leftArcEst: "+leftArcEst);
            // println("leftArc: "+leftArc);

          switch(tileId) {
          case 0: 
            line(0, boxH/2, boxW, boxH/2); // horiz line
            break;
          case 1: 
            line(boxW/2, 0, boxW/2, boxH); // vert line
            break;
          case 2: 
            line(0, 0, boxW, boxH); // left to right slash
            break;
          case 3: 
            line(boxW, 0, 0, boxH); // right to left slash
            break;
          case 4: 
            arc(0, 0, boxW*2, boxH*2, 0, PI/2); // bottom right curve
            break;
          case 5: 
            arc(boxW, 0, boxW*2, boxH*2, PI/2, PI); // bottom left curve
            break;
          case 6: 
            arc(boxW, boxH, boxW*2, boxH*2, PI, PI+PI/2); // top left curve
          break;
          case 7: 
            arc(0, boxH, boxW*2, boxH*2, PI+PI/2, TWO_PI); // top right curve
          break;
          case 8: // top curve
            pushMatrix();
            translate(boxW/2, boxH/2);
            // rotate(PI + HALF_PI);
              arc(arcOrigX, arcOrigY, boxW * 2, boxH * 2, leftArc, rightArc);
            popMatrix();
          break;
          case 9: // right side curve
            pushMatrix();
            translate(boxW/2, boxH/2);
            rotate(HALF_PI);
              arc(arcOrigX, arcOrigY, boxW * 2, boxH * 2, leftArc, rightArc);
            popMatrix();
          break;
          case 10: // bottom curve
            pushMatrix();
            translate(boxW/2, boxH/2);
            rotate(PI);
              arc(arcOrigX, arcOrigY, boxW * 2, boxH * 2, leftArc, rightArc);
            popMatrix();
          break;
          case 11: // left side curve
            pushMatrix();
            translate(boxW/2, boxH/2);
            rotate(PI + HALF_PI);
              arc(arcOrigX, arcOrigY, boxW * 2, boxH * 2, leftArc, rightArc);
            popMatrix();
          break;
          case 12: // horiz dashed line
            for(int n=0; n < horizDashCount; n++){
              // println("n: "+n);
              float lineX = lerp(0, (boxW+lineBuff), n/(horizDashCount*1.0));
              // println("lineX: "+lineX);
              line(lineX, boxW/2, lineX+lineLen, boxW/2);
            }
          break;
          case 13: // vert dashed line
          pushMatrix();
          translate(boxW/2, boxH/2);
          rotate(HALF_PI);
          translate(-boxW/2, -boxH/2);

            for(int n=0; n < horizDashCount; n++){
              // println("n: "+n);
              float lineX = lerp(0, (boxW+lineBuff), n/(horizDashCount*1.0));
              // println("lineX: "+lineX);
              line(lineX, boxW/2, lineX+lineLen, boxW/2);
            }
            popMatrix();
          break;
          case 14: // angled (/) dashed line
            pushMatrix();
            translate(boxW/2,boxH/2);
            rotate(HALF_PI/2);
            image(angDashes, -angDW/2, -angDW/2);
            popMatrix();

          break;
          case 15: // angled (/) dashed line
            pushMatrix();
            translate(boxW/2,boxH/2);
            rotate(HALF_PI + PI/4);
            image(angDashes, -angDW/2, -angDW/2);
            popMatrix();

          break;
          }
        }
      popMatrix();
    }
  }
  fill(255);
  noStroke();
  float doorW = 37.5/wallW*width;
  float doorH = 87.0/wallH*height;
  // rect(6, height, doorW, -doorH);
  // rect(0, height, width, -4.0/100*height);
}

int newTileId(int lower, int upper){ // this does nothing right now
return 0;
}

void draw() {
}

void keyPressed() {
  if (key == 'S') screenCap(".tif");
  if (key == 'u') renderWall();

}

void mousePressed() {
}

String generateSaveImgFileName(String fileType) {
  String fileName;
  // save functionality in here
  String outputDir = "out/";
  String sketchName = getSketchName() + "-";
  String randomSeedNum = "rS" + rSn + "-";
  String dateTimeStamp = "" + year() + nf(month(), 2) + nf(day(), 2) + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
  fileName = outputDir + sketchName + dateTimeStamp + randomSeedNum + fileType;
  return fileName;
}

void screenCap(String fileType) {
  String saveName = generateSaveImgFileName(fileType);
  save(saveName);
  println("Screen shot saved to: " + saveName);
}

String getSketchName() {
  String[] path = split(sketchPath, "/");
  return path[path.length-1];
}

// misc notes
/*
//razor's edge
// =320wrd/pg * 314pgs = 100480 words
// =11 pg rows * 29 pg cols = ~314pgs
// 27 words = 8.5"
// 1 word = 0.31481481481481"
// 100480 words = 31633"
// 1425 words = 8.5" x 11"

// est from pdf
// saved pdf to local disk
// file: W_Somerset_Maugham_The_Razors_Edge_1944.pdf
// words = 123000
// characters, with spaces incl. 637000
// 1 char = approx 2.81mm
// approx length of book in mm = 2.81*637000 = 1789970mm = appox 70471"
// length of book / wall width = 70471/49 = approx 1438 lines
// height of line = height of wall / num of lines = 92/1438 = 0.0000266"


// wall is 49" x 92"
// 5 pgs across
// 8 pgs down

// 5pgs * 8pgs * 1425 wrds/pg = 57000 wrds

elliott = 375 - black
isabel = 396 - green
Gray = 210 - purple (?)
Larry 405 - blue
Sophie 74 - red





*/
