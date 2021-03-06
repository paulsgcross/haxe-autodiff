package macros;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;

class Derivitive {

    public static function create(def : ExprDef) : Expr {
        switch(def) {
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
        return expr;
        var def = expr.expr;
        switch(expr.expr) {
            case EField(e, field):
                handleFunctions(field, params);
            case EConst(c):
                switch(c) {
                    case CIdent(s):
                        handleFunctions(s, params);
                    default:
                }
            default:
        }

        return expr;
    }

    static function handleFunctions(name : String, params : Array<Expr>) : ExprDef {
        trace(name);
        switch(name) {
            case 'cos':
            case 'sin':
            case 'tan':
            case 'pow':
            case 'sqrt':
            case 'exp':
            case 'log':
        }
        return EConst(CIdent(name));
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

    static function handleDivision(e1 : Expr, e2 : Expr) : Expr {
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
            expr: EBinop(OpSub, leftExpr, rightExpr)
        };
        return newExpr;
    }

    static function makeDeltaExpression(expr : Expr) : Expr {
        var out_def = expr.expr;
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

        var expr = {
            pos: Context.currentPos(),
            expr: out_def
        }

        return expr;
    }
}
#end