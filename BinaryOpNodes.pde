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

abstract class BinaryOpNode implements BinaryNode {
  Node left;
  Node right;
  String op;

  BinaryOpNode() {
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

  String describe() {
    return "(" + left.describe() + " " + this.op + " " + right.describe() + ")";
  }
}

class PlusNode extends BinaryOpNode {
  PlusNode() {
    super();
    this.op = "+";
  }
  int eval(int x, int y) {
    return this.left.eval(x, y) + this.right.eval(x, y);
  }
}

class MinusNode extends BinaryOpNode {
  MinusNode() {
    super();
    this.op = "-";
  }
  int eval(int x, int y) {
    return this.left.eval(x, y) - this.right.eval(x, y);
  }
}

class MultNode extends BinaryOpNode {
  MultNode() {
    super();
    this.op = "*";
  }
  int eval(int x, int y) {
    return this.left.eval(x, y) * this.right.eval(x, y);
  }
}

class DivNode extends BinaryOpNode {
  DivNode() {
    super();
    this.op = "/";
  }
  int eval(int x, int y) {
    return this.left.eval(x, y) / this.right.eval(x, y);
  }
}


class PowerNode extends BinaryOpNode {
  PowerNode() {
    super();
    this.op = "**";
  }
  int eval(int x, int y) {
    return round(pow(this.left.eval(x, y), this.right.eval(x, y)));
  }
}

class LogNode extends BinaryOpNode {
  LogNode() {
    super();
    this.op = "//";
  }
  int eval(int x, int y) {
    return round((float)Math.log((this.left.eval(x, y)) / Math.log(this.right.eval(x, y))));
  }
}


class ModNode extends BinaryOpNode {
  ModNode() {
    super();
    this.op = "%";
  }
  int eval(int x, int y) {
    return this.left.eval(x, y) % this.right.eval(x, y);
  }
}

class BitAndNode extends BinaryOpNode {
  BitAndNode() {
    super();
    this.op = "&";
  }
  int eval(int x, int y) {
    return this.left.eval(x, y) & this.right.eval(x, y);
  }
}

class BitOrNode extends BinaryOpNode {
  BitOrNode() {
    super();
    this.op = "|";
  }
  int eval(int x, int y) {
    return this.left.eval(x, y) | this.right.eval(x, y);
  }
}

class BitXorNode extends BinaryOpNode {
  BitXorNode() {
    super();
    this.op = "^";
  }
  int eval(int x, int y) {
    return this.left.eval(x, y) ^ this.right.eval(x, y);
  }
}

class MaxNode extends BinaryOpNode {
  MaxNode() {
    super();
  }
  int eval(int x, int y) {
    return max(this.left.eval(x, y), this.right.eval(x, y));
  }
  String describe() {
    return "max(" + left.describe() + ", " + right.describe() + ")";
  }
}

class MinNode extends BinaryOpNode {
  MinNode() {
    super();
  }
  String describe() {
    return "min(" + left.describe() + ", " + right.describe() + ")";
  }
  int eval(int x, int y) {
    return min(this.left.eval(x, y), this.right.eval(x, y));
  }
}
