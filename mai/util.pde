float[] resizeToFitInside(float resize_w, float resize_h, float fit_w, float fit_h) {
  float aspect_ratio_resize = resize_w / resize_h;
  float aspect_ratio_fit = fit_w / fit_h;
  float x, y;
  if (aspect_ratio_fit >= aspect_ratio_resize) {
    x = fit_h * aspect_ratio_resize;
    y = fit_h;
  } else {
    x = fit_w;
    y = fit_w / aspect_ratio_resize;
  }
  return new float[]{x, y};
}

float[] resizeToFitOutside(float resize_w, float resize_h, float fit_w, float fit_h) {
  float aspect_ratio_resize = resize_w / resize_h;
  float aspect_ratio_fit = fit_w / fit_h;
  float x, y;
  if (aspect_ratio_fit >= aspect_ratio_resize) {
    x = fit_w;
    y = fit_w / aspect_ratio_resize;
  } else {
    x = fit_h * aspect_ratio_resize;
    y = fit_h;
  }
  return new float[]{x, y};
}

void drawTextBox(String rawText, float x, float y, float w, float h, float padding) {
  String[] lines = rawText.split("<br>");
  textAlign(LEFT, TOP);
  textLeading(0); // Garantir que o leading não afete o layout

  // Reduz a área utilizável com base no padding
  float innerX = x + padding;
  float innerY = y + padding;
  float innerW = w - 2 * padding;
  float innerH = h - 2 * padding;

  float fontSize = calculateFontSize(lines, innerW, innerH);
  textSize(fontSize);

  float totalHeight = lines.length * fontSize;
  float startY = innerY;

  for (int i = 0; i < lines.length; i++) {
    text(lines[i], innerX, startY + i * fontSize);
  }
}

float calculateFontSize(String[] lines, float boxWidth, float boxHeight) {
  float testSize = 100;
  textSize(testSize);

  // Largura máxima de linha
  float maxWidth = 0;
  for (String line : lines) {
    float lineWidth = textWidth(line);
    if (lineWidth > maxWidth) maxWidth = lineWidth;
  }

  // Escalas
  float scaleX = boxWidth / maxWidth;
  float scaleY = boxHeight / (lines.length * testSize);

  float result = testSize * min(scaleX, scaleY);

  result = max(floor(result / 10f), 1) * 10;

  return result;
}
