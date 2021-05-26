package testing.reverse;

import haxe.ds.Vector;

// TODO: Add reverse mode?

class Compiler {
    static function main() {
      trace(Test.square(3.0, 2.0));
      trace(Test.squareDiff(3.0, 2.0));
    }
}

@:build(haxe.ad.compiler.macros.AutoDiff.buildReverse())
class Test {
  
  @:diff public static function square(x : Float, y : Float) : Float {
    return x*y;
  }

}
