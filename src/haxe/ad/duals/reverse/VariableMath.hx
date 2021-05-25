package haxe.ad.duals.reverse;

class VariableMath {
    
    public static inline function sin(variable : Variable) : Variable {
        var node = new Node(variable.index, variable.index, Math.cos(variable.v), 0.0);
        var z = new Variable(Math.sin(variable.v), variable.list.add(node), variable.list);
        return z;
    }

    public static inline function cos(variable : Variable) : Variable {
        var node = new Node(variable.index, variable.index, -Math.sin(variable.v), 0.0);
        var z = new Variable(Math.cos(variable.v), variable.list.add(node), variable.list);
        return z;
    }

    public static inline function tan(variable : Variable) : Variable {
        var node = new Node(variable.index, variable.index, 1 + Math.pow(Math.tan(variable.v), 2.0), 0.0);
        var z = new Variable(Math.tan(variable.v), variable.list.add(node), variable.list);
        return z;
    }

    public static inline function pow(variable : Variable, exp : Int) : Variable {
        var node = new Node(variable.index, variable.index, exp*Math.pow(variable.v, exp - 1.0), 0.0);
        var z = new Variable(Math.pow(variable.v, exp), variable.list.add(node), variable.list);
        return z;
    }

    public static inline function sqrt(variable : Variable) : Variable {
        var node = new Node(variable.index, variable.index, 0.5*Math.pow(variable.v, -0.5), 0.0);
        var z = new Variable(Math.sqrt(variable.v), variable.list.add(node), variable.list);
        return z;
    }

    public static inline function exp(variable : Variable) : Variable {
        var node = new Node(variable.index, variable.index, Math.exp(variable.v), 0.0);
        var z = new Variable(Math.exp(variable.v), variable.list.add(node), variable.list);
        return z;
    }

    public static inline function log(variable : Variable) : Variable {
        var node = new Node(variable.index, variable.index, 1 / variable.v, 0.0);
        var z = new Variable(Math.log(variable.v), variable.list.add(node), variable.list);
        return z;
    }

    public static inline function abs(variable : Variable) : Variable {
        var node = new Node(variable.index, variable.index, variable.v / Math.abs(variable.v), 0.0);
        var z = new Variable(Math.abs(variable.v), variable.list.add(node), variable.list);
        return z;
    }
}