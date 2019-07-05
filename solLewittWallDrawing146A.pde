// Recreating Sol Lewitt's Wall Drawing 146A (1972)
// "All two-part combinations of blue arcs from corners 
// and sides, and blue straight, not straight, and broken 
// lines."
// http://www.massmoca.org/lewitt/walldrawing.php?id=146A

// Keyboard UI
// "u" = refresh wall with new drawing
// Arrow keys up/down will add/remove rows
// Arrow keys left/right will remove/add columns
// "S" = screencap to .jpg

// Physical Room Dimensions
float wallH = 96.75;
float wallW = 152;
// 37.5x83 - door size in inches
boolean showDoor = true;

color groundClr = #2756C9;
color figureClr = color(252, 252, 240);
int rows, cols;
int boxH, boxW;

int horizDashCount = 7;
int angledDashCount = 13;

float lineLen, lineBuff;

PGraphics angDashes;
float angLineLen, angLineBuff;
int angDW; // was -> totalAngledLineLen



/*////////////////////////////////////////
 SETUP
 ////////////////////////////////////////*/

void setup() {
  size(1231, 725);
  rows = 3;
  cols = 7;
  setGridVars();
  renderWall();

  println("setup done: " + nf(millis() / 1000.0, 1, 2));
}



/*////////////////////////////////////////
 DRAW
 ////////////////////////////////////////*/

void draw() { 
  // Typically, this is where a lot of the update code would go for most sketches. Not using 
  // draw() at all for this sketch. Leaving it in as an indicator that it isn't in fact being used.
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

  // Create angled dash image on trasparent background for use in cases #s 14 & 15
  angDashes = createGraphics(angDW, angDW);
  angDashes.beginDraw();
  angDashes.background(0, 0); // important that this be transparent
  angDashes.stroke(figureClr); // off white - pearl colour
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

  background(groundClr); // blue
  stroke(figureClr); // pearl
  strokeWeight(3);
  noFill();

  int tileId1 = -1; // var to track id of first tile number so that we can check for two same tiles in a box
  int tileX, tileY;

  for (int i = 0; i < cols; i++) {
    tileX = i*boxW;

    for (int j = 0; j < rows; j++) {
      println("\nRxC: "+ (1+j) + 'x' + (1+i));
      tileY = j*boxH;

      // pre-calculate arc coords to use in case #s 8-11
      float arcOrigX = 0;
      float arcOrigY = 0 + sqrt(pow(boxW, 2) - pow(boxW / 2, 2)); // yay for Pythagorean theorem
      float leftArc = (PI + HALF_PI - (HALF_PI / 3));
      float rightArc = (PI + HALF_PI + (HALF_PI / 3));

      pushMatrix();
      translate(tileX, tileY);
      for (int k = 0; k < 2; k++) {
        // get two unique tile ids
        int tileId = int(random(0, 16));
        if (k==0) tileId1=tileId;
        for (int l = 0; l < 10; l++) { // janky, but running this 10x to (hopefully) ensure a different tile id. 1/10E10 chance
          if (k==1 && tileId1 == tileId) tileId = int(random(0, 16));
        }
        println("tileId"+k+": "+tileId);

        // render a line based on a tileId
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
            float lineX = lerp(0, (boxW+lineBuff), n/(horizDashCount*1.0));
            line(lineX, boxW/2, lineX+lineLen, boxW/2);
          }
          break;
        case 13: // vert dashed line
          pushMatrix();
          translate(boxW/2, boxH/2);
          rotate(HALF_PI);
          translate(-boxW/2, -boxH/2);
          for (int n=0; n < horizDashCount; n++) {
            float lineX = lerp(0, (boxW+lineBuff), n/(horizDashCount*1.0));
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
  if (showDoor) {
    fill(255);
    noStroke();
    float doorW = 37.5/wallW*width;
    float doorH = 87.0/wallH*height;
    rect(6, height, doorW, -doorH);
  }
}



/*////////////////////////////////////////
 Keyboard UI
 ////////////////////////////////////////*/

void keyPressed() {
  if (key == 'S') screenCap(".jpg");
  if (key == 'u') renderWall();
  if (key == 'd') { 
    showDoor = (showDoor) ? false : true;
    renderWall();
  }

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



/*////////////////////////////////////////
 Save Image Output
 ////////////////////////////////////////*/

String generateSaveImgFileName(String fileType) {
  String fileName;
  String outputDir = "output/";
  String sketchName = getSketchName() + "-";
  String colXRowCount = rows+"x"+cols+"-";
  String dateTimeStamp = "" + year() + nf(month(), 2) + nf(day(), 2) + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
  fileName = outputDir + sketchName + colXRowCount + dateTimeStamp + fileType;
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
