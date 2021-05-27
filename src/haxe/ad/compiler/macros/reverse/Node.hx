package haxe.ad.compiler.macros.reverse;

import haxe.macro.Expr;

typedef Node = {
    var name : String;
    var ref : Expr;
    var expr : Expr;
    var leftParent : Int;
    var rightParent : Int;
}