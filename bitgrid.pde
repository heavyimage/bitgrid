// GOAL: generate per-pixel functions like this one:
// f(x, y) = ((((x % y) ^ (~y)) % ((9 % y) % (y & y))) + (((-y) - (x * 1)) - ((7 | y) - (x & x)))) % 5

int DIM = 1024;
int SCALE = 1;
OpTree func1, func2, func3;
int[][] g1, g2, g3;
boolean ready;
boolean tileMode = false;

// NOTE: futzing with these values can have interesting reuslts, eg:
//random(-1, 1)));
//random(-4, 4)));
//random(-512, 512)));
//random(0, 128)));
//random(1, 4)));
//random(-8, 8)));
int CONST_MIN = -8;
int CONST_MAX = 8;

// Also, please feel free to tweak
// The probabilities in decider()

final String[] AVAILABLE_UNARY_OPS = {
   //"SinNode",
   //"CosNode",
   //"TanNode",
   "NegativeNode",
   "ComplementNode"
 }; 

final String[] AVAILABLE_BINARY_OPS = {
  "BitAndNode",
  "BitOrNode",
  "BitXorNode",
  //"MinusNode",
  "ModNode",
  //"MultNode",
  //"PlusNode",
  //"PowerNode",
  //"DivNode",
  //"LogNode",
  "MaxNode",
  "MinNode"
 };

void setup() {
  size(1024, 1024);
  noStroke();

  println("Controls:");
  println("    click mouse: create new functions");
  println("    s key: save image");
  println("    t key: toggle tile mode");
  println("    - key: zoom out (slow!)");
  println("    = key: zoom in");

  ready = false;
  refresh();
}

int[][] update_cells(OpTree func) {

  int[][] grid = new int[DIM][DIM];
  for (int y=0; y < DIM; y++) {
    for (int x=0; x < DIM; x++) {
      grid[y][x] = 0;
    }
  }

  // calculate initial values + min/max
  int min = Integer.MAX_VALUE;
  int max = Integer.MIN_VALUE;
  int temp;
  for (int y=0; y < DIM; y++) {
    if (y % 64 == 0) print(".");
    //if (!ready) return grid;
    for (int x=0; x < DIM; x++) {
      temp = func.eval(x, y);
      if (temp > max) max = temp;
      else if (temp < min) min = temp;
      grid[y][x] = temp;
    }
  }

  // rescale from 0 to 255 for this plane
  for (int y=0; y < DIM; y++) {
    for (int x=0; x < DIM; x++) {
      grid[y][x] = round(map(grid[y][x], min, max, 0, 255));
    }
  }
  return grid;
}

void draw() {

  background(0);

  for (int y=0; y < DIM; y++) {
    for (int x=0; x < DIM; x++) {
      fill(g1[y][x], g2[y][x], g3[y][x], 255);
      if (tileMode) rect(x*SCALE, y*SCALE, SCALE-1, SCALE-1);
      else rect(x*SCALE, y*SCALE, SCALE, SCALE);
    }
  }
  ready = true;
}

void mouseClicked() {
  //thread("refresh");
  refresh();
}

void refresh() {
  background(0);
  println("\n");
  // Color variations
  // TODO: add black/white
  /*
  if (random(1.0) > 0.5) {
    colorMode(HSB);
  } else {
    colorMode(RGB);
  }
  */

  func1 = new OpTree();
  func2 = new OpTree();
  func3 = new OpTree();

  // update
  g1 = update_cells(func1);
  g2 = update_cells(func2);
  g3 = update_cells(func3);

  // TODO: add mirror variations?!
}

void keyPressed() {
  if (key == 's') {
    saveFrame("line-######.png");
    println("saved line-" + frameCount + ".png");
  } else if (key == 't') {
    tileMode = !tileMode;
  } else if ((key == '=') && (DIM > 1) && ready) {
    ready = false;
    SCALE *= 2;
    DIM /= 2;
    println("SCALE: " + SCALE);
    println("DIM: " + DIM);
    // update
    g1 = update_cells(func1);
    g2 = update_cells(func2);
    g3 = update_cells(func3);
  } else if ((key == '-') && (SCALE > 1) && ready) {
    ready = false;
    SCALE /= 2;
    DIM *= 2;
    println("SCALE: " + SCALE);
    println("DIM: " + DIM);
    // update
    g1 = update_cells(func1);
    g2 = update_cells(func2);
    g3 = update_cells(func3);
  }
}
