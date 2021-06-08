package examples;

import haxe.ad.duals.reverse.VariableMath;
import haxe.ad.duals.forward.DualMath;
import haxe.ad.duals.forward.DualNumber;
import haxe.ad.duals.reverse.Gradient;
import haxe.ad.duals.reverse.WengertList;

class Overloading {
    public static function main() {
        forward(1.0, 0.0);
        forward(0.0, 1.0);
        reverse();
    }

    private static function forward(xseed : Float, yseed : Float) {
        var x = new DualNumber(3.0, xseed);
        var y = new DualNumber(3.0, yseed);

        var z = x*x + x*y + DualMath.cos(y*y);
        trace(z.v, z.d);
    }

    private static function reverse() {
        var list = new WengertList();

        var x = list.createVariable(3.0);
        var y = list.createVariable(3.0);
        
        var z = x*x + x*y + VariableMath.cos(y*y);
        var gz = Gradient.calculateGrad(z);
        var dx = gz.wrt(x);
        var dy = gz.wrt(x);

        trace(z.value, dx, dy);
    }
}