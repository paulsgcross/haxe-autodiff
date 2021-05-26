package haxe.ad.duals.reverse;

final class Node {
    
    public var list(default, null) : WengertList;
    public var value(default, null) : Float;
    public var index(default, null) : Int;
    public var parents(default, null) : NodeParents;

    public inline function new(value : Float, list : WengertList) {
        this.value = value;
        this.list = list;
        this.index = list.add(this);
        this.parents = new NodeParents();
    }

}
