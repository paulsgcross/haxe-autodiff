package haxe.ad.compiler.macros.reverse;

import haxe.ad.compiler.macros.reverse.Parents;
import haxe.macro.Expr;

typedef Graph = {
    var inputs : Map<String, Int>;
    var nodes : Array<Node>;
}
