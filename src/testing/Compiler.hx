package testing;

class Compiler {
    static function main() {
        Test.funcMult(3.0, 3.0);
        Test.funcMultDiff(3.0, 1.0, 3.0, 0.0);
    }
}

@:build(haxe.ad.compiler.AutoDiff.buildForward())
class Test {
  
  @:diff public static function funcMult(x : Float, y : Float) : Float {
    return x*x;
  }

  public static function test(x : Float) : Float {
    return x;
  }

}
