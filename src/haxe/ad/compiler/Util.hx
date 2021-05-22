package haxe.ad.compiler;

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
    
    public static function createFor(it : Expr, expr : Expr) : Expr {
        return {
            pos: Context.currentPos(),
            expr: EFor(it, expr)
        };
    }

    public static function createWhile(cond : Expr, expr : Expr, normal : Bool) : Expr {
        return {
            pos: Context.currentPos(),
            expr: EWhile(cond, expr, normal)
        };
    }

    public static function createIf(cond : Expr, expr : Expr, eelse : Expr) : Expr {
        return {
            pos: Context.currentPos(),
            expr: EIf(cond, expr, eelse)
        };
    }

    public static function createAssignment(name : String, expr : Expr) : Expr {
        var name = Util.createVariableReference(name);

        var newExpr = {
            pos : Context.currentPos(),
            expr: EBinop(OpAssign, name, expr)
        }

        return newExpr;
    }

    public static function createForTempVariable(it : Expr) : Expr {
        switch(it.expr) {
            case EBinop(op, e1, e2):
                var name = Util.getName(e1.expr);
                trace(e2.expr);
               return  Util.createNewVariable('d'+name, {
                   pos: Context.currentPos(),
                   expr: EConst(CInt('0'))
               });
            default:
        }
        return null;
    }

}
#end