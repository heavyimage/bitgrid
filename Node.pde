interface Node {
  abstract float eval(int x, int y);
  abstract String describe();
}

interface UnaryNode extends Node {
}
interface BinaryNode extends Node {
}
interface OpNode extends Node {
}

class XNode implements UnaryNode {
  String describe() {
    return "x";
  }
  float eval(int x, int y) {
    return x;
  }
}

class YNode implements UnaryNode {
  String describe() {
    return "y";
  }
  float eval(int x, int y) {
    return y;
  }
}

class ConstNode implements UnaryNode {
  int value;

  ConstNode(int value) {
    this.value = value;
  }

  String describe() {
    return "" + this.value;
  }

  float eval(int x, int y) {
    return this.value;
  }
}

// HUGELY important -- the probabilities of various different nodes!
Node decider() {

  Node n;
  if (random(1.0) > 0.66) {
    if (random(1.0) > 0.5) {
      n = new ConstNode(round(random(CONST_MIN, CONST_MAX)));
    } else {
      if (random(1.0) > 0.5) {
        n = new XNode();
      } else {
        n = new YNode();
      }
    }
  } else {
    if (random(1.0) > 0.5) {
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
    while ((desc.length() < FUNC_MIN_LEN) || (desc.length() > FUNC_MAX_LEN)) {
      //print("x");
      init();
      desc = describe();
    }
    println(desc + " (length: " + desc.length() + "!)");
  }

  int eval(int x, int y) {
    try {
      return round(root.eval(x, y));
    }
    catch (ArithmeticException ae) {
      return 0;
    }
  }

  String describe() {
    return "f(x, y) = " + root.describe();
  }
}
