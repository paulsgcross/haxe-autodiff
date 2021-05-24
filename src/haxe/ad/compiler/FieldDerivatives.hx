package haxe.ad.compiler;

#if macro
import haxe.macro.Expr;

public static function transformField(expr : Expr,  field : String) : Expr {
    
    return expr;
}

#end