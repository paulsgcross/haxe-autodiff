package haxe.ad.duals.reverse;

import haxe.ds.Vector;
import haxe.ad.duals.reverse.Node;

abstract Variable(Node) to Node from Node {

    public var value(get, never) : Float;
    public var index(get, never) : Int;
    public var list(get, never) : WengertList;
    public var parents(get, never) : NodeParents;

    public inline function new(value : Float, list : WengertList) {
        this = new Node(value, list);
    }

    @:commutative
    @:op(A*B)
    public inline function multiplyVar(rhs : Variable) : Variable {
        var z = new Variable(this.value * rhs.value, this.list);
        z.parents.set(this.index, rhs.index, rhs.value, this.value);
        return z;
    }

    @:commutative
    @:op(A*B)
    public inline function multiplyFloat(rhs : Float) : Variable {
        var z = new Variable(this.value * rhs, this.list);
        z.parents.set(this.index, 0, rhs, 0.0);
        return z;
    }

    @:commutative
    @:op(A + B)
    public inline function addVar(rhs : Variable) : Variable {
        var z = new Variable(this.value + rhs.value, this.list);
        z.parents.set(this.index, rhs.index, 1.0, 1.0);
        return z;
    }

    @:commutative
    @:op(A + B)
    public inline function addFloat(rhs : Float) : Variable {
        var z = new Variable(this.value + rhs, this.list);
        z.parents.set(this.index, 0, 1.0, 0.0);
        return z;
    }

    @:op(A - B)
    public inline function subVar(rhs : Variable) : Variable {
        var z = new Variable(this.value - rhs.value, this.list);
        z.parents.set(this.index, rhs.index, 1.0, -1.0);
        return z;
    }
    
    @:op(A - B)
    public static inline function subFloatFromVar(lhs : Variable, rhs : Float) : Variable {
        var z = new Variable(lhs.value - rhs, lhs.list);
        z.parents.set(lhs.index, 0, 1.0, 0.0);
        return z;
    }
    
    @:op(B - A)
    public static inline function subVarFromFloat(lhs : Float, rhs : Variable) : Variable {
        var z = new Variable(lhs - rhs.value, rhs.list);
        z.parents.set(0, rhs.index, 0.0, -1.0);
        return z;
    }

    @:op(A / B)
    public inline function divVar(rhs : Variable) : Variable {
        var z = new Variable(this.value / rhs.value, this.list);
        z.parents.set(this.index, rhs.index, 1.0 / rhs.value, -(this.value)/(rhs.value*rhs.value));
        return z;
    }
    
    @:op(A / B)
    public static inline function divVarByFloat(lhs : Variable, rhs : Float) : Variable {
        var z = new Variable(lhs.value / rhs, lhs.list);
        z.parents.set(lhs.index, 0, 1.0 / rhs, 0.0);
        return z;
    }
    
    @:op(B / A)
    public static inline function divFloatByVar(lhs : Float, rhs : Variable) : Variable {
        var z = new Variable(lhs - rhs.value, rhs.list);
        z.parents.set(0, rhs.index, 0.0, -(lhs)/(rhs.value*rhs.value));
        return z;
    }

    private inline function get_value() : Float {
        return this.value;
    }

    private inline function get_index() : Int {
        return this.index;
    }

    private inline function get_list() : WengertList {
        return this.list;
    }

    private inline function get_parents() : NodeParents {
        return this.parents;
    }


}
