package testing.reverse;

import haxe.ds.Vector;

// TODO: Add reverse mode?

class Compiler {
    static function main() {
      var grad = new Vector<Float>(2);
      trace(Test.square(2.0, 2.0));
      Test.squareDiff(2.0, 2.0, grad);
      trace(grad);
    }
}

@:build(haxe.ad.compiler.macros.AutoDiff.buildReverse())
class Test {
  
  @:diff public static function square(x : Float, y : Float) : Float {
    return Math.sqrt(x);
  }

}
