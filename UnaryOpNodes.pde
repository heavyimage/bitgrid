UnaryOpNode randomUnaryOp() {
  UnaryOpNode n;

  String subclass = AVAILABLE_UNARY_OPS[floor(random(AVAILABLE_UNARY_OPS.length))];
  if (subclass == "SinNode") n = new SinNode();
  else if (subclass == "CosNode") n = new CosNode();
  else if (subclass == "TanNode") n = new TanNode();
  else if (subclass == "NegativeNode") n = new NegativeNode();
  else if (subclass == "ComplementNode") n = new ComplementNode();
  else if (subclass == "FloorNode") n = new FloorNode();
  else throw new RuntimeException("unknown type");
  return n;
}

abstract class UnaryOpNode extends UnaryNode {

  Node[] children;
  String op;

  UnaryOpNode() {
    children = new Node[1];
  }

  void setChild(Node value) {
    this.children[0] = value;
  }

  String describe() {
    return this.op + "(" + this.children[0].describe() + ")";
  }

  // TODO: Move this to a shared interface(?) for use with BinaryOpNodes
  // TODO: Add identities like -(-(x)) == x
  boolean isConst(int depth) {
    boolean[] childrenConst = new boolean[this.children.length];
    String indent = String.join("", Collections.nCopies(depth, " "));
    for (int i=0; i<this.children.length; i++) {
      boolean well = this.children[i].isConst(depth+1);
      childrenConst[i] = well;
      //println(indent, this.children[i].describe(), "==>", well);
      if (well && (this.children[i] instanceof UnaryOpNode || this.children[i] instanceof BinaryOpNode)) {
        //print("fix:" + this.children[i]);
        float value = this.children[i].eval(0, 0, 0);
        this.children[i] = new ConstFloatNode(value);
        //println("==>" + this.children[i] + "(" + this.children[i].eval(0, 0) + ")");
      }
    }
    return areAllTrue(childrenConst);
  }
}

class SinNode extends UnaryOpNode {
  SinNode() {
    super();
    this.op = "sin";
  }
  float eval(int x, int y, int t) {
    return sin(radians(this.children[0].eval(x, y, t)));
  }
}

class CosNode extends UnaryOpNode {
  CosNode() {
    super();
    this.op = "cos";
  }
  float eval(int x, int y, int t) {
    return cos(radians(this.children[0].eval(x, y, t)));
  }
}

class TanNode extends UnaryOpNode {
  TanNode() {
    super();
    this.op = "tan";
  }
  float eval(int x, int y, int t) {
    return tan(radians(this.children[0].eval(x, y, t)));
  }
}

class NegativeNode extends UnaryOpNode {
  NegativeNode() {
    super();
    this.op = "-";
  }
  float eval(int x, int y, int t) {
    return -this.children[0].eval(x, y, t);
  }
}

class ComplementNode extends UnaryOpNode {
  ComplementNode() {
    super();
    this.op = "~";
  }
  float eval(int x, int y, int t) {
    return ~round(this.children[0].eval(x, y, t));
  }
}

class FloorNode extends UnaryOpNode {
  FloorNode() {
    super();
    this.op = "floor";
  }
  float eval(int x, int y, int t) {
    return floor(this.children[0].eval(x, y, t));
  }
}
