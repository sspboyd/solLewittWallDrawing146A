// Recreating Sol Lewitt's Wall Drawing 146A
// http://www.massmoca.org/lewitt/walldrawing.php?id=146A

// Wall Drawing #146 (1972)
// All two-part combinations of blue arcs from corners 
// and sides, and blue straight, not straight, and broken 
// lines. 


//Declare Globals
final float PHI = 0.618033989;
int rSn; // randomSeed number. put into var so can be saved in file name. defaults to 47

boolean PDFOUT = false; // controls if the wall output will be saved to a PDF

// Declare Positioning Variables
float margin;
float PLOT_X1, PLOT_X2, PLOT_Y1, PLOT_Y2, PLOT_W, PLOT_H;

int rows, cols;
color groundClr, figureClr;
int boxH, boxW;
int horizDashCount = 7;
int angledDashCount = 13;
float lineLen, lineBuff;
float angLineLen, angLineBuff;
int angDW; // was -> totalAngledLineLen

PGraphics angDashes;

// Physical Room Dimensions
float wallH = 96.75;
float wallW = 152;
// 37.5x83 - door size in inches



/*////////////////////////////////////////
 SETTINGS
 ////////////////////////////////////////*/

void settings() {
  if (PDFOUT) {
    size(800, 450, PDF, generateSaveImgFileName(".pdf"));
  } else {
    // size(1200, 600); // quarter page size
    size(1231, 725); // quarter page size
  }
}

/*////////////////////////////////////////
 SETUP
 ////////////////////////////////////////*/

void setup() {
  rows = 3;
  cols = 7;
  setGridVars();
  renderWall();

  rSn = 47; // 29, 18;
  // randomSeed(rSn);
  println("setup done: " + nf(millis() / 1000.0, 1, 2));
}


void setGridVars() {
  boxH = int( (wallH/rows) * (height/wallH) ); // box height in inches then converted to pixels
  boxW = boxH; // since they're squares...

  // Dashed Line vars
  lineLen = boxW/(horizDashCount + ((horizDashCount-1) * 0.25));
  lineBuff = lineLen * 0.25;
  angDW = int(sqrt(pow(boxW, 2) + pow(boxH, 2)));
  angLineLen = angDW/(angledDashCount + ((angledDashCount-1) * 0.25));
  angLineBuff = angLineLen * 0.25;

  angDashes = createGraphics(angDW, angDW);
  angDashes.beginDraw();
  angDashes.background(0, 0);
  angDashes.stroke(252, 252, 240);
  angDashes.strokeWeight(3);
  for (int i=0; i<angledDashCount+1; i++) {
    float lineX = lerp(0, (angDW+angLineBuff), i/(angledDashCount*1.0));
    angDashes.line(lineX, angDW/2, lineX+angLineLen, angDW/2);
  }
  angDashes.endDraw();
}


void renderWall() {
  println("renderWall()");
  println("Rows: "+rows + ". Cols: "+cols);
  println("boxH in inches: "+ wallH/rows);

  int tileId1=0;
  background(#2756C9); // blue
  stroke(252, 252, 240); // pearl
  noFill();

  int tileX, tileY;
  for (int i = 0; i < cols; i++) {
    tileX = i*boxW;

    for (int j = 0; j < rows; j++) {
      println("\nRxC: "+ i + 'x' + j);
      tileY = j*boxH;
      pushMatrix();
      translate(tileX, tileY);
      strokeWeight(3);

      for (int k = 0; k < 2; k++) {
        int tileId = int(random(0, 16));
        if (k==0) tileId1=tileId;
        for (int l = 0; l < 10; l++) {
          if (k==1 && tileId1 == tileId) tileId = int(random(0, 16));
        }

        println("tileId: "+tileId+". ");
        float arcOrigY = 0 + sqrt(pow(boxW, 2) - pow(boxW / 2, 2)); // yay for Pythagorean theorem.
        float arcOrigX = 0;
        float leftArc = (PI + HALF_PI - (HALF_PI / 3));
        float rightArc = (PI + HALF_PI + (HALF_PI / 3));

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
          for (int n=0; n < horizDashCount; n++) {
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

          for (int n=0; n < horizDashCount; n++) {
            // println("n: "+n);
            float lineX = lerp(0, (boxW+lineBuff), n/(horizDashCount*1.0));
            // println("lineX: "+lineX);
            line(lineX, boxW/2, lineX+lineLen, boxW/2);
          }
          popMatrix();
          break;
        case 14: // angled (/) dashed line
          pushMatrix();
          translate(boxW/2, boxH/2);
          rotate(HALF_PI/2);
          image(angDashes, -angDW/2, -angDW/2);
          popMatrix();

          break;
        case 15: // angled (/) dashed line
          pushMatrix();
          translate(boxW/2, boxH/2);
          rotate(HALF_PI + PI/4);
          image(angDashes, -angDW/2, -angDW/2);
          popMatrix();

          break;
        }
      }
      popMatrix();
    }
  }

  // Draw the door
  fill(255);
  noStroke();
  float doorW = 37.5/wallW*width;
  float doorH = 87.0/wallH*height;
  rect(6, height, doorW, -doorH);
}

void draw() {
}

void keyPressed() {
  if (key == 'S') screenCap(".tif");
  if (key == 'u') renderWall();

  if (key == CODED) {
    boolean updateWall = false;
    if (keyCode == UP) {
      rows++;
      updateWall = true;
    } else if (keyCode == DOWN) {
      if (rows>0) rows--;
      updateWall = true;
    } else if (keyCode == LEFT) {
      if (cols>0) cols--;
      updateWall = true;
    } else if (keyCode == RIGHT) {
      cols++;
      updateWall = true;
    }
    if (updateWall) {
      setGridVars();
      renderWall();
    }
  }
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
  String spath = sketchPath();
  String[] path = split(spath, "/");
  return path[path.length-1];
}
