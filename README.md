# mai_visual_identity_generator

This system generates visual compositions that serve as the visual identity of the [Master in Artificial Intelligence (MAI)](https://www.dei.uc.pt/mia) at the University of Coimbra. Designed as a generative and dynamic approach to branding, the compositions are built from a grid-based layout that integrates custom typographic elements with rich media sources such as images and videos. The result is a flexible visual system capable of producing endless variations, suitable for posters, animations, and digital media.

This system is implemented as a Processing sketch, making it easy to run and instantly generate new visual compositions with minimal setup.


### Parameters Overview

Below is a list of the main parameters and what they control in the system.

| Parameter              | Description |
|------------------------|-------------|
| `w`                    | Width of the composition in pixels, including margin. |
| `h`                    | Height of the composition in pixels, including margin. |
| `margin`               | Space, in pixels, added as outer margin around the composition. |
| `fps`                  | Frames per second used during animation and [video export](#exporting-video). |
| `columns`              | Number of columns in the layout grid. |
| `rows`                 | Number of rows in the layout grid. |
| `animateGrid`          | If `true`, the grid will animate using Perlin noise over time. |
| `gridAnimationSpeed`   | Speed of Perlin noise-based animation; higher values increase motion intensity. |
| `logoCol`              | Horizontal position of the logo in the grid (column index). |
| `logoRow`              | Vertical position of the logo in the grid (row index). |
| `logoColours`          | Array of preset colors that can be used for the logo. |
| `pathInputMedia`       | File path to the input image or video used as background media. |
| `minCropZoom`          | Minimum zoom applied to cropped media content. |
| `maxCropZoom`          | Maximum zoom applied to cropped media content. |
| `maxCropDisplacement`  | Maximum offset for randomly displacing the cropped area; `0` means no displacement. |


### Keyboard Shortcuts

Use the keyboard to interact with the system. Here’s what each key does:

| Key         | Description |
|-------------|-------------|
| ← (LEFT)    | Move the logo one column to the left in the grid. |
| → (RIGHT)   | Move the logo one column to the right in the grid. |
| ↑ (UP)      | Move the logo one row up in the grid. |
| ↓ (DOWN)    | Move the logo one row down in the grid. |
| `1`, `2`, `3` | Change the grid mode. Each mode defines a different grid layout logic. |
| `4`         | Toggle the visibility of the logo. When off, only the media/grid is shown. |
| `d`         | Toggle debug mode. |
| `g`         | Generate a new grid. |
| `l`         | Load a random configuration for the logo from the available set of options. |
| `Enter`     | Load a random configuration and immediately regenerate the grid. Useful for exploring new variations quickly. |
| `c`         | Cycle through the available logo colours. |
| `Space`     | Toggle grid animation. When enabled, the grid deforms over time using Perlin noise. |
| `e`         | Toggle multi-frame export. Only available if single-frame export is off. |
| `s`         | Toggle single-frame export. Only available if multi-frame export is off. |


### Exporting Video

The system supports video creation by exporting an image sequence of animation frames. These frames are saved into the `outputs` folder and can be compiled into a video using software such as QuickTime, ffmpeg, or any other tool that supports frame sequences. When creating the final video, make sure to use the correct frame rate, which is defined by the `fps` parameter in the sketch. This ensures that the timing and playback speed of the final video match the intended animation.
