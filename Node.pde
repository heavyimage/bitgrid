import java.util.Random;

abstract class Node {
  abstract int eval(int x, int y);
  abstract String describe();
}

class ValueNode extends Node {
  Object value;

  ValueNode(String value) {
    this.value = (Object)value;
  }

  ValueNode(int value) {
    this.value = (Object)value;
  }

  void setValue(Object value) {
    this.value = value;
  }

  String describe() {
    return "" + this.value;
  }

  int eval(int x, int y) {
    if ( this.value instanceof Integer) {
      return (int)this.value;
    } else if (this.value == "x") {
      return x;
    } else if (this.value == "y") {
      return y;
    } else {
      throw new RuntimeException();
    }
  }
}

// TODO: Bitwise Complement (~)

Node decider() {

  Node n;
  if (random(1.0) > 0.45) {
    if (random(1.0) > 0.75) {
      n = new ValueNode(round(random(-512, 512)));
    } else {
      if (random(1.0) > 0.5) {
        n = new ValueNode("x");
      } else {
        n = new ValueNode("y");
      }
    }
  } else {
    n = randomOp();
  }
  return n;
}


class OpTree {

  OpNode root;

  OpTree() {
    // TODO: randomize this too?
    root = randomOp();

    ArrayList pipeline = new ArrayList();
    pipeline.add(root);
    OpNode cursor;
    Node left, right;
    while (pipeline.size() > 0) {
      cursor = (OpNode)pipeline.remove(0);
      //println(cursor, cursor.getClass());

      // Handle Left
      left = decider();
      //println(left, left.getClass());
      cursor.setLeft(left);
      if (left instanceof OpNode) pipeline.add(left);

      // Handle Right
      right = decider();
      //println(right, right.getClass());
      cursor.setRight(right);
      if (right instanceof OpNode) pipeline.add(right);
    }
    
    // TODO: try to get to a certain depth
    // TODO: optimization: collapse context free sections of the tree into single value nodes?
    // TODO: could also colapse constants...
    
    this.describe();
    
  }

  int eval(int x, int y) {
    try {
      return root.eval(x, y);
    }
    catch (ArithmeticException ae) {
      return 0;
    }
  }

  void describe() {
    print("f(x, y) = " + root.describe());
  }
}
