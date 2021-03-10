import haxe.macro.Expr.ImportMode;

class Main {
  static function main() {

    trace(Test.func1(-2.0), Test.func1(0.0), Test.func1(2.0));
    trace(Test.func1_diff(-2.0, 1.0), Test.func1_diff(0, 1.0), Test.func1_diff(2.0, 1.0));
  }

}

@:build(macros.AD.buildForward())
class Test {
  
  public static function func1(x : Float) : Float {
    var z = Math.pow(x, 2);
    return z;
  }
  
}
