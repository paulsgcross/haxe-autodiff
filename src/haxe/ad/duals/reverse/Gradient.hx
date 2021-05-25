package haxe.ad.duals.reverse;

import haxe.ds.Vector;

abstract Gradient(Vector<Float>) {
    public function new(length : Int) {
        this = new Vector(length);
    }

    @:op([])
    public function set(index : Int, value : Float) : Void {
        this.set(index, value);
    }

    @:op([])
    public function get(index : Int) : Float {
        return this.get(index);
    }

    public function wrt(variable : DualNumber) : Float {
        return this[variable.index];
    }
}