package haxe.ad.duals.reverse;

final class NodeParents {
    
    public var leftIndex(default, null) : Int;
    public var rightIndex(default, null) : Int;
    public var leftValue(default, null) : Float;
    public var rightValue(default, null) : Float;

    public inline function new() {
        this.leftIndex = 0;
        this.rightIndex = 0;
        this.leftValue = 0.0;
        this.rightValue = 0.0;
    }

    public inline function set(leftIndex : Int, rightIndex : Int, leftValue : Float, rightValue : Float) {
        this.leftIndex = leftIndex;
        this.rightIndex = rightIndex;
        this.leftValue = leftValue;
        this.rightValue = rightValue;
    }
}