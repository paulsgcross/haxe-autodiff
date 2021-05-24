package haxe.ad.compiler;

#if macro
import haxe.macro.Expr;

class FieldDerivatives {
    public static function differentiateSin(expr : Expr,  in_params : Array<Expr>) : Expr {
        var call = Expressions.createCall(Expressions.createField(expr, 'cos'), in_params);
        return Expressions.createBinop(Binop.OpMult, Derivatives.transformExpr(in_params[0]), call);
    }

    public static function differentiateCos(expr : Expr,  in_params : Array<Expr>) : Expr {
        var call = Expressions.createCall(Expressions.createField(expr, 'sin'), in_params);
        call = Expressions.createUnop(Unop.OpNeg, false, call);
        return Expressions.createBinop(Binop.OpMult, Derivatives.transformExpr(in_params[0]), call);
    }

    public static function differentiateTan(expr : Expr,  in_params : Array<Expr>) : Expr {
        var call = Expressions.createCall(Expressions.createField(expr, 'tan'), in_params);
        var params = [call, Expressions.createConstant(CFloat('2.0'))];
        call = Expressions.createCall(Expressions.createField(expr, 'pow'), params);
        call = Expressions.createBinop(Binop.OpAdd, Expressions.createConstant(CFloat('1.0')), call);
        return Expressions.createBinop(Binop.OpMult, Derivatives.transformExpr(in_params[0]), call);
    }

    public static function differentiateSqrt(expr : Expr,  in_params : Array<Expr>) : Expr {
        var params = [in_params[0], Expressions.createConstant(CFloat('-0.5'))];
        var call = Expressions.createCall(Expressions.createField(expr, 'pow'), params);
        call = Expressions.createBinop(Binop.OpMult, Expressions.createConstant(CFloat('0.5')), call);
        return Expressions.createBinop(Binop.OpMult, Derivatives.transformExpr(in_params[0]), call);
    }

    public static function differentiateAbs(expr : Expr,  in_params : Array<Expr>) : Expr {
        var call = Expressions.createCall(Expressions.createField(expr, 'abs'), in_params);
        call = Expressions.createBinop(Binop.OpDiv, in_params[0], call);
        return Expressions.createBinop(Binop.OpMult, Derivatives.transformExpr(in_params[0]), call);
    }

    public static function differentiateExp(expr : Expr,  in_params : Array<Expr>) : Expr {
        var call = Expressions.createCall(Expressions.createField(expr, 'exp'), in_params);
        return Expressions.createBinop(Binop.OpMult, Derivatives.transformExpr(in_params[0]), call);
    }

    public static function differentiatePow(expr : Expr,  in_params : Array<Expr>) : Expr {
        var newParams = [
            in_params[0],
            Expressions.createBinop(Binop.OpSub, in_params[1], Expressions.createConstant(CFloat('1.0')))
        ];

        var call = Expressions.createCall(Expressions.createField(expr, 'pow'), newParams);
        call = Expressions.createBinop(Binop.OpMult, in_params[1], call);
        
        return Expressions.createBinop(Binop.OpMult, Derivatives.transformExpr(in_params[0]), call);
    }
}
#end