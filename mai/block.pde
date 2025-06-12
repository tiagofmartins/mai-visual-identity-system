class Block {

  Grid grid;
  int col;
  int row;
  int colsW;
  int rowsH;
  float randomDisplacementX = 1;
  float randomDisplacementY = 1;
  float randomZoom = 1;

  Block(Grid grid, int col, int row, int colsW, int rowsH) {
    this.grid = grid;
    this.col = col;
    this.row = row;
    this.colsW = colsW;
    this.rowsH = rowsH;
    randomDisplacementX = random(maxCropDisplacement);
    randomDisplacementY = random(maxCropDisplacement);
    randomZoom = random(minCropZoom, maxCropZoom);
  }

  void drawRect(PGraphics pg, boolean debug) {
    pg.push();
    pg.translate(getX(), getY());

    pg.noFill();
    pg.stroke(0);
    pg.strokeWeight(1);
    pg.rect(0, 0, getWidth(), getHeight());

    if (debug) {
      pg.fill(0);
      pg.textAlign(LEFT, TOP);
      pg.textSize(12);
      pg.textLeading(pg.textSize * 1.1);
      pg.text(colsW + "x" + rowsH, 3, 3);
    }

    pg.pop();
  }

  void drawTexture(PGraphics pg, PImage source) {
    // Normalised size
    float textureW = getWidth() / (float) grid.getWidth();
    float textureH = getHeight() / (float) grid.getHeight();
    textureW *= randomZoom;
    textureH *= randomZoom;

    // Normalised centre coordinates
    float textureCentreX = getCentreX() / (float) grid.getWidth();
    float textureCentreY = getCentreY() / (float) grid.getHeight();
    textureCentreX *= (1 + randomDisplacementX);
    textureCentreY *= (1 + randomDisplacementY);

    // Normalised top-left coordinates
    float textureX1 = textureCentreX - textureW / 2;
    float textureY1 = textureCentreY - textureH / 2;
    textureX1 = constrain(textureX1, 0, 1 - textureW);
    textureY1 = constrain(textureY1, 0, 1 - textureH);

    // Normalised bottom-right coordinates
    float textureX2 = textureX1 + textureW;
    float textureY2 = textureY1 + textureH;

    // Draw textured rectangle
    pg.push();
    if (feednplayMode) {
      pg.stroke(logoColours[selectedLogoColour]);
      pg.strokeWeight(0.5);
    } else {
      pg.noStroke();
    }
    pg.textureMode(NORMAL);
    pg.beginShape();
    pg.texture(source);
    pg.vertex(getX(), getY(), textureX1, textureY1);
    pg.vertex(getX() + getWidth(), getY(), textureX2, textureY1);
    pg.vertex(getX() + getWidth(), getY() + getHeight(), textureX2, textureY2);
    pg.vertex(getX(), getY() + getHeight(), textureX1, textureY2);
    pg.endShape();
    pg.pop();
  }

  float getX() {
    return this.grid.getCell(col, row).x;
  }

  float getY() {
    return this.grid.getCell(col, row).y;
  }

  float getWidth() {
    Cell bottomRightCell = this.grid.getCell(col + (colsW - 1), row + (rowsH - 1));
    float rightLimit = bottomRightCell.x + bottomRightCell.w;
    return rightLimit - getX();
  }

  float getHeight() {
    Cell bottomRightCell = this.grid.getCell(col + (colsW - 1), row + (rowsH - 1));
    float bottomLimit = bottomRightCell.y + bottomRightCell.h;
    return bottomLimit - getY();
  }

  float getCentreX() {
    return getX() + getWidth() / 2;
  }

  float getCentreY() {
    return getY() + getHeight() / 2;
  }
}
