package testing.reverse;

import haxe.ad.duals.reverse.WengertList;

using haxe.ad.duals.reverse.Gradient;


class Variables {
  static function main() {
    test();
  }

  private static function test() {
    var list = new WengertList();

    var x = list.createVariable(2.0);
    var y = list.createVariable(0.5);
    var z = x*y + 3.0*x - 3.0*y;

    trace(z.value);
    
    var gz = z.calculateGrad();

    trace(gz.wrt(x));
    trace(gz.wrt(y));
  }
}