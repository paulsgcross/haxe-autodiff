package testing.reverse;

import haxe.ds.Vector;

class Compiler {
    static function main() {
      var grad = new Vector<Float>(1);
      Test.squareDiff(2.0, grad);

      trace(Test.square(2.0));
      trace(grad[0] == 4.0);

      var grad = new Vector<Float>(2);
      Test.quadDiff(2.0, 2.0, grad);
      trace(Test.quad(2.0, 2.0));
      trace(grad[0] == 6.0, grad[1] == 6.0);
      
      var grad = new Vector<Float>(2);
      Test.circleDiff(2.0, 2.0, grad);
      trace(Test.circle(2.0, 2.0));
      trace(grad[0] + '~=' +  2.0 / Math.sqrt(8.0));
      
      var grad = new Vector<Float>(3);
      Test.threedeeDiff(2.0, 2.0, 2.0, grad);
      trace(Test.threedee(2.0, 2.0, 2.0));
      trace(grad[0] == 4.0, grad[1] == 4.0, grad[2] == 4.0);
      
      var grad = new Vector<Float>(2);
      Test.trigDiff(2.0, 2.0, grad);
      trace(Test.trig(2.0, 2.0));
      trace(grad[0] == -Math.sin(2.0), grad[1] == -Math.cos(2.0));
      
    }
}

@:build(haxe.ad.compiler.macros.AutoDiff.build())
class Test {
  
  @:reverseDiff public static function square(x : Float) : Float {
    return x*x;
  }

  @:reverseDiff public static function quad(x : Float, y : Float) : Float {
    return x*x + x*y + y*y;
  }

  @:reverseDiff public static function circle(x : Float, y : Float) : Float {
    return Math.sqrt(x*x + y*y);
  }

  @:reverseDiff public static function threedee(x : Float, y : Float, z : Float) : Float {
    return x*y*z;
  }

  @:reverseDiff public static function trig(x : Float, y : Float) : Float {
    return Math.cos(x) - Math.sin(y);
  }
}
