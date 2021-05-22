package testing;

import haxe.ad.duals.DualMath;
import haxe.ad.duals.DualNumber;

class Duals {
  static function main() {
    testMacros();
  }

  private static function testMacros() {
    var v = 4.0;
    var dual1 = new DualNumber(v, 1.0);
    trace(DualNumber.fromFloat(4.0) / dual1);
  }

  private static function testDuals() {
    var v = Math.PI/4;
    var dual1 = new DualNumber(v, 1.0);
    
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
    var string = Std.string(left) + " == " + Std.string(right);

    if(left != right)
      trace(index + '.\t Assert failed: ' + string);
    else
      trace(index + '.\t Assert passed: ' + string);

    index++;
  }
}

//@:build(haxe.ad.duals.macros.Converter.build())
private class SomeFunctions {
  public static function test1(x : Float) : Float {
    var f = 3.0*x*x;
    var g = 2.0*x;
    var c = Math.cos(Math.cos(2.0));

    return f + g + c;
  }

  public static function test1_dual(x : DualNumber) : DualNumber {
    var f = 3.0*x*x;
    var g = 2.0*x;
    var c = Math.cos(Math.cos(2.0));

    return f + g + c;
  }
  //public static function test2(x : Float, out : Array<Float>) : Void {
  //  out[0] = 3*x*x + 2*x + 2;
  //}
}