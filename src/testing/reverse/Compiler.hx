package testing.reverse;

import haxe.ds.Vector;

class Compiler {
    static function main() {
      var grad = new Vector<Float>(2);
      trace(Test.square(2.0, 2.0));
      Test.squareDiff(2.0, 2.0, grad);
      trace(grad);
    }
}

@:build(haxe.ad.compiler.macros.AutoDiff.build())
class Test {
  
  @:reverseDiff public static function square(x : Float, y : Float) : Float {
    return x*Math.sqrt(x);
  }

}
