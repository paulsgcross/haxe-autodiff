package haxe.ad.duals.forward;

import haxe.ad.duals.forward.Components;

abstract DualNumber(Components) to Components from Components {

    public var v(get, never) : Float;
    public var d(get, never) : Float;

    public inline function new(v : Float, d : Float) {
        this = new Components(v, d);
    }

    @:op(-A)
    public inline function neg() : DualNumber {
        return new DualNumber(-v, -d);
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

    @:from public static inline function fromFloat(value : Float) : DualNumber {
        return new DualNumber(value, 0.0);
    }

    public inline function setToDual(dual : DualNumber) : Void {
        this.d = dual.d;
        this.v = dual.v;
    }

    private inline function get_v() : Float {
        return this.v;
    }

    private inline function get_d() : Float {
        return this.d;
    }

    public inline function toString() : String {
        return v + " + " + d + "e";
    }
}
