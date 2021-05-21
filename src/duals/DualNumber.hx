package duals;

import haxe.ds.Vector;

abstract DualNumber(Vector<Float>) {

    public var v(get, never) : Float;
    public var d(get, never) : Float;

    public inline function new(v : Float, d : Float) {
        this = new Vector(2);
        this[0] = v;
        this[1] = d;
    }

    @:op(A*B)
    public inline function multiply(dual : DualNumber) : DualNumber {
        return new DualNumber(v * dual.v, (v * dual.d) + (d * dual.v));
    }

    @:op(A/B)
    public inline function divide(dual : DualNumber) : DualNumber {
        return new DualNumber(v / dual.v, ((d * dual.v) - (v * dual.d)) / (dual.v * dual.v));
    }

    @:op(A-B)
    public inline function sub(dual : DualNumber) : DualNumber {
        return new DualNumber(v - dual.v, d - dual.d);
    }

    @:op(A+B)
    public inline function add(dual : DualNumber) : DualNumber {
        return new DualNumber(v + dual.v, d + dual.d);
    }

    private inline function get_v() : Float {
        return this[0];
    }

    private inline function get_d() : Float {
        return this[1];
    }

    public inline function toString() : String {
        return v + " + " + d + "e";
    }
}