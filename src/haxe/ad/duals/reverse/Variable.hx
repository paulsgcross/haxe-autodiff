package haxe.ad.duals.reverse;

import haxe.ds.Vector;
import haxe.ad.duals.reverse.Components;

abstract Variable(Components) to Components from Components {

    public var v(get, never) : Float;
    public var index(get, never) : Int;
    public var list(get, never) : WengertList;

    public inline function new(v : Float, index : Int, list : WengertList) {
        this = new Components(v, index, list);
    }

    @:commutative
    @:op(A*B)
    public inline function multiplyVar(rhs : Variable) : Variable {
        var node = new Node(this.index, rhs.index, rhs.v, this.v);
        var z = new Variable(this.v * rhs.v, this.list.add(node), this.list);
        return z;
    }

    @:commutative
    @:op(A*B)
    public inline function multiplyFloat(rhs : Float) : Variable {
        var node = new Node(this.index, 0, rhs, 0.0);
        var z = new Variable(this.v * rhs, this.list.add(node), this.list);
        return z;
    }

    @:commutative
    @:op(A + B)
    public inline function addVar(rhs : Variable) : Variable {
        var node = new Node(this.index, rhs.index, 1.0, 1.0);
        var z = new Variable(this.v + rhs.v, this.list.add(node), this.list);
        return z;
    }

    @:commutative
    @:op(A + B)
    public inline function addFloat(rhs : Float) : Variable {
        var node = new Node(this.index, 0, 1.0, 0.0);
        var z = new Variable(this.v + rhs, this.list.add(node), this.list);
        return z;
    }

    @:op(A - B)
    public inline function subVar(rhs : Variable) : Variable {
        var node = new Node(this.index, rhs.index, 1.0, -1.0);
        var z = new Variable(this.v - rhs.v, this.list.add(node), this.list);
        return z;
    }
    
    @:op(A - B)
    public static inline function subFloatFromVar(lhs : Variable, rhs : Float) : Variable {
        var node = new Node(lhs.index, 0, 1.0, 0.0);
        var z = new Variable(lhs.v - rhs, lhs.list.add(node), lhs.list);
        return z;
    }
    
    @:op(B - A)
    public static inline function subVarFromFloat(lhs : Float, rhs : Variable) : Variable {
        var node = new Node(0, rhs.index, 0.0, -1.0);
        var z = new Variable(lhs - rhs.v, rhs.list.add(node), rhs.list);
        return z;
    }

    @:op(A / B)
    public inline function divVar(rhs : Variable) : Variable {
        var node = new Node(this.index, rhs.index, 1.0 / rhs.v, -(this.v)/(rhs.v*rhs.v));
        var z = new Variable(this.v / rhs.v, this.list.add(node), this.list);
        return z;
    }
    
    @:op(A / B)
    public static inline function divVarByFloat(lhs : Variable, rhs : Float) : Variable {
        var node = new Node(lhs.index, 0, 1.0 / rhs, 0.0);
        var z = new Variable(lhs.v / rhs, lhs.list.add(node), lhs.list);
        return z;
    }
    
    @:op(B / A)
    public static inline function divFloatByVar(lhs : Float, rhs : Variable) : Variable {
        var node = new Node(0, rhs.index, 0.0, -(lhs)/(rhs.v*rhs.v));
        var z = new Variable(lhs - rhs.v, rhs.list.add(node), rhs.list);
        return z;
    }

    private inline function get_v() : Float {
        return this.v;
    }

    private inline function get_index() : Int {
        return this.index;
    }

    private inline function get_list() : WengertList {
        return this.list;
    }


}
