package testing;

class Compiler {
    static function main() {
        trace(Test.funcMult(2.0, 2.0));
        trace(Test.funcMultDiff(2.0, 1.0, 2.0, 0.0));
    }
}

@:build(haxe.ad.compiler.AutoDiff.buildForward())
class Test {
  
  @:diff public static function funcMult(x : Float, y : Float) : Float {
    var f = -x;
    var g = x*y;
    
    f = g*f;
    
    return 3.0*(f + g);
  }

  public static function test(x : Float) : Float {
    return x;
  }

}
