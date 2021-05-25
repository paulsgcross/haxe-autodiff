package haxe.ad.duals.reverse;

final class Node {
    public var leftIndex(default, null) : Int;
    public var rightIndex(default, null) : Int;
    public var leftValue(default, null) : Float;
    public var rightValue(default, null) : Float;

    public inline function new(leftIndex : Int, rightIndex : Int, leftValue : Float, rightValue : Float) {
        this.leftIndex = leftIndex;
        this.rightIndex = rightIndex;
        this.leftValue = leftValue;
        this.rightValue = rightValue;
    }

    public function toString() : String {
        return '(' + this.leftIndex + ', ' + this.rightIndex + ')';
    }
}