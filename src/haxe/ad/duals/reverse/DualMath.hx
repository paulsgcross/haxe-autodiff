package haxe.ad.duals.reverse;

class DualMath {
    
    public static inline function sin(dual : DualNumber) : DualNumber {
        var node = new Node(dual.index, dual.index, Math.cos(dual.v), 0.0);
        var z = new DualNumber(Math.sin(dual.v), dual.list.add(node), dual.list);
        return z;
    }

}