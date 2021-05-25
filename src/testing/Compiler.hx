package testing;

class Compiler {
    static function main() {
        trace(Test.funcMult(2.0, 2.0));
        trace(Test.funcMultDiff(2.0, 1.0, 2.0, 0.0));

        trace(Test.funcTrig(2.0, 2.0));
        trace(Test.funcTrigDiff(2.0, 1.0, 2.0, 0.0));

        trace(Test.funcFor(2.0, 2.0));
        trace(Test.funcForDiff(2.0, 1.0, 2.0, 0.0));
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
    var f = Math.pow(Math.sin(x), 2);
    var g = Math.pow(Math.cos(x), 2);

    return f + g;
  }

  @:diff public static function funcFor(x : Float, y : Float) : Float {
    var f = 0.0;
    for(i in 0...100)
        f += i*0.4;

    return f;
  }

  @:diff public static function test(x : Float) : Float {
    return Math.exp(3.*x);
  }

}
