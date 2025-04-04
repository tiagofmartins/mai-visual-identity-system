class Grid {

  float w; // Width
  float h; // Height
  Cell[][] cells = null; // 2D array to store all cells (columns x rows)
  float[] noiseOffsetsCols = null;
  float[] noiseOffsetsRows = null;

  Grid(float w, float h, int cols, int rows) {
    setColsRows(cols, rows);
    setSize(w, h);
  }

  void setSize(float w, float h) {
    if (this.w != w || this.h != h) {
      this.w = w;
      this.h = h;
      calculateCells();
    }
  }

  void setColsRows(int cols, int rows) {
    cells = new Cell[rows][cols];
    noiseOffsetsCols = new float[cols];
    noiseOffsetsRows = new float[rows];
    for (int col = 0; col < cols; col++) {
      noiseOffsetsCols[col] = random(1000);
    }
    for (int row = 0; row < rows; row++) {
      noiseOffsetsRows[row] = random(1000);
    }
    calculateCells();
  }

  void animate(float speed) {
    for (int col = 0; col < getNumCols(); col++) {
      noiseOffsetsCols[col] += speed;
    }
    for (int row = 0; row < getNumRows(); row++) {
      noiseOffsetsRows[row] += speed;
    }
    calculateCells();
  }

  void calculateCells() {
    // Calculate sum of noise values
    float sumNoiseCols = 0;
    for (int col = 0; col < getNumCols(); col++) {
      sumNoiseCols += noise(noiseOffsetsCols[col]);
    }
    float sumNoiseRows = 0;
    for (int row = 0; row < getNumRows(); row++) {
      sumNoiseRows += noise(noiseOffsetsRows[row]);
    }

    // Calculate position and size of each cell
    float cellY = 0;
    for (int row = 0; row < getNumRows(); row++) {
      float cellX = 0;
      float cellH = map(noise(noiseOffsetsRows[row]), 0, sumNoiseRows, 0, h);
      for (int col = 0; col < getNumCols(); col++) {
        float cellW = map(noise(noiseOffsetsCols[col]), 0, sumNoiseCols, 0, w);
        cells[row][col] = new Cell(cellX, cellY, cellW, cellH);
        cellX += cellW;
      }
      cellY += cellH;
    }
  }

  void draw(PGraphics pg, boolean debug) {
    pg.pushStyle();
    for (int row = 0; row < getNumRows(); row++) {
      for (int col = 0; col < getNumCols(); col++) {
        Cell c = getCell(col, row);
        pg.noFill();
        pg.stroke(0);
        pg.strokeWeight(1);
        pg.rect(c.x, c.y, c.w, c.h);
        if (debug) {
          pg.fill(0);
          pg.textAlign(LEFT, TOP);
          pg.textSize(12);
          pg.textLeading(pg.textSize * 1.1);
          pg.text(nf(c.x, 0, 1) + " " + nf(c.y, 0, 1) + "\n" + nf(c.w, 0, 1) + " " + nf(c.h, 0, 1), c.x + 3, c.y + 3);
        }
      }
    }
    pg.popStyle();
  }

  Cell getCell(int colIndex, int rowIndex) {
    return cells[rowIndex][colIndex];
  }

  float getWidth() {
    return w;
  }

  float getHeight() {
    return h;
  }

  int getNumCols() {
    return cells[0].length;
  }

  int getNumRows() {
    return cells.length;
  }
}


class Cell {

  float x; // Top-left x-coodinate
  float y; // Top-left y-coordinate
  float w; // Width
  float h; // Height

  Cell(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
}
