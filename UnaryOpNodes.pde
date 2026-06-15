UnaryOpNode randomUnaryOp() {
  UnaryOpNode n;

  String subclass = AVAILABLE_UNARY_OPS[floor(random(AVAILABLE_UNARY_OPS.length))];
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

  abstract float eval(int x, int y);

  String describe(){
    return this.op + "(" + this.child.describe() + ")"; 
  }
}

class SinNode extends UnaryOpNode {
  SinNode() {
    super();
    this.op = "sin";
  }
  float eval(int x, int y) {
    return sin(radians(this.child.eval(x, y)));
  }
}

class CosNode extends UnaryOpNode {
  CosNode() {
    super();
    this.op = "cos";
  }
  float eval(int x, int y) {
    return cos(radians(this.child.eval(x, y)));
  }
}

class TanNode extends UnaryOpNode {
  TanNode() {
    super();
    this.op = "tan";
  }
  float eval(int x, int y) {
    return tan(radians(this.child.eval(x, y)));
  }
}

class NegativeNode extends UnaryOpNode {
  NegativeNode() {
    super();
    this.op = "-";
  }
  float eval(int x, int y) {
    return -this.child.eval(x, y);
  }
}

class ComplementNode extends UnaryOpNode {
  ComplementNode() {
    super();
    this.op = "~";
  }
  float eval(int x, int y) {
    return ~round(this.child.eval(x, y));
  }
}
