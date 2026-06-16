abstract class Node {
  Node[] children;
  abstract float eval(int x, int y, int t);
  abstract String describe();
  abstract boolean isConst(int depth);
}

abstract class UnaryNode extends Node {
}
abstract class BinaryNode extends Node {
}

class XNode extends UnaryNode {
  String describe() {
    return "x";
  }
  float eval(int x, int y, int t) {
    return x;
  }
  
  boolean isConst(int depth){ return false;}
}

class YNode extends UnaryNode {
  String describe() {
    return "y";
  }
  float eval(int x, int y, int t) {
    return y;
  }
  
  boolean isConst(int depth){ return false;}
}

class TNode extends UnaryNode {
  String describe() {
    return "t";
  }
  float eval(int x, int y, int t) {
    return t;
  }
  
  boolean isConst(int depth){ return false;}
}

class ConstIntNode extends UnaryNode {
  int value;

  ConstIntNode(int value) {
    this.value = value;
  }

  String describe() {
    return "" + this.value;
  }

  float eval(int x, int y, int t) {
    return this.value;
  }
  boolean isConst(int depth){ return true;}
}

class ConstFloatNode extends UnaryNode {
  float value;

  ConstFloatNode(float value) {
    this.value = value;
  }

  String describe() {
    return "" + this.value;
  }

  float eval(int x, int y, int t) {
    return this.value;
  }
  boolean isConst(int depth){ return true;}
}


// HUGELY important -- the probabilities of various different nodes!
Node decider() {

  Node n;
  if (random(1.0) > 0.66) {
    if (random(1.0) > 0.5) {
      n = new ConstIntNode(round(random(CONST_MIN, CONST_MAX)));
    } else {
      float rand = random(1.0);
      if (rand > 0.66) {
        n = new XNode();
      } else if (rand > 0.33){
        n = new YNode();
      } else{
        n = new TNode();
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
      init();
      desc = describe();
    }
    //println(desc + " (length: " + desc.length() + "!)");
    // Simplify formula!
    root.isConst(0);
    String newdesc = describe();
    if (desc.length() > newdesc.length()) println(newdesc + " (length: " + newdesc.length() + "!)");
  }

  int eval(int x, int y, int t) {
    try {
      return round(root.eval(x, y, t));
    }
    catch (ArithmeticException ae) {
      return 0;
    }
  }

  String describe() {
    return "f(x, y, t) = " + root.describe();
  }
}
