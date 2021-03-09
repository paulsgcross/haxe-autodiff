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

    public static function createVariableReference(name : String) : Expr {
        var opVar = {
            pos: Context.currentPos(),
            expr: EConst(CIdent(name))
        };
        return opVar;
    }

    public static function getName(def : ExprDef) : String {
        switch(def) {
            case EConst(c):
                switch (c) {
                    case CIdent(s):
                        return s;
                    default:
                }
            default:
        }
        return "";
    }

    public static function getVariableExpression(expr : Expr) : Expr {
        switch(expr.expr) {
            case EVars(var_out):
                return var_out[0].expr;
            default:
        }
        return null;
    }
}
#end