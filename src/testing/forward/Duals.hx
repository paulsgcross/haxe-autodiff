package testing.forward;

import haxe.ad.duals.forward.DualNumber;
using haxe.ad.duals.forward.DualMath;

class Duals {
  static function main() {
    testDuals();
  }

  private static function testDuals() {
    var v = Math.PI/4;
    var dual1 = new DualNumber(v, 1.0);
    
    quickAssertEquals((0.0 - dual1).v, -dual1.v);

    quickAssertEquals((dual1 - dual1).d, 0.0);
    quickAssertEquals((dual1 + dual1).d, 2.0);
    quickAssertEquals((dual1*dual1).d, 2*v);
    quickAssertEquals((dual1/dual1).d, 0.0);

    quickAssertEquals(DualMath.pow(dual1, 2).d, 2*v);
    quickAssertEquals(DualMath.sin(dual1).d, Math.cos(v));
    quickAssertEquals(DualMath.cos(dual1).d, -Math.sin(v));
    quickAssertEquals(DualMath.tan(dual1).d, 1 + (Math.tan(v)*Math.tan(v)));
    quickAssertEquals(DualMath.exp(dual1).d, Math.exp(v));
    quickAssertEquals(DualMath.log(dual1).d, 1/v);
    quickAssertEquals(DualMath.abs(dual1).d, v/Math.abs(v));

    quickAssertEquals((DualMath.cos(dual1) * DualMath.sin(dual1)).d, Math.cos(2*v));
  }

  private static var index : Int = 0;
  private static function quickAssertEquals(left : Float, right : Float) : Void {
    var left = left > 1e-6?left:0.0;
    var right = right > 1e-6?right:0.0;

    var string = Std.string(left) + " == " + Std.string(right);

    if(left != right)
      trace(index + '.\t Assert failed: ' + string);
    else
      trace(index + '.\t Assert passed: ' + string);

    index++;
  }
}

private class SomeFunctions {
  public static function test1_dual(x : DualNumber, into : DualNumber) : Void {
    var f = x*DualMath.sin(x);
    
    into.setToDual(f);
  }
}