import java.util.Collections;

BinaryOpNode randomBinaryOp() {
  BinaryOpNode n;

  String subclass = AVAILABLE_BINARY_OPS[floor(random(AVAILABLE_BINARY_OPS.length))];
  if (subclass == "BitAndNode") n = new BitAndNode();
  else if (subclass == "BitOrNode") n = new BitOrNode();
  else if (subclass == "BitXorNode") n = new BitOrNode();
  else if (subclass == "MinusNode") n = new MinusNode();
  else if (subclass == "ModNode") n = new ModNode();
  else if (subclass == "MultNode") n = new MultNode();
  else if (subclass == "DivNode") n = new DivNode();
  else if (subclass == "PlusNode") n = new PlusNode();
  else if (subclass == "PowerNode") n = new PowerNode();
  else if (subclass == "LogNode") n = new LogNode();
  else if (subclass == "MaxNode") n = new MaxNode();
  else if (subclass == "MinNode") n = new MinNode();
  else throw new RuntimeException("unknown type");
  return n;
}

abstract class BinaryOpNode extends BinaryNode {

  Node[] children;
  String op;

  BinaryOpNode() {
    children = new Node[2];
  }

  void setLeft(Node value) {
    this.children[0] = value;
  }

  void setRight(Node value) {
    this.children[1] = value;
  }

  String describe() {
    return "(" + children[0].describe() + " " + this.op + " " + children[1].describe() + ")";
  }
  
  // TODO: Move this to a shared interface(?) for use with UnaryOpNodes
  // TODO: Add identities like y * 0 = 0
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
        this.children[i] = new ConstIntNode(round(value));
        //println("==>" + this.children[i] + "(" + this.children[i].eval(0, 0) + ")");
      }
    }
    return areAllTrue(childrenConst);
  }
}

class PlusNode extends BinaryOpNode {
  PlusNode() {
    super();
    this.op = "+";
  }
  float eval(int x, int y, int t) {
    return this.children[0].eval(x, y, t) + this.children[1].eval(x, y, t);
  }
}

class MinusNode extends BinaryOpNode {
  MinusNode() {
    super();
    this.op = "-";
  }
  float eval(int x, int y, int t) {
    return this.children[0].eval(x, y, t) - this.children[1].eval(x, y, t);
  }
}

class MultNode extends BinaryOpNode {
  MultNode() {
    super();
    this.op = "*";
  }
  float eval(int x, int y, int t) {
    return this.children[0].eval(x, y, t) * this.children[1].eval(x, y, t);
  }
}

class DivNode extends BinaryOpNode {
  DivNode() {
    super();
    this.op = "/";
  }
  float eval(int x, int y, int t) {
    return this.children[0].eval(x, y, t) / this.children[1].eval(x, y, t);
  }
}


class PowerNode extends BinaryOpNode {
  PowerNode() {
    super();
    this.op = "**";
  }
  float eval(int x, int y, int t) {
    return pow(this.children[0].eval(x, y, t), this.children[1].eval(x, y, t));
  }
}

class LogNode extends BinaryOpNode {
  LogNode() {
    super();
    this.op = "//";
  }
  float eval(int x, int y, int t) {
    return (float)Math.log((this.children[0].eval(x, y, t)) / Math.log(this.children[1].eval(x, y, t)));
  }
}


class ModNode extends BinaryOpNode {
  ModNode() {
    super();
    this.op = "%";
  }
  float eval(int x, int y, int t) {
    return this.children[0].eval(x, y, t) % this.children[1].eval(x, y, t);
  }
}

class BitAndNode extends BinaryOpNode {
  BitAndNode() {
    super();
    this.op = "&";
  }
  float eval(int x, int y, int t) {
    return round(this.children[0].eval(x, y, t)) & round(this.children[1].eval(x, y, t));
  }
}

class BitOrNode extends BinaryOpNode {
  BitOrNode() {
    super();
    this.op = "|";
  }
  float eval(int x, int y, int t) {
    return round(this.children[0].eval(x, y, t)) | round(this.children[1].eval(x, y, t));
  }
}

class BitXorNode extends BinaryOpNode {
  BitXorNode() {
    super();
    this.op = "^";
  }
  float eval(int x, int y, int t) {
    return round(this.children[0].eval(x, y, t)) ^ round(this.children[1].eval(x, y, t));
  }
}

class MaxNode extends BinaryOpNode {
  MaxNode() {
    super();
  }
  float eval(int x, int y, int t) {
    return max(this.children[0].eval(x, y, t ), this.children[1].eval(x, y, t));
  }
  String describe() {
    return "max(" + children[0].describe() + ", " + children[1].describe() + ")";
  }
}

class MinNode extends BinaryOpNode {
  MinNode() {
    super();
  }
  String describe() {
    return "min(" + children[0].describe() + ", " + children[1].describe() + ")";
  }
  float eval(int x, int y, int t) {
    return min(this.children[0].eval(x, y,t ), this.children[1].eval(x, y, t));
  }
}
