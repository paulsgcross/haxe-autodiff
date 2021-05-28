package haxe.ad.compiler.macros.reverse;

#if macro
import haxe.macro.Expr;
import haxe.ad.compiler.macros.Expressions;

class Derivatives {
    
    public static function create(expr : Expr) : Deriv {
        switch(expr.expr) {
            case EBinop(op, e1, e2):
                return createBinopDerivatives(op, e1, e2);
            case ECall(e, params):
                return createFieldDerivatives(e, params);
            default:
        }
        return null;
    }

    private static function createBinopDerivatives(op : Binop, e1 : Expr, e2 : Expr) : Deriv {
        switch(op) {
            case OpAdd:
                return {left: Expressions.createConstant(CFloat('1.0')), right: Expressions.createConstant(CFloat('1.0'))};
            case OpSub:
                return {left: Expressions.createConstant(CFloat('1.0')), right: Expressions.createConstant(CFloat('-1.0'))};
            case OpMult:
                return {left: e2, right: e1};
            case OpDiv:
                var le = Expressions.createBinop(OpDiv, Expressions.createConstant(CFloat('1.0')), e2);
                var re = Expressions.createUnop(Unop.OpNeg, false, e1);
                var denom = Expressions.createBinop(OpMult, e2, e2);
                re = Expressions.createBinop(OpDiv, re, denom);
                return {left: le, right: re};
            default:
        }
        return null;
    }

    private static function createFieldDerivatives(e : Expr, params : Array<Expr>) : Deriv {
        switch(e.expr) {
            case EField(e, field):
                switch(field) {
                    case 'sin':
                        return FieldDerivatives.differentiateSin(e, params);
                    case 'cos':
                        return FieldDerivatives.differentiateCos(e, params);
                    case 'tan':
                        return FieldDerivatives.differentiateTan(e, params);
                    case 'pow':
                        return FieldDerivatives.differentiatePow(e, params);
                    case 'exp':
                        return FieldDerivatives.differentiateExp(e, params);
                    case 'log':
                        return FieldDerivatives.differentiateLog(e, params);
                    default:
                }
            default:
        }
        return null;
    }
}
#end