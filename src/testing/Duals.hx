package testing;

import haxe.ad.duals.DualMath;
import haxe.ad.duals.DualNumber;

class Duals {
  static function main() {
    
    var v = Math.PI/4;
    var dual1 = new DualNumber(v, 1.0);
    
    quickAssert(DualMath.pow(dual1, 2).d ==  2*v);
    quickAssert(DualMath.sin(dual1).d == Math.cos(v));
    quickAssert(DualMath.cos(dual1).d == -Math.sin(v));
    quickAssert(DualMath.tan(dual1).d == 1 + (Math.tan(v)*Math.tan(v)));
    quickAssert(DualMath.exp(dual1).d == Math.exp(v));
  }

  private static function quickAssert(check : Bool) : Void {
    if(!check)
      trace('Assert failed.');
    else
      trace('Assert passed.');
  }
}
