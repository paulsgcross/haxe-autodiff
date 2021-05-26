package haxe.ad.duals.reverse;

class VariableMath {
    
    public static inline function sin(variable : Variable) : Variable {
        var z = new Variable(Math.sin(variable.value), variable.list);
        z.parents.set(variable.index, variable.index, Math.cos(variable.value), 0.0);
        return z;
    }

    public static inline function cos(variable : Variable) : Variable {
        var z = new Variable(Math.cos(variable.value), variable.list);
        z.parents.set(variable.index, variable.index, -Math.sin(variable.value), 0.0);
        return z;
    }

    public static inline function tan(variable : Variable) : Variable {
        var z = new Variable(Math.tan(variable.value), variable.list);
        z.parents.set(variable.index, variable.index, 1 + Math.pow(Math.tan(variable.value), 2.0), 0.0);
        return z;
    }

    public static inline function pow(variable : Variable, exp : Int) : Variable {
        var z = new Variable(Math.pow(variable.value, exp), variable.list);
        z.parents.set(variable.index, variable.index, exp*Math.pow(variable.value, exp - 1.0), 0.0);
        return z;
    }

    public static inline function sqrt(variable : Variable) : Variable {
        var z = new Variable(Math.sqrt(variable.value), variable.list);
        z.parents.set(variable.index, variable.index, 0.5*Math.pow(variable.value, -0.5), 0.0);
        return z;
    }

    public static inline function exp(variable : Variable) : Variable {
        var z = new Variable(Math.exp(variable.value), variable.list);
        z.parents.set(variable.index, variable.index, Math.exp(variable.value), 0.0);
        return z;
    }

    public static inline function log(variable : Variable) : Variable {
        var z = new Variable(Math.log(variable.value), variable.list);
        z.parents.set(variable.index, variable.index, 1 / variable.value, 0.0);
        return z;
    }

    public static inline function abs(variable : Variable) : Variable {
        var z = new Variable(Math.abs(variable.value), variable.list);
        z.parents.set(variable.index, variable.index, variable.value / Math.abs(variable.value), 0.0);
        return z;
    }
}