import haxe.macro.Expr.ImportMode;

class Main {
  static function main() {

    trace(Test.func1(0.0, 0.0));
    trace(Test.func1_diff(0, 1.0, 0, 0.0) + Test.func1_diff(0, 0.0, 0, 1.0));
    while(true) {

    }
  }

}

@:build(macros.AD.buildForward())
class Test {
  
  public static function func1(x1 : Float, x2 : Float) : Float {
    var z = 0.0;
    for(i in 0...1000) {
      z += Math.sin(x1*i);
    }
    return z;
  }
  
}
