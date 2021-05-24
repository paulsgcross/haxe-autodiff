package haxe.ad.compiler;

#if macro
import haxe.macro.Expr.Function;
import haxe.macro.Expr;
import haxe.macro.Context;

class ForwardMode {
    public static function perform(func : Function) : Function {
        var newArgs = [];
        for(arg in func.args) {
            newArgs.push(arg);
            newArgs.push({
                name: 'd' + arg.name,
                type: arg.type
            });
        }

        var newExpr = transform(func.expr);
        var newRet = func.ret;

        return {
            args: newArgs,
            expr: newExpr,
            ret: newRet
        };
    }

    private static function transform(expr : Expr) : Expr {
        var def = expr.expr;
        
        switch(def) {
            case EBlock(exprs):
                var transExpr = [];
                for(expr in exprs) {
                    transExpr.push(transform(expr));
                }
                return Expressions.createBlock(transExpr);
            case EVars(vars):
                var transVars = [];
                for(v in vars) {
                    transVars.push(v);
                    transVars.push({
                        name: 'd' + v.name,
                        type: v.type,
                        expr: transform(v.expr),
                        isFinal: v.isFinal
                    });
                }
                return Expressions.createVars(transVars);
            case EWhile(econd, expr, normalWhile):
                return Expressions.createWhile(econd, expr, normalWhile);
            case EFor(it, expr):
                return Expressions.createFor(it, transform(expr));
            case EReturn(expr):
                return Expressions.createReturn(transform(expr));
            case EIf(econd, eif, eelse):
                return Expressions.createIf(econd, transform(eif), transform(eelse));
            case EField(_, _), EBinop(_, _, _), EConst(_), EParenthesis(_):
                return Derivatives.transformExpr(expr);
            default:
        }
        
        return expr;
    }
}
#end