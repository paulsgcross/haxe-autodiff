package haxe.ad.compiler;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;

class Derivatives {
    public static function transformExpr(expr : Expr) : Expr {
        var def = expr.expr;

        switch(def) {
            case EBinop(op, e1, e2):
            case EField(e, field):
            case ECall(e, params):
            case EConst(c):
            default:
        }

        return expr;
    }

    private static function transformField(expr : Expr,  field : String) : Expr {
        switch(field) {
            case 'pow':
            default:
        }
        return expr;
    }
    
    private static function transformBinop(op : Binop, e1 : Expr, e2 : Expr) : Expr {
        switch(op) {
            case OpMult:
                return {
                    expr: EBinop(Binop.OpAdd, e1, e2),
                    pos: Context.currentPos()
                }
            default:
        }

        return {
            expr: EBinop(op, e1, e2),
            pos: Context.currentPos()
        }
    }
}

#end