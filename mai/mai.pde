import java.util.Arrays;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Date;
import processing.video.*;

// --------------------------------------------------------------------------------
// User-controlled parameters

int w = 900; // Width of the composition (in pixels) including margin
int h = 900; // Height of the composition (in pixels) including margin
int margin = 10; // Space around the composition (in pixels)
int fps = 30;

int columns = 12; // Number of grid rows
int rows = 12; // Number of grid columns
boolean animateGrid = false;
float gridAnimationSpeed = 0.0015; // Increment to be added to the Perlin noise offset values

int logoCol = 1; // Logo horizontal position (column index)
int logoRow = 1; // Logo vertical position (row index)
color[] logoColours = {#000000, #FFFFFF, #0000FF, #8cff00, #6600ff}; // Options for the logo colour

String pathInputMedia = "photos_highres/photo2.jpg";
//String pathInputMedia = "media/C53dxFctxG9.mp4";
float minCropZoom = 0.8; // 1 means no zoom
float maxCropZoom = 1.2; // 1 means no zoom
float maxCropDisplacement = 0.1; // 0 means no displacement

boolean feednplayMode = true;
//PImage qrCodeImage = null;
//PVector qrCodePosition = null;
TickerBar ticker;
int currImageIndex = 0;


// End of user-controlled parameters
// --------------------------------------------------------------------------------

int previousWidth = 0;
int previousHeight = 0;

Grid grid = null;
int gridMode = 3;
boolean debugMode = false;

ArrayList<Block> blocks = null;

PImage inputMedia = null;
PImage inputMediaCropped = null;
Movie inputVideo = null;

LogoConfig[] configs = null;
int selectedConfigIndex = 0;
int selectedLogoColour = 0;
boolean drawLogo = true;

boolean exportSingleFrame = false;
boolean exportFrames = false;
int exportedFrames = 0;
File outputDir = null;

void settings() {
  if (feednplayMode) {
    //fullScreen(P3D);
    float scale = 3;
    size(int(970 * scale), int(192 * scale), P3D);
  } else {
    size(w, h, P3D);
  }
  smooth(8);
}

void setup() {
  if (feednplayMode) {
    fps = 60;
    rows = 16;
    columns = round(rows * (width / (float) height));
    margin = 0;
    animateGrid = true;
    //qrCodeImage = loadImage("qrcode/qrcode-white.png");
    ticker = new TickerBar(0.05, 2);
  }

  frameRate(fps);
  surface.setResizable(true);

  loadLogoConfigs();
  createGrid();
}

void draw() {
  if (!feednplayMode) {
    updateWindowTitle();
  }
  if (frameCount == 1) {
    loadInputMedia();
  }
  if (inputVideo != null) {
    readInputVideoFrame();
  }
  if (width != previousWidth || height != previousHeight || inputVideo != null) {
    previousWidth = width;
    previousHeight = height;
    grid.setSize(width - margin * 2, height - margin * 2);
    cropInputMediaBasedOnGridSize();
  }
  if (animateGrid) {
    grid.animate(gridAnimationSpeed);
  }

  //background(screenSaverMode ? 0 : 255);
  background(255);
  translate(margin, margin);

  if (gridMode == 1) {
    grid.draw(getGraphics(), debugMode);
  } else if (gridMode == 2) {
    for (Block b : blocks) {
      b.drawRect(getGraphics(), debugMode);
    }
  } else if (gridMode == 3) {
    for (Block b : blocks) {
      b.drawTexture(getGraphics(), inputMediaCropped);
    }
  }

  if (drawLogo) {
    noStroke();
    fill(logoColours[selectedLogoColour]);
    configs[selectedConfigIndex].draw(getGraphics(), grid, logoCol, logoRow);
  }

  if (exportFrames || exportSingleFrame) {
    if (outputDir == null) {
      String timestamp = new SimpleDateFormat("yyyy-MM-dd HH-mm-ss").format(new Date());
      String outputDirName = timestamp;
      if (exportFrames) {
        outputDirName += " " + fps + "fps";
      }
      outputDir = Paths.get(sketchPath("outputs"), outputDirName).toFile();
      assert !outputDir.exists();
      outputDir.mkdirs();
      exportedFrames = 0;
    }

    save(Paths.get(outputDir.getAbsolutePath(), nf(exportedFrames + 1, 6) + ".png").toString());
    if (exportSingleFrame) {
      exportSingleFrame = false;
    } else {
      exportedFrames += 1;
    }
  } else {
    if (outputDir != null) {
      outputDir = null;
    }
  }

  if (feednplayMode) {
    if (frameCount % (60 * 4) == 0) {
      if (frameCount % (60 * 30) == 0) {
        selectedConfigIndex = int(random(configs.length));
        createGrid();
        currImageIndex = (currImageIndex + 1) % 8;
        pathInputMedia = "photos_highres/photo" + (currImageIndex + 1) + ".jpg";
        loadInputMedia();
        cropInputMediaBasedOnGridSize();
      }
      logoCol = int(random(0, grid.getNumCols() - configs[selectedConfigIndex].getNumCols() - 1));
      logoRow = int(random(0, grid.getNumRows() - configs[selectedConfigIndex].getNumRows() - 1));
    }

    hint(DISABLE_DEPTH_TEST);

    /*
    int qrColLeft = -3;
     int qrRowTop = -3;
     Cell qrTopLeftCell = grid.getCell(qrColLeft, qrRowTop);
     Cell qrBottomRightCell = grid.getCell(qrColLeft + 1, qrRowTop + 1);
     float qrX = qrTopLeftCell.x;
     float qrY = qrTopLeftCell.y;
     float qrW = (qrBottomRightCell.x + qrBottomRightCell.w) - qrX;
     float qrH = (qrBottomRightCell.y + qrBottomRightCell.h) - qrY;
     float qrMargin = 0.1 * min(qrW, qrH);
     float[] qrSize = resizeToFitInside(qrCodeImage.width, qrCodeImage.height, qrW - qrMargin * 2, qrH - qrMargin * 2);
     
     stroke(logoColours[selectedLogoColour]);
     strokeWeight(0.5);
     fill(0);
     rect(qrX, qrY, qrW, qrH);
     
     pushStyle();
     //tint(logoColours[selectedLogoColour]);
     imageMode(CENTER);
     image(qrCodeImage, qrX + qrW / 2, qrY + qrH / 2, qrSize[0], qrSize[1]);
     popStyle();
     
     fill(0, 255, 0);
     //Block b = blocks.get(int(random(blocks.size())));
     Block b = blocks.get(0);
     drawTextBox("Isto é um teste.<br>Olá.<br>Tiago Martins Tiago Martins Tiago Martins", b.getX(), b.getY(), b.getWidth(), b.getHeight(), 10);
     */

    ticker.update();
    ticker.display();

    hint(ENABLE_DEPTH_TEST);
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      logoCol -= 1;
    } else if (keyCode == RIGHT) {
      logoCol += 1;
    } else if (keyCode == UP) {
      logoRow -= 1;
    } else if (keyCode == DOWN) {
      logoRow += 1;
    }
  } else {
    if (key >= '1' && key <= '3') {
      gridMode = key - '0';
    } else if (key == '4') {
      drawLogo = !drawLogo;
    } else if (key == 'd') {
      debugMode = !debugMode;
    } else if (key == 'g') {
      createGrid();
    } else if (key == 'l') {
      //selectedConfigIndex = (selectedConfigIndex + 1) % configs.length;
      selectedConfigIndex = int(random(configs.length));
    } else if (key == ENTER) {
      //selectedConfigIndex = (selectedConfigIndex + 1) % configs.length;
      selectedConfigIndex = int(random(configs.length));
      createGrid();
    } else if (key == 'c') {
      selectedLogoColour = (selectedLogoColour + 1) % logoColours.length;
    } else if (key == ' ') {
      animateGrid = !animateGrid;
    } else if (key == 'e') {
      if (!exportSingleFrame) {
        exportFrames = !exportFrames;
      }
    } else if (key == 's') {
      if (!exportFrames) {
        exportSingleFrame = !exportSingleFrame;
      }
    }
  }
}


void createGrid() {
  if (feednplayMode) {
    grid = new Grid(width, height - ticker.barHeight, columns, rows);
  } else {
    grid = new Grid(width - margin * 2, height - margin * 2, columns, rows);
  }
  calculateBlocks();
}


void calculateBlocks() {
  float maxBlockSizeRelative = 0.5;

  blocks = new ArrayList<Block>();
  ArrayList<Cell> cellsUsed = new ArrayList<Cell>();
  int numCells = grid.getNumCols() * grid.getNumRows();

  // Try different blocks
  for (int tryBlock = 0; tryBlock < numCells; tryBlock++) {

    // Set random block size
    int blockW, blockH;
    if (random(1) < 0.5) {
      // Horizontal block
      blockW = int(random(1, grid.getNumCols() * maxBlockSizeRelative + 1));
      blockH = int(random(0.1, 0.5) * blockW);
    } else {
      // Vertical block
      blockH = int(random(1, grid.getNumRows() * maxBlockSizeRelative + 1));
      blockW = int(random(0.1, 0.5) * blockH);
    }

    // Constrain block size to grid size
    blockW = constrain(blockW, 1, grid.getNumCols());
    blockH = constrain(blockH, 1, grid.getNumRows());

    // Try different positions
    for (int tryPos = 0; tryPos < 50; tryPos++) {

      // Set random block position
      int blockX = int(random(0, grid.getNumCols() - blockW + 1));
      int blockY = int(random(0, grid.getNumRows() - blockH + 1));

      // Check if this position does not result in an intersection with an existing block
      boolean valid = true;
      for (int row = blockY; row < blockY + blockH; row++) {
        for (int col = blockX; col < blockX + blockW; col++) {
          if (cellsUsed.contains(grid.getCell(col, row))) {
            valid = false;
            break;
          }
        }
        if (!valid) break;
      }

      // Add block
      if (valid) {
        for (int row = blockY; row < blockY + blockH; row++) {
          for (int col = blockX; col < blockX + blockW; col++) {
            cellsUsed.add(grid.getCell(col, row));
          }
        }
        blocks.add(new Block(grid, blockX, blockY, blockW, blockH));
        break;
      }
    }

    // Break if grid is already filled with blocks
    if (cellsUsed.size() == numCells) {
      break;
    }
  }

  // Fill empty cells with 1x1 blocks
  for (int row = 0; row < grid.getNumRows(); row++) {
    for (int col = 0; col < grid.getNumCols(); col++) {
      if (!cellsUsed.contains(grid.getCell(col, row))) {
        blocks.add(new Block(grid, col, row, 1, 1));
        cellsUsed.add(grid.getCell(col, row));
      }
    }
  }

  assert cellsUsed.size() == numCells;
}


void loadLogoConfigs() {
  File folder = new File(dataPath("letters"));
  assert folder.isDirectory();
  File[] files = folder.listFiles();
  Arrays.sort(files);

  ArrayList<File> textFiles = new ArrayList<File>();
  for (File f : files) {
    if (f.isFile() && f.getName().endsWith(".txt")) {
      textFiles.add(f);
    }
  }
  assert textFiles.size() > 0;

  configs = new LogoConfig[textFiles.size()];
  for (int i = 0; i < configs.length; i++) {
    configs[i] = new LogoConfig(textFiles.get(i));
  }
}


void loadInputMedia() {
  if (pathInputMedia.endsWith(".mp4") || pathInputMedia.endsWith(".mov")) {
    inputVideo = new Movie(this, pathInputMedia);
    inputVideo.loop();
    inputVideo.volume(0);
  } else {
    inputMedia = loadImage(pathInputMedia);
  }
}


void readInputVideoFrame() {
  if (inputVideo.available()) {
    inputVideo.read();
    inputVideo.loadPixels(); // Needed to get each video frame when using P3D renderer
    image(inputVideo, -inputVideo.width * 2, -inputVideo.height * 2); // Needed to get each video frame when using P3D renderer
    inputMedia = inputVideo.copy();
  }
}


void cropInputMediaBasedOnGridSize() {
  if (inputMedia != null) {
    inputMediaCropped = inputMedia.copy();
    float[] newSize = resizeToFitOutside(inputMedia.width, inputMedia.height, grid.getWidth(), grid.getHeight());
    inputMediaCropped.resize(round(newSize[0]), round(newSize[1]));
    int cropX = int(inputMediaCropped.width / 2 - grid.getWidth() / 2);
    int cropY = int(inputMediaCropped.height / 2 - grid.getHeight() / 2);
    inputMediaCropped = inputMediaCropped.get(cropX, cropY, int(grid.getWidth()), int(grid.getHeight()));
  }
}


void updateWindowTitle() {
  String title = "MAI Visual Identity System";
  //title += "  [";
  //title += "logo=" + configs[selectedConfigIndex].getName();
  //title += " w=" + width;
  //title += " h=" + height;
  //title += "]";
  if (exportFrames) {
    title += "  [Exported " + exportedFrames + " frames or " + nf(exportedFrames / (float) fps, 0, 1) + "s@" + fps + "fps]";
  }
  surface.setTitle(title);
}
