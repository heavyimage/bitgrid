// f(x, y) = ((((x % y) ^ (~y)) % ((9 % y) % (y & y))) + (((-y) - (x * 1)) - ((7 | y) - (x & x)))) % 5

// TODO: dynamically rescale this, say with +/-!
final int DIM = 1024;
final int SCALE = 1;
int[][] red, green, blue;
int shade;
OpTree func;

void settings() {
  size(SCALE*DIM, SCALE*DIM);
}

int[][] initGrid() {
  int[][] grid = new color[DIM][DIM];
  for (int y=0; y < DIM; y++) {
    for (int x=0; x < DIM; x++) {
      grid[y][x] = 0;
    }
  }
  return grid;
}

void setup() {
  noStroke();
  noLoop();

  red = initGrid();
  green = initGrid();
  blue = initGrid();
}

// Draw these as they come in?!
void update(int[][] grid) {
  func = new OpTree();
  int min = Integer.MAX_VALUE;
  int max = Integer.MIN_VALUE;
  int temp;
  for (int y=0; y < DIM; y++) {
    if (y % 64 == 0) print(".");
    for (int x=0; x < DIM; x++) {
      temp = func.eval(x, y);
      if (temp > max) max = temp;
      if (temp < min) min = temp;
      grid[y][x] = temp;
    }
  }
  println();
  // Rescale
  //println("======");
  //println("min/max: " + min, ", " + max);
  for (int y=0; y < DIM; y++) {
    for (int x=0; x < DIM; x++) {
      grid[y][x] = round(map(grid[y][x], min, max, 0, 255));
    }
  }
}

void draw() {
  update(red);
  update(green);
  update(blue);
  int shade_r, shade_g, shade_b;

  for (int y=0; y < DIM; y++) {
    for (int x=0; x < DIM; x++) {
      shade_r = red[y][x];
      shade_g = green[y][x];
      shade_b = blue[y][x];
      fill(shade_r, shade_g, shade_b);
      rect(x*SCALE, y*SCALE, SCALE, SCALE);
    }
  }
  noLoop();
} 

void mouseClicked() {
  println("\n");
  if (random(1.0) > 0.5) {
    colorMode(HSB);
  } else {
    colorMode(RGB);
  }
  loop();
}

void keyPressed(){
 if (key == 's'){
    saveFrame("line-######.png");
    println("saved line-" + frameCount + ".png");
 }
}
