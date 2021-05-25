package haxe.ad.duals.reverse;

final class WengertList {

    private var _list : Array<Node>;

    public function new() {
        _list = new Array();
    }

    public function createVariable(value : Float) : Variable {
        var node = new Node(0, 0, 0.0, 0.0);
        return new Variable(value, add(node), this);
    }

    public function add(node : Node) : Int {
        return _list.push(node) - 1;
    }

    public function get(index : Int) : Node {
        return _list[index];
    }

    public function len() : Int {
        return _list.length;
    }

    public function toString() : String {
        return _list.toString();
    }
}