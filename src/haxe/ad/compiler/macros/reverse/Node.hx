package haxe.ad.compiler.macros.reverse;

import haxe.ad.compiler.macros.reverse.Parents;
import haxe.macro.Expr;

typedef Node = {
    var idx : Int;
    var name : String;
    var ref : Expr;
    var expr : Expr;
    var parents : Parents;
}