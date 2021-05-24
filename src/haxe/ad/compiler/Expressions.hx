package haxe.ad.compiler;

import haxe.macro.Context;
#if macro
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
}
#end