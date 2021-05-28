package testing.forward;

import haxe.ds.Vector;

// TODO: Add reverse mode?

class Compiler {
    static function main() {
      trace(Test.funcMult(3.0));
      trace(Test.funcMultDiff(3.0, 1.0));

      trace(Test.funcFor(3.0));
      trace(Test.funcForDiff(3.0, 1.0));

      var out = new Vector(1);
      trace(Test.square(3.0));
      Test.squareDiff(3.0, out);
      trace(out);

      trace(Test.funcQuad(3.0, 3.0));
      trace(Test.funcQuadDiff(3.0, 1.0, 3.0, 0.0));

      var out = new Vector<Float>(4);
      var dout = new Vector<Float>(4);

      Test.rotateDiff(Math.PI/4, 1.0, out, dout);
      
      trace(out);
      trace(dout);
    }
}

@:build(haxe.ad.compiler.macros.AutoDiff.build())
class Test {
  
  @:forwardDiff public static function funcMult(x : Float) : Float {
    var f = Math.exp(-x*x);
    var g = Math.log(1 + x);
    
    return f + g;
  }

  @:forwardDiff public static function rotate(angle : Float, out : Vector<Float>) : Void {
    out[0] = Math.cos(angle);
    out[1] = Math.sin(angle);
    out[2] = Math.sin(-angle);
    out[3] = Math.cos(angle);
  }

  @:forwardDiff public static function funcFor(x : Float) : Float {
    var f = 0.0;
    for(i in 0...5) 
      f += x*i;

    return f;
  }

  @:reverseDiff public static function square(x : Float) : Float {
    return x*x;
  }

  @:forwardDiff public static function funcQuad(x : Float, y : Float) : Float {
    var f = x*x;
    var g = x*y;
    var h = y*y;
    
    return f + g + h;
  }

}
