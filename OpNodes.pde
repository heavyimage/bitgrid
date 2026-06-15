OpNode randomOp() {
  OpNode n;
  
  // TODO: sort this list / the functions below into bitwise and not!
  // TODO: add back div/log?
  String[] list = {"BitAndNode", "BitOrNode", "BitXorNode", "MinusNode", "ModNode", "MultNode", "PlusNode", "PowerNode"};// "DivNode", , "LogNode"};
  Random r = new Random();
  String subclass = list[r.nextInt(list.length)];
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
  else throw new RuntimeException("unknown type");
  return n;
}

abstract class OpNode extends Node {
  Node left;
  Node right;
  String op;

  OpNode() {
    this.left = null;
    this.right = null;
  }

  void setLeft(Node value) {
    this.left = value;
  }

  void setRight(Node value) {
    this.right = value;
  }

  abstract int eval(int x, int y);

  String describe(){
    return "(" + left.describe() + " " + this.op + " " + right.describe() + ")"; 
  }
}

class PlusNode extends OpNode {
  PlusNode() {
    super();
    this.op = "+";
  }
  int eval(int x, int y) {
    return this.left.eval(x, y) + this.right.eval(x, y);
  }
}

class MinusNode extends OpNode {
  MinusNode() {
    super();
    this.op = "-";
  }
  int eval(int x, int y) {
    return this.left.eval(x, y) - this.right.eval(x, y);
  }
}

class MultNode extends OpNode {
  MultNode() {
    super();
    this.op = "*";
  }
  int eval(int x, int y) {
    return this.left.eval(x, y) * this.right.eval(x, y);
  }
}

class DivNode extends OpNode {
  DivNode() {
    super();
    this.op = "/";
  }
  int eval(int x, int y) {
    return this.left.eval(x, y) / this.right.eval(x, y);
  }
}


class PowerNode extends OpNode {
  PowerNode() {
    super();
    this.op = "**";
  }
  int eval(int x, int y) {
    return round(pow(this.left.eval(x, y), this.right.eval(x, y)));
  }
}

class LogNode extends OpNode {
  LogNode() {
    super();
    this.op = "//";
  }
  int eval(int x, int y) {
    return round((float)Math.log((this.left.eval(x, y)) / Math.log(this.right.eval(x, y))));
  }
}


class ModNode extends OpNode {
  ModNode() {
    super();
    this.op = "%";
  }
  int eval(int x, int y) {
    return this.left.eval(x, y) % this.right.eval(x, y);
  }
}

class BitAndNode extends OpNode {
  BitAndNode() {
    super();
    this.op = "&";
  }
  int eval(int x, int y) {
    return this.left.eval(x, y) & this.right.eval(x, y);
  }
}

class BitOrNode extends OpNode {
  BitOrNode() {
    super();
    this.op = "|";
  }
  int eval(int x, int y) {
    return this.left.eval(x, y) | this.right.eval(x, y);
  }
}

class BitXorNode extends OpNode {
  BitXorNode() {
    super();
    this.op = "^";
  }
  int eval(int x, int y) {
    return this.left.eval(x, y) ^ this.right.eval(x, y);
  }
}
