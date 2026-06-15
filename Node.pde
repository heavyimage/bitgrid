interface Node {
  abstract int eval(int x, int y);
  abstract String describe();
}

interface UnaryNode extends Node {}
interface BinaryNode extends Node {}
interface OpNode extends Node {}

class VarNode implements UnaryNode {
  String value;

  VarNode(String value) {
    this.value = value;
  }

  void setValue(String value) {
    this.value = value;
  }

  String describe() {
    return "" + this.value;
  }
  int eval(int x, int y) {
    if (this.value == "x") {
      return x;
    } else if (this.value == "y") {
      return y;
    } else {
      throw new RuntimeException();
    }
  }
}

class ConstNode implements UnaryNode {
  int value;

  ConstNode(int value) {
    this.value = value;
  }

  void setValue(int value) {
    this.value = value;
  }

  String describe() {
    return "" + this.value;
  }

  int eval(int x, int y) {
    return this.value;
  }
}

Node decider() {

  Node n;
  if (random(1.0) > 0.45) {
    if (random(1.0) > 0.75) {
      // NOTE: futzing with these values can have interesting reuslts!
      //n = new ValueNode(round(random(-1, 1)));
      //n = new ValueNode(round(random(-4, 4)));
      //n = new ValueNode(round(random(-512, 512)));
      //n = new ValueNode(round(random(0, 128)));
      //n = new ValueNode(round(random(1, 4)));
      //n = new ConstNode(round(random(-8, 8)));
      n = new ConstNode(round(random(1, 16)));
    } else {
      if (random(1.0) > 0.5) {
        n = new VarNode("x");
      } else {
        n = new VarNode("y");
      }
    }
  } else {
    if (random(1.0) > 0.25) {
      n = randomBinaryOp();
    } else {
      n = randomUnaryOp();
    }
  }
  return n;
}


class OpTree {

  Node root;

  void init() {
    // TODO: randomize this too?
    root = randomBinaryOp();

    ArrayList pipeline = new ArrayList();
    pipeline.add(root);
    Node cursor, left, right, child;
    while (pipeline.size() > 0) {
      cursor = (Node)pipeline.remove(0);
      //println(cursor, cursor.getClass());

      if (cursor instanceof BinaryOpNode) {
        BinaryOpNode bon = (BinaryOpNode)cursor;
        // Handle Left
        left = decider();
        //println(left, left.getClass());
        bon.setLeft(left);
        pipeline.add(left);

        // Handle Right
        right = decider();
        //println(right, right.getClass());
        bon.setRight(right);
        pipeline.add(right);
      } else if (cursor instanceof UnaryOpNode) {
        UnaryOpNode uon = (UnaryOpNode)cursor;
        // Handle Left
        child = decider();
        //println(left, left.getClass());
        uon.setChild(child);
        pipeline.add(child);
      }
    }

    // TODO: try to get to a certain depth
    // TODO: optimization: collapse context free sections of the tree into single value nodes?
    // TODO: could also colapse constants...
  }

  OpTree() {
    init();

    String desc = describe();

    // approximate complexity in the hackiest way possible!
    while ((desc.length() < 32) || (desc.length() > 128)) {
      print("x");
      init();
      desc = describe();
    }
    println("\n" + desc + " (length: " + desc.length() + "!)");
  }

  int eval(int x, int y) {
    try {
      return root.eval(x, y);
    }
    catch (ArithmeticException ae) {
      return 0;
    }
  }

  String describe() {
    return "f(x, y) = " + root.describe();
  }
}
