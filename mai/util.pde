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
