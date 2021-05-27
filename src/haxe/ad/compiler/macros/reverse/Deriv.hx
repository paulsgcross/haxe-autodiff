package haxe.ad.compiler.macros.reverse;

import haxe.macro.Expr.Constant;

typedef Deriv = {
    var left : Null<Constant>;
    var leftidx : Int;
    var right : Null<Constant>;
    var rightidx : Int;
}
