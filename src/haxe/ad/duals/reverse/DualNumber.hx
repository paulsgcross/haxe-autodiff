package haxe.ad.duals.reverse;

import haxe.ds.Vector;
import haxe.ad.duals.reverse.Components;

abstract DualNumber(Components) to Components from Components {

    public var v(get, never) : Float;
    public var index(get, never) : Int;
    public var list(get, never) : WengertList;

    public inline function new(v : Float, index : Int, list : WengertList) {
        this = new Components(v, index, list);
    }

    public inline function grad() : Gradient {
        var len = this.list.len();
        var out = new Gradient(len);

        out[index] = 1.0;

        for(i in 0...len) {
            var j = len - (i + 1);
            var node = this.list.get(j);
            var deriv = out[j];

            out[node.leftIndex] += node.leftValue * deriv;
            out[node.rightIndex] += node.rightValue * deriv;
        }

        return out;
    }

    @:commutative
    @:op(A*B)
    public inline function multiplyDual(dual : DualNumber) : DualNumber {
        var node = new Node(this.index, dual.index, dual.v, this.v);
        var z = new DualNumber(this.v * dual.v, this.list.add(node), this.list);
        return z;
    }

    @:commutative
    @:op(A + B)
    public inline function addDual(dual : DualNumber) : DualNumber {
        var node = new Node(this.index, dual.index, 1.0, 1.0);
        var z = new DualNumber(this.v + dual.v, this.list.add(node), this.list);
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
