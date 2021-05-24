package haxe.ad.compiler;

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
            case EField(e, field):
                return transformField(expr, field);
            case EUnop(op, postfix, e):
                return transformUnop(op, postfix, e);
            case EConst(c):
                return transformConst(c);
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
    
    private static function transformField(expr : Expr,  field : String) : Expr {
        switch(field) {
            case 'sin':
            case 'cos':
            case 'tan':
            case 'sqrt':
            case 'abs':
            case 'exp':
            case 'pow':
            default:
        }
        return expr;
    }

    private static function transformUnop(op : Unop, postfix : Bool, e : Expr) : Expr {
        trace(e);
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
}

#end