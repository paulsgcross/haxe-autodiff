package testing;

import haxe.ds.Vector;

class Compiler {
    static function main() {
      var out = new Vector<Float>(4);
      var dout = new Vector<Float>(4);
      Test.rotateDiff(Math.PI/4, 1.0, out, dout);
      trace(out);
      trace(dout);
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

  @:diff public static function rotate(angle : Float, out : Vector<Float>) : Void {
    out[0] = Math.cos(angle);
    out[1] = Math.sin(angle);
    out[2] = Math.sin(-angle);
    out[3] = Math.cos(angle);
  }

  public static function funcFor(x : Float, y : Float) : Float {
    var f = (x*y);

    return f;
  }

  public static function test(x : Float) : Float {
    return Math.exp(3.*x);
  }

}
