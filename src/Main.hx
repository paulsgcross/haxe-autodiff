
import duals.DualMath;
import duals.DualNumber;

class Main {
  static function main() {
    
    var v = Math.PI/4;
    var dual1 = new DualNumber(v, 1.0);
    
    quickAssert(DualMath.pow(dual1, 2).d ==  3*v);
    quickAssert(DualMath.sin(dual1).d == Math.cos(v));
    quickAssert(DualMath.cos(dual1).d == -Math.sin(v));
    quickAssert(DualMath.tan(dual1).d == 1 + (Math.tan(v)*Math.tan(v)));
  }

  private static function quickAssert(check : Bool) : Void {
    if(!check)
      trace('Assert failed.');
    else
      trace('Assert passed.');
  }
}

@:build(macros.AD.buildForward())
class Test {
  
  @:diff public static function funcMult(x : Float) : Float {
    return Math.cos(3*x);
  }

  public static function test(x : Float) : Float {
    return x;
  }

}
