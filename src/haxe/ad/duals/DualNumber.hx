package haxe.ad.duals;

abstract DualNumber(Components) {

    public var v(get, never) : Float;
    public var d(get, never) : Float;

    public inline function new(v : Float, d : Float) {
        this = {v: v, d: d};
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
    public inline function subFloat(value : Float) : DualNumber {
        return new DualNumber(v - value, d);
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
    public inline function divideDualByDual(dual : DualNumber) : DualNumber {
        return new DualNumber(v / dual.v, ((d * dual.v) - (v * dual.d)) / (dual.v * dual.v));
    }

    @:op(A/B)
    public inline function divideDualByFloat(value : Float) : DualNumber {
        return new DualNumber(v / value, (d * value));
    }

    public static inline function fromFloat(value : Float) : DualNumber {
        return new DualNumber(value, 0.0);
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

private typedef Components = {
    var v : Float;
    var d : Float;
}