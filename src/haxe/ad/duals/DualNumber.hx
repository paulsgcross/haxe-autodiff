package haxe.ad.duals;

import haxe.ds.Vector;

abstract DualNumber(Vector<Float>) {

    public var v(get, never) : Float;
    public var d(get, never) : Float;

    public inline function new(v : Float, d : Float) {
        this = VectorStack.get();
        this[0] = v;
        this[1] = d;
    }

    @:commutative
    @:op(A+B)
    public inline function addDual(dual : DualNumber) : DualNumber {
        return new DualNumber(v + dual.v, d + dual.d);
    }

    @:commutative
    @:op(A+B)
    public inline function addFloat(value : Float) : DualNumber {
        return new DualNumber(v + value, d);
    }

    @:op(A-B)
    public inline function subDual(dual : DualNumber) : DualNumber {
        return new DualNumber(v - dual.v, d - dual.d);
    }

    @:op(A-B)
    public static inline function subFloatFromDual(left : Float, right : DualNumber) : DualNumber {
        return new DualNumber(left - right.v, -right.d);
    }

    @:op(B-A)
    public static inline function subDualFromFloat(left : DualNumber, right : Float) : DualNumber {
        return new DualNumber(left.v - right, left.d);
    }

    @:commutative
    @:op(A*B)
    public inline function multiplyDual(dual : DualNumber) : DualNumber {
        return new DualNumber(v * dual.v, (v * dual.d) + (d * dual.v));
    }

    @:commutative
    @:op(A*B)
    public inline function multiplyFloat(value : Float) : DualNumber {
        return new DualNumber(v * value, (d * value));
    }

    @:op(A/B)
    public inline function divideDual(dual : DualNumber) : DualNumber {
        return new DualNumber(v / dual.v, ((d * dual.v) - (v * dual.d)) / (dual.v * dual.v));
    }

    @:op(A/B)
    public static inline function divideDualByFloat(left : DualNumber, right : Float) : DualNumber {
        return new DualNumber(left.v / right, (left.d * right));
    }

    @:op(B/A)
    public static inline function divideFloatByDual(left : Float, right : DualNumber) : DualNumber {
        return new DualNumber(left / right.v,  -(left * right.d) / (right.v * right.v));
    }

    public static inline function fromFloat(value : Float) : DualNumber {
        return new DualNumber(value, 0.0);
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
