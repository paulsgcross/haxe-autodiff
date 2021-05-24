package testing;

class Compiler {
    static function main() {
        trace(Test.funcMult(2.0, 2.0));
        trace(Test.funcMultDiff(2.0, 1.0, 2.0, 0.0));

        trace(Test.funcTrig(2.0, 2.0));
        trace(Test.funcTrigDiff(2.0, 1.0, 2.0, 0.0));
    }
}

@:build(haxe.ad.compiler.AutoDiff.buildForward())
class Test {
  
  @:diff public static function funcMult(x : Float, y : Float) : Float {
    var f = -(x*x);
    var g = x*y;
    var h = y*y;
    
    return f + g + h;
  }

  @:diff public static function funcTrig(x : Float, y : Float) : Float {
    var f = Math.abs(x);
    
    return f;
  }

  public static function test(x : Float) : Float {
    return x;
  }

}
