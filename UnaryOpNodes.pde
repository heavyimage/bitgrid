UnaryOpNode randomUnaryOp() {
  UnaryOpNode n;
  
  // TODO: sort this list / the functions below into bitwise and not!
  // TODO: do this dynamically via reflection
  String[] list = {"SinNode", "CosNode", "TanNode", "NegativeNode", "ComplementNode"};
  Random r = new Random();
  String subclass = list[r.nextInt(list.length)];
  if (subclass == "SinNode") n = new SinNode();
  else if (subclass == "CosNode") n = new CosNode();
  else if (subclass == "TanNode") n = new TanNode();
  else if (subclass == "NegativeNode") n = new NegativeNode();
  else if (subclass == "ComplementNode") n = new ComplementNode();
  else throw new RuntimeException("unknown type");
  return n;
}

abstract class UnaryOpNode implements UnaryNode {
  Node child;
  String op;

  UnaryOpNode() {
    this.child = null;
  }

  void setChild(Node value) {
    this.child = value;
  }

  abstract int eval(int x, int y);

  String describe(){
    return this.op + "(" + this.child.describe() + ")"; 
  }
}

class SinNode extends UnaryOpNode {
  SinNode() {
    super();
    this.op = "sin";
  }
  int eval(int x, int y) {
    return round(sin(radians(this.child.eval(x, y))));
  }
}

class CosNode extends UnaryOpNode {
  CosNode() {
    super();
    this.op = "cos";
  }
  int eval(int x, int y) {
    return round(cos(radians(this.child.eval(x, y))));
  }
}

class TanNode extends UnaryOpNode {
  TanNode() {
    super();
    this.op = "tan";
  }
  int eval(int x, int y) {
    return round(tan(radians(this.child.eval(x, y))));
  }
}

class NegativeNode extends UnaryOpNode {
  NegativeNode() {
    super();
    this.op = "-";
  }
  int eval(int x, int y) {
    return -this.child.eval(x, y);
  }
}

class ComplementNode extends UnaryOpNode {
  ComplementNode() {
    super();
    this.op = "~";
  }
  int eval(int x, int y) {
    return ~this.child.eval(x, y);
  }
}
