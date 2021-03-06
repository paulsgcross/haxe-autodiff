package macros;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;

class ForwardTrace {
    static var index = 0;
    public static function performForwardTrace(func : Function) : Function {
        var newExpressions : Array<Expr> = new Array();
        var expr = func.expr;
        var newArgs = new Array();
        for(arg in func.args) {
            newArgs.push(arg);
            newArgs.push({
                name: 'd' + arg.name,
                opt: arg.opt,
                meta: arg.meta,
                type: arg.type
            });
        }
        func.args = newArgs;

        index = 0;
        switch(expr.expr) {
            case EBlock(exprs):
                for(expression in exprs) {
                    switch(expression.expr) {
                        case EVars(vars):
                            var name = vars[0].name;
                            processExpression(vars[0].expr, newExpressions);
                            var newExpr = newExpressions.pop();
                            switch(newExpr.expr) {
                                case EVars(var_out):
                                    newExpressions.push(Util.createNewVariable(name, var_out[0].expr));
                                default:
                            }
                        default:
                            newExpressions.push(expression);
                    }
                }
            default:
        }

        var newFunc : Function = {
            args: func.args,
            ret: func.ret,
            expr: {
                pos: Context.currentPos(),
                expr: EBlock(newExpressions)
            }
        };

        return newFunc;
    }

    static function processExpression(expression : Expr, expressions : Array<Expr>) : Expr {
        switch(expression.expr) {
            case EBinop(op, e1, e2):
                
                var exp1 = processExpression(e1, expressions);
                var exp2 = processExpression(e2, expressions);
                var def = EBinop(op, exp1, exp2);

                return createIntermediateVar(def, expressions);
            case ECall(e, params):
                var array = params.copy();
                array[0] = processExpression(array[0], expressions);
                var def = ECall(e, array);
                return createIntermediateVar(def, expressions);
            case EParenthesis(e):
                return processExpression(e, expressions);
            case EUnop(op, postFix, e):
                switch(op) {
                    case OpNeg:
                        var exp = processExpression(e, expressions);
                        var def = EUnop(OpNeg, postFix, exp);
                        return createIntermediateVar(def, expressions);
                    default:
                }
                return expression;
            default:
                return expression;
        }
    }

    static function createIntermediateVar(def : ExprDef, expressions : Array<Expr>) : Expr {
        var name = 't' + Std.string(index++);
        var newVar = {
            pos: Context.currentPos(),
            expr: def
        };
        expressions.push(Util.createNewVariable(name, newVar));
        expressions.push(Util.createNewVariable('d' + name, Derivitive.create(def)));

        var newExpr = {
            pos: Context.currentPos(),
            expr: EConst(CIdent(name))
        };

        return newExpr;
    }

}

#end