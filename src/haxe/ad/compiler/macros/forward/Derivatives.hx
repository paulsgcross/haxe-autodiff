package haxe.ad.compiler.macros.forward;

import haxe.macro.Context;
import haxe.macro.TypeTools;
#if macro
import haxe.macro.Expr;

class Derivatives {
    public static function transformExpr(expr : Expr) : Expr {
        var def = expr.expr;
        switch(def) {
            case EParenthesis(e):
                return transformExpr(e);
            case EBinop(op, e1, e2):
                return transformBinop(op, e1, e2);
            case ECall(e, params):
                return transformCall(e, params);
            case EUnop(op, postfix, e):
                return transformUnop(op, postfix, e);
            case EConst(c):
                return transformConst(c);
            case EArray(e1, e2):
                return transformArray(e1, e2);
            default:
        }

        return expr;
    }

    private static function transformConst(c : Constant) : Expr {
        switch(c) {
            case CFloat(f), CInt(f):
                return Expressions.createConstant(CFloat('0.0'));
            case CIdent(f):
                return Expressions.createConstant(CIdent('d'+f));
            default:
        }
        return Expressions.createConstant(c);
    }
    
    private static function transformCall(expr : Expr,  params : Array<Expr>) : Expr {
        var def = expr.expr;

        switch(def) {
            case EField(e, field):
                switch(field) {
                    case 'sin':
                        return FieldDerivatives.differentiateSin(e, params);
                    case 'cos':
                        return FieldDerivatives.differentiateCos(e, params);
                    case 'tan':
                        return FieldDerivatives.differentiateTan(e, params);
                    case 'sqrt':
                        return FieldDerivatives.differentiateSqrt(e, params);
                    case 'abs':
                        return FieldDerivatives.differentiateAbs(e, params);
                    case 'exp':
                        return FieldDerivatives.differentiateExp(e, params);
                    case 'pow':
                        return FieldDerivatives.differentiatePow(e, params);
                    case 'log':
                        return FieldDerivatives.differentiateLog(e, params);
                    default: 
                }
            default:
        }
        
        return expr;
    }

    private static function transformUnop(op : Unop, postfix : Bool, e : Expr) : Expr {
        return Expressions.createUnop(op, postfix, transformExpr(e));
    }

    private static function transformBinop(op : Binop, e1 : Expr, e2 : Expr) : Expr {
        switch(op) {
            case OpMult:
                var transE1 = Expressions.createBinop(OpMult, e1, transformExpr(e2));
                var transE2 = Expressions.createBinop(OpMult, transformExpr(e1), e2);
                return Expressions.createBinop(OpAdd, transE1, transE2);
            case OpDiv:
                var transE1 = Expressions.createBinop(OpMult, e1, transformExpr(e2));
                var transE2 = Expressions.createBinop(OpMult, transformExpr(e1), e2);
                var transE4 = Expressions.createBinop(OpMult, e2, e2);
                var transE3 = Expressions.createBinop(OpSub, transE1, transE2);
                return Expressions.createBinop(OpDiv, transE3, transE4);
            default:
                return Expressions.createBinop(op, transformExpr(e1), transformExpr(e2));
        }

        return Expressions.createBinop(op, e1, e2);
    }

    private static function transformArray(e1 : Expr, e2 : Expr) : Expr {
        return Expressions.createArray(transformExpr(e1), e2);
    }
}

#end