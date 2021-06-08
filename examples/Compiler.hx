package examples;

import haxe.ds.Vector;

@:build(haxe.ad.compiler.macros.AutoDiff.build())
class Compiler {
    public static function main() {
        var y = square(3.0);
        var dy = squareDiff(3.0, 1.0);
        trace(y, dy, dy == squareDiffByHand(3.0));

        var grad = new Vector(2);
        var z = quad(3.0, 2.0);
        
        quadDiff(3.0, 2.0, grad);
        trace(z, grad);

        quadDiffByHand(3.0, 2.0, grad);
        trace(z, grad);
    }

    @:forwardDiff private static function square(x : Float) : Float {
        return Math.pow(x, 2);
    }

    private static function squareDiffByHand(x : Float) : Float {
        return 2*x;
    }

    @:reverseDiff private static function quad(x : Float, y : Float) : Float {
        return x*x + x*y + Math.pow(y, 2);
    }

    private static function quadDiffByHand(x : Float, y : Float, gradient : Vector<Float>) : Void {
        gradient[0] = 2*x + y;
        gradient[1] = x + 2*y;
    }

}