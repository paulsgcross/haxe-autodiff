package macros;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;

class Util {
    public static function createNewVariable(name : String, expr : Expr) : Expr {
        var newVar : Expr = {
            pos: Context.currentPos(),
            expr: ExprDef.EVars([{
                name: name,
                type: null,
                expr: expr
            }])
        };

        return newVar;
    }

    
}
#end