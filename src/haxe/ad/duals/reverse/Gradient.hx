package haxe.ad.duals.reverse;

import haxe.ds.Vector;

abstract Gradient(Vector<Float>) {
    public function new(length : Int) {
        this = new Vector(length);
    }

    public static function calculateGrad(dual : Variable) : Gradient {
        var len = dual.list.len();
        var out = new Gradient(len);

        out[dual.index] = 1.0;

        for(i in 0...len) {
            var j = len - (i + 1);
            var node = dual.list.get(j);
            var deriv = out[j];

            out[node.parents.leftIndex] += node.parents.leftValue * deriv;
            out[node.parents.rightIndex] += node.parents.rightValue * deriv;
        }

        return out;
    }

    @:op([])
    public inline function set(index : Int, value : Float) : Void {
        this.set(index, value);
    }

    @:op([])
    public inline function get(index : Int) : Float {
        return this.get(index);
    }

    public inline function wrt(variable : Variable) : Float {
        return this[variable.index];
    }
}