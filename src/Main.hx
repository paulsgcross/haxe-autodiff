
import haxe.macro.Expr;
import haxe.macro.Context;

class Main {
  static function main() {

    var out = Test.funcMult(3.0);
    trace(out);

    //var out = Test.funcMult_diff(3.0, 1.0);
    //trace(out);
  }

  public static macro function diff(expr : Expr) : Expr {
    trace(expr);
    return expr;
  }

}

//@:build(macros.AD.buildForward())
class Test {
  /*
  public static function func1(x : Float) : Float {
    if(x > 0.0) {
      return Math.pow(x, 3);
    } else {
      return Math.pow(x, 2);
    }
  }
*/
  public static function funcMult(x : Float) : Float {
    var z = 0.0;
    for(i in 0...10) {
      z += Math.cos(Math.pow(x, i));
    }
    return z;
  }
}
