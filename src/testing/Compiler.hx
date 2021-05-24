package testing;

class Compiler {
    static function main() {
        trace(Test.funcMult(3.0, 3.0));
        trace(Test.funcMultDiff(3.0, 1.0, 3.0, 0.0));
    }
}

@:build(haxe.ad.compiler.AutoDiff.buildForward())
class Test {
  
  @:diff public static function funcMult(x : Float, y : Float) : Float {
    var f = x*y;
    var g = 3.0*f;
    return f * g;
  }

  public static function test(x : Float) : Float {
    return x;
  }

}
