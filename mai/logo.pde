class LogoConfig {

  final static char MODULE_NONE = ' ';
  final static char MODULE_FILL = 'x';
  final static char MODULE_GAP_TOP = '^';
  final static char MODULE_GAP_LEFT = '<';

  File textFile;
  char[][] modules;

  LogoConfig(File textFile) {
    this.textFile = textFile;

    // Load modules (characters) from input text file
    String[] textLines = loadStrings(textFile.getAbsolutePath());
    for (int l = 0; l < textLines.length; l++) {
      textLines[l] = textLines[l].replaceAll("\\s+$", ""); // Remove trailing spaces
    }

    // Determine width (number of columns) and height (number of rows)
    int rows = textLines.length;
    int cols = 0;
    for (int row = 0; row < rows; row++) {
      cols = max(cols, textLines[row].length());
    }

    // Create 2D array with empty modules
    modules = new char[rows][cols];
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        modules[row][col] = MODULE_NONE;
      }
    }

    // Insert non-empty modules
    for (int row = 0; row < textLines.length; row++) {
      char[] currLineChars = textLines[row].toCharArray();
      for (int col = 0; col < currLineChars.length; col++) {
        char c = currLineChars[col];
        if (c == MODULE_FILL || c == MODULE_GAP_TOP || c == MODULE_GAP_LEFT) {
          modules[row][col] = c;
        }
      }
    }
  }

  void draw(PGraphics pg, Grid g, int posCol, int posRow) {
    float gap = 0.1 * min(g.getWidth() / g.getNumCols(), g.getHeight() / g.getNumRows());
    gap = max(gap, 3);

    pg.pushStyle();
    pg.strokeWeight(0.5);
    pg.stroke(pg.fillColor);
    for (int row = 0; row < getNumRows(); row++) {
      int gridRow = posRow + row;
      if (gridRow >= 0 && gridRow < g.getNumRows()) {
        for (int col = 0; col < getNumCols(); col++) {
          int gridCol = posCol + col;
          if (gridCol >= 0 && gridCol < g.getNumCols()) {
            Cell c = g.getCell(gridCol, gridRow);
            if (modules[row][col] == MODULE_FILL) {
              pg.rect(c.x, c.y, c.w, c.h);
            } else if (modules[row][col] == MODULE_GAP_LEFT) {
              pg.rect(c.x + gap, c.y, c.w - gap, c.h);
            } else if (modules[row][col] == MODULE_GAP_TOP) {
              pg.rect(c.x, c.y + gap, c.w, c.h - gap);
            }
          }
        }
      }
    }
    pg.popStyle();
  }

  int getNumCols() {
    return modules[0].length;
  }

  int getNumRows() {
    return modules.length;
  }

  String getName() {
    //return textFile.getName();
    int lastDotIndex = textFile.getName().lastIndexOf('.');
    return textFile.getName().substring(0, lastDotIndex);
  }
}
