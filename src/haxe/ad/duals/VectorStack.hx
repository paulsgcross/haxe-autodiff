package haxe.ad.duals;

import haxe.ds.Vector;

class VectorStack {

    private static var _i : Int;
    private static var _size : Int;
    private static var _stack : Vector<Vector<Float>>;

    public static function init(size : Int) {
        _i = 0;
        _size = size;
        _stack = new Vector(size);
        for(i in 0...size) {
            _stack[i] = new Vector(2);
        }
    }

    public static function get() : Vector<Float> {
        if(_stack == null) {
            init(500);
        }

        var i = _i++ % _size;
        
        return _stack[i];
    }
}