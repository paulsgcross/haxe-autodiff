package duals;

class DualMath {
    public static inline function sin(dual : DualNumber) : DualNumber {
        return new DualNumber(Math.sin(dual.v), dual.d * Math.cos(dual.v));
    }

    public static inline function cos(dual : DualNumber) : DualNumber {
        return new DualNumber(Math.cos(dual.v), -dual.d * Math.sin(dual.v));
    }

    public static inline function tan(dual : DualNumber) : DualNumber {
        return new DualNumber(Math.tan(dual.v), dual.d * (1 + (Math.tan(dual.v)*Math.tan(dual.v))));
    }

    public static inline function pow(dual : DualNumber, exp : Float) : DualNumber {
        return new DualNumber(Math.pow(dual.v, exp), dual.d * exp * Math.pow(dual.v, exp - 1.0));
    }

    public static inline function exp(dual : DualNumber) : DualNumber {
        return new DualNumber(Math.exp(dual.v), dual.d * Math.exp(dual.v));
    }

    public static inline function abs(dual : DualNumber) : DualNumber {
        return new DualNumber(Math.abs(dual.v), dual.d * (dual.v / Math.abs(dual.v)));
    }

    public static inline function log(dual : DualNumber) : DualNumber {
        return new DualNumber(Math.log(dual.v), dual.d * (1 / dual.v));
    }

    public static inline function sqrt(dual : DualNumber) : DualNumber {
        return new DualNumber(Math.sqrt(dual.v), dual.d * (0.5 * Math.pow(dual.v, -0.5)));
    }
}