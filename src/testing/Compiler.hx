package testing;

import haxe.ad.compiler.Parameter;

class Compiler {
    static function main() {
        trace(Test.funcFor(2.0, 2.0));
        trace(Test.funcForDiff(2.0, 1.0, 2.0, 0.0));
    }
}

@:build(haxe.ad.compiler.macros.AutoDiff.buildForward())
class Test {
  
  public static function funcMult(x : Float, y : Float) : Float {
    var f = -(x*x);
    var g = x*y;
    var h = y*y;
    
    return f + g + h;
  }

  public static function funcTrig(x : Float, y : Float) : Float {
    var f = Math.pow(Math.sin(x), 2);
    var g = Math.pow(Math.cos(x), 2);

    return f + g;
  }

  @:diff public static function funcFor(x : Float, y : Float) : Float {
    var N : Parameter = 10.0;
    var f = N + (x*y);

    return f;
  }

  public static function test(x : Float) : Float {
    return Math.exp(3.*x);
  }

}
