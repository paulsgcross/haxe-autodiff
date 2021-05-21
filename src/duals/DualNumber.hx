package duals;

import haxe.ds.Vector;

abstract DualNumber(Vector<Float>) {

    public var v(get, never) : Float;
    public var d(get, never) : Float;

    public function new(v : Float, d : Float) {
        this = new Vector(2);
        this[0] = v;
        this[1] = d;
    }

    public inline function multiply(dual : DualNumber) : DualNumber {
        return new DualNumber(v * dual.v, (v * dual.v));
    }

    private function get_v() : Float {
        return this[0];
    }

    private function get_d() : Float {
        return this[1];
    }
}