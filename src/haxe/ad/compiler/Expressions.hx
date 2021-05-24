package haxe.ad.compiler;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr.ExprDef;
import haxe.macro.Expr;

class Expressions {
    
    public static function createBlock(exprs : Array<Expr>) : Expr {
        return {
            expr: ExprDef.EBlock(exprs),
            pos: Context.currentPos()
        }
    }

    public static function createVars(vars : Array<Var>) : Expr {
        return {
            expr: ExprDef.EVars(vars),
            pos: Context.currentPos()
        }
    }

    public static function createIf(econd : Expr, eif : Expr, eelse : Null<Expr>) : Expr {
        return {
            expr: ExprDef.EIf(econd, eif, eelse),
            pos: Context.currentPos()
        }
    }

    public static function createWhile(econd : Expr, e : Expr, normalWhile : Bool) : Expr {
        return {
            expr: ExprDef.EWhile(econd, e, normalWhile),
            pos: Context.currentPos()
        }
    }

    public static function createFor(it : Expr, expr : Expr) : Expr {
        return {
            expr: ExprDef.EFor(it, expr),
            pos: Context.currentPos()
        }
    }

    public static function createReturn(expr : Null<Expr>) : Expr {
        return {
            expr: ExprDef.EReturn(expr),
            pos: Context.currentPos()
        }
    }

    public static function createBinop(op : Binop, e1 : Expr, e2 : Expr) : Expr {
        return {
            expr: ExprDef.EBinop(op, e1, e2),
            pos: Context.currentPos()
        }
    }

    public static function createField(expr : Expr,  field : String) : Expr {
        return {
            expr: ExprDef.EField(expr, field),
            pos: Context.currentPos()
        }
    }

    public static function createConstant(c : Constant) : Expr {
        return {
            expr: ExprDef.EConst(c),
            pos: Context.currentPos()
        }
    }
}
#end