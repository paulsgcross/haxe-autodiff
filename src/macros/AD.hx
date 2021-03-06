package macros;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;

class AD {
    macro static public function build() : Array<Field> {
        var fields = Context.getBuildFields();
        var newFields : Array<Field> = new Array();
        for(field in fields) {
            newFields.push(field);
            switch(field.kind) {
                case FieldType.FFun(fn):
                    var newFn = processFunctionReturns(fn);
                    var newField : Field = {
                        name: field.name + "_diff",
                        access: field.access,
                        kind: FieldType.FFun(performForwardTrace(newFn)),
                        pos: Context.currentPos()
                    };
                    newFields.push(newField);
                default:
            }
        }

        return newFields;
    }

    static function processFunctionReturns(func : Function) : Function {
        var newExpressions : Array<Expr> = new Array();
        var expr = func.expr;
        var index = 0;
        switch(expr.expr) {
            case EBlock(exprs):
                for(expression in exprs) {
                    var def = expression.expr;
                    switch(def) {
                        case EReturn(expr):
                            switch (expr.expr) {
                                case EConst(c):
                                    newExpressions.push(expression);
                                default:
                                    var name = 'ret' + Std.string(index++);
                                    var newVar : Expr = createNewVariable(name, expr);
                                    
                                    var returnExpr = {
                                        pos: Context.currentPos(),
                                        expr: EReturn({
                                            pos: Context.currentPos(),
                                            expr: EConst(CIdent(name))
                                        })
                                    };

                                    newExpressions.push(newVar);
                                    newExpressions.push(returnExpr);
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

    static function createNewVariable(name : String, expr : Expr) : Expr {
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

    static function createNewBinOp(name : String, expr : Expr) : Expr {
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

    static var index = 0;
    static function performForwardTrace(func : Function) : Function {
        var newExpressions : Array<Expr> = new Array();
        var expr = func.expr;

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
                                    newExpressions.push(createNewVariable(name, var_out[0].expr));
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
                var exp1 = processExpression(params[0], expressions);
                var def = ECall(e, [exp1]);

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
        expressions.push(createNewVariable(name, newVar));

        var newExpr = {
            pos: Context.currentPos(),
            expr: EConst(CIdent(name))
        };

        return newExpr;
    }
}
#end