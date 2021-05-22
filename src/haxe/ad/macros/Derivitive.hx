package haxe.ad.macros;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;

class Derivitive {

    public static function create(def : ExprDef) : Expr {
        switch(def) {
            case EConst(c):
                return {
                    pos: Context.currentPos(),
                    expr: makeDeltaDef(def)
                };
            case EUnop(op, postFix, e):
                switch(op) {
                    case OpNeg:
                        return handleNegative(e);
                    default:
                        return e;
                }
            case EBinop(op, e1, e2):
                switch(op) {
                    case OpMult:
                        return handleMultiplication(e1, e2);
                    case OpDiv:
                        return handleDivision(e1, e2);
                    case OpAdd | OpSub:
                        return handleAdditionSubtraction(op, e1, e2);
                    default:
                }
            case ECall(e, params):
                return handleCall(e, params);
            default:
        }

        return {
            pos: Context.currentPos(),
            expr: def
        };
    }

    static function handleCall(expr : Expr, params : Array<Expr>) : Expr {
        var funcExpr = handleFunctions(expr, params);
        
        return funcExpr;
    }

    static function handleFunctions(expr : Expr, params : Array<Expr>) : Expr {
        var def = expr.expr;
        switch(def) {
            case EField(e, field):
                switch(field) {
                    case 'sin':
                        return handleSine(e, params);
                    case 'cos':
                        return handleCosine(e, params);
                    case 'tan':
                        return handleTan(e, params);
                    case 'pow':
                        return handlePow(e, params);
                    case 'exp':
                        return handleExp(e, params);
                    case 'log':
                        return handleLog(e, params);
                    case 'sqrt':
                        return handleSqrt(e, params);
                    case 'abs':
                        return handleAbs(e, params);
                }
            default:
        }

        var expr = {
            pos: Context.currentPos(),
            expr: ECall(expr, params)
        };

        return expr;
    }
    
    static function handleSqrt(expression : Expr, params : Array<Expr>) : Expr {
        var newField = {
            pos: Context.currentPos(),
            expr: EField(expression, 'sqrt')
        }

        var newFunc = {
            pos: Context.currentPos(),
            expr: ECall(newField, params)
        };

        var recipExpr = {
            pos: Context.currentPos(),
            expr: EBinop(OpDiv, makeDeltaExpression(params[0]), newFunc)
        };

        var halfExpr = {
            pos: Context.currentPos(),
            expr: EConst(CFloat('0.5'))
        };

        var newExpr = {
            pos: Context.currentPos(),
            expr: EBinop(OpMult, halfExpr, recipExpr)
        };

        return newExpr;
    }

    static function handleLog(expression : Expr, params : Array<Expr>) : Expr {
        var newExpr = {
            pos: Context.currentPos(),
            expr: EBinop(OpDiv, makeDeltaExpression(params[0]), params[0])
        };

        return newExpr;
    }

    static function handlePow(expression : Expr, params : Array<Expr>) : Expr {
        var newParams = params.copy();
        var newParam = {
            pos: Context.currentPos(),
            expr: EBinop(OpSub, params[1], {
                pos: Context.currentPos(),
                expr: EConst(CInt('1'))
            })
        };

        newParams[1] = newParam;

        var newField = {
            pos: Context.currentPos(),
            expr: EField(expression, 'pow')
        }

        var newFunc = {
            pos: Context.currentPos(),
            expr: ECall(newField, newParams)
        };

        var dExpr = {
            pos: Context.currentPos(),
            expr: EBinop(OpMult, params[1], newFunc)
        };

        var newExpr = {
            pos: Context.currentPos(),
            expr: EBinop(OpMult, dExpr, makeDeltaExpression(params[0]))
        };

        return newExpr;
    }

    static function handleTan(expression : Expr, params : Array<Expr>) : Expr {
        var one = {
            pos: Context.currentPos(),
            expr: EConst(CFloat('1.0'))
        };

        var two = {
            pos: Context.currentPos(),
            expr: EConst(CFloat('2.0'))
        };

        var newField = {
            pos: Context.currentPos(),
            expr: EField(expression, 'tan')
        }

        var newCall = {
            pos: Context.currentPos(),
            expr: ECall(newField, params)
        };

        var powField = {
            pos: Context.currentPos(),
            expr: EField(expression, 'pow')
        }

        var powCall = {
            pos: Context.currentPos(),
            expr: ECall(powField, [newCall, two])
        };

        var plusFunc = {
            pos: Context.currentPos(),
            expr: EBinop(OpAdd, one, powCall)
        };

        var newExpr = {
            pos: Context.currentPos(),
            expr: EBinop(OpMult, plusFunc, makeDeltaExpression(params[0]))
        };

        return newExpr;
    }

    static function handleSine(expression : Expr, params : Array<Expr>) : Expr {
        var newField = {
            pos: Context.currentPos(),
            expr: EField(expression, 'cos')
        }

        var newFunc = {
            pos: Context.currentPos(),
            expr: ECall(newField, params)
        };

        var newExpr = {
            pos: Context.currentPos(),
            expr: EBinop(OpMult, newFunc, makeDeltaExpression(params[0]))
        };

        return newExpr;
    }

    static function handleCosine(expression : Expr, params : Array<Expr>) : Expr {
        var newField = {
            pos: Context.currentPos(),
            expr: EField(expression, 'sin')
        }

        var newFunc = {
            pos: Context.currentPos(),
            expr: ECall(newField, params)
        };

        var newExpr = {
            pos: Context.currentPos(),
            expr: EBinop(OpMult, newFunc, makeDeltaExpression(params[0]))
        };

        var negExpr = {
            pos: Context.currentPos(),
            expr: EUnop(Unop.OpNeg, false, newExpr)
        };

        return negExpr;
    }

    static function handleExp(expression : Expr, params : Array<Expr>) : Expr {
        var newField = {
            pos: Context.currentPos(),
            expr: EField(expression, 'exp')
        }

        var newFunc = {
            pos: Context.currentPos(),
            expr: ECall(newField, params)
        };

        var newExpr = {
            pos: Context.currentPos(),
            expr: EBinop(OpMult, newFunc, makeDeltaExpression(params[0]))
        };

        return newExpr;
    }

    static function handleNegative(e : Expr) : Expr {
        var expr = {
            pos: Context.currentPos(),
            expr: EUnop(Unop.OpNeg, false, makeDeltaExpression(e))
        };

        return expr;
    }

    static function handleAdditionSubtraction(op : Binop, e1 : Expr, e2 : Expr) : Expr {
        var expr = {
            pos: Context.currentPos(),
            expr: EBinop(op, makeDeltaExpression(e1), makeDeltaExpression(e2))
        };

        return expr;
    }

    static function handleMultiplication(e1 : Expr, e2 : Expr) : Expr {
        var leftExpr = {
            pos: Context.currentPos(),
            expr: EBinop(OpMult, e1, makeDeltaExpression(e2))
        };

        var rightExpr = {
            pos: Context.currentPos(),
            expr: EBinop(OpMult, makeDeltaExpression(e1), e2)
        };

        var newExpr = {
            pos: Context.currentPos(),
            expr: EBinop(OpAdd, leftExpr, rightExpr)
        };

        return newExpr;
    }

    static function handleAbs(expression : Expr, params : Array<Expr>) : Expr {
        var newField = {
            pos: Context.currentPos(),
            expr: EField(expression, 'abs')
        }

        var newFunc = {
            pos: Context.currentPos(),
            expr: ECall(newField, params)
        };

        var signExpr = {
            pos: Context.currentPos(),
            expr: EBinop(OpDiv, params[0], newFunc)
        };

        var newExpr = {
            pos: Context.currentPos(),
            expr: EBinop(OpMult, signExpr, makeDeltaExpression(params[0]))
        };

        return newExpr;
    }

    static function handleDivision(e1 : Expr, e2 : Expr) : Expr {
        var leftExpr = {
            pos: Context.currentPos(),
            expr: EBinop(OpMult, e1, makeDeltaExpression(e2))
        };

        var rightExpr = {
            pos: Context.currentPos(),
            expr: EBinop(OpMult, makeDeltaExpression(e1), e2)
        };

        var subExpr = {
            pos: Context.currentPos(),
            expr: EBinop(OpSub, rightExpr, leftExpr)
        };

        var squaredExpr = {
            pos: Context.currentPos(),
            expr: EBinop(OpMult, e2, e2)
        };

        var newExpr = {
            pos: Context.currentPos(),
            expr: EBinop(OpDiv, subExpr, squaredExpr)
        }

        return newExpr;
    }

    static function makeDeltaDef(def : ExprDef) : ExprDef {
        var out_def = def;
        switch(out_def) {
            case EConst(c):
                switch(c) {
                    case CIdent(s):
                        out_def = EConst(CIdent('d' + s));
                    case CFloat(v):
                        out_def = EConst(CFloat('0.0'));
                    case CInt(v):
                        out_def = EConst(CInt('0'));
                    default:
                }
            default:
        }

        return out_def;
    }

    static function makeDeltaExpression(expr : Expr) : Expr {
        var out_def = makeDeltaDef(expr.expr);

        var expr = {
            pos: Context.currentPos(),
            expr: out_def
        }

        return expr;
    }
}
#end