package haxe.ad.duals.forward;

class Components {
    public var v : Float;
    public var d : Float;

    public inline function new(v : Float, d : Float) {
        this.v = v;
        this.d = d;
    }
}