package haxe.ad.compiler.macros;

#if macro
import haxe.ds.StringMap;
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
                var newExprs = [];
                switch(it.expr) {
                    case EBinop(OpIn, e1, _):
                        switch(e1.expr) {
                            case EConst(CIdent(f)):
                                var vars = Expressions.createVars([{
                                    name: 'd' + f,
                                    type: null,
                                    expr: Expressions.createConstant(CInt('0')),
                                    isFinal: false
                                }]);
                                newExprs.push(vars);
                            default:
                        }
                    default:
                }
                newExprs.push(Expressions.createFor(it, transform(expr)));
                return Expressions.createBlock(newExprs);
            case EReturn(expr):
                return Expressions.createReturn(transform(expr));
            case EIf(econd, eif, eelse):
                return Expressions.createIf(econd, transform(eif), eelse!=null?transform(eelse):null);
            case EBinop(op, _, _):
                switch(op) {
                    case OpAdd, OpSub, OpDiv, OpMult:
                        return Derivatives.transformExpr(expr);
                    default:
                        var newExprs = [];
                        newExprs.push(expr);
                        newExprs.push(Derivatives.transformExpr(expr));
                        return Expressions.createBlock(newExprs);
                }
            case ECall(_, _), EField(_, _), EConst(_), EParenthesis(_), EUnop(_, _, _):
                return Derivatives.transformExpr(expr);
            default:
        }
        
        return expr;
    }
    
}
#end