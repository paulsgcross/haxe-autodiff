package testing.reverse;

import haxe.ad.duals.reverse.VariableMath;
import haxe.ad.duals.reverse.Gradient;
import haxe.ad.duals.reverse.Variable;
import haxe.ad.duals.reverse.WengertList;
import haxe.ds.Vector;
import haxe.ad.duals.*;

using haxe.ad.duals.reverse.Gradient;

// TODO: Optimise this implementation.

class Variables {
  static function main() {
    test();
  }

  private static function test() {
    var list = new WengertList();
    var x = list.createVariable(2.0);
    var y = list.createVariable(0.5);
    var z = 3.0 - (x / y);
    var gz = z.calculateGrad();

    trace(gz.wrt(x));
  }
}