package haxe.ad.duals.reverse;

final class Components {
    
    public var v : Float;
    public var index : Int;
    public var list : WengertList;

    public inline function new(v : Float, index : Int, list : WengertList) {
        this.v = v;
        this.index = index;
        this.list = list;
    }
}