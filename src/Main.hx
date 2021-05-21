
import haxe.macro.Expr;
import haxe.macro.Context;

class Main {
  static function main() {

    var out1 = Test.funcMult(Math.PI/4);
    var out2 = Test.funcMult_diff(Math.PI/4, 1.0);
    trace(out1);
    trace(out2);

    
  }

}

@:build(macros.AD.buildForward())
class Test {
  
  @:diff public static function funcMult(x : Float) : Float {
    return Math.cos(3*x);
  }

  public static function test(x : Float) : Float {
    return x;
  }

}
