package haxe.ad.compiler.macros.reverse;

#if macro
import haxe.macro.Expr;

class FieldDerivatives {
    public static function differentiateSin(expr : Expr, params : Array<Expr>) {
        return {left: Expressions.createCall(Expressions.createField(expr, 'cos'), params), right: null};
    }

    public static function differentiateCos(expr : Expr, params : Array<Expr>) {
        var e1 = Expressions.createCall(Expressions.createField(expr, 'sin'), params);
        return {left: Expressions.createUnop(OpNeg, false, e1), right: null};
    }

    public static function differentiateTan(expr : Expr, params : Array<Expr>) {
        var e1 = Expressions.createCall(Expressions.createField(expr, 'tan'), params);
        var e2 = Expressions.createBinop(OpMult, e1, e1);
        var e3 = Expressions.createBinop(OpAdd, Expressions.createConstant(CFloat('1.0')), e2);
        return {left: e3, right: null};
    }

    public static function differentiatePow(expr : Expr, params : Array<Expr>) {
        var e1 = Expressions.createBinop(OpSub, params[1], Expressions.createConstant(CFloat('1.0')));
        var e2 = Expressions.createCall(Expressions.createField(expr, 'pow'), [params[0], e1]);
        var e3 = Expressions.createBinop(OpMult, params[1], e2);
        return {left: e3, right: null};
    }

    public static function differentiateAbs(expr : Expr, params : Array<Expr>) {
        var e1 = Expressions.createCall(Expressions.createField(expr, 'abs'), params);
        var e2 = Expressions.createBinop(OpDiv, params[0], e1);
        return {left: e2, right: null};
    }

    public static function differentiateSqrt(expr : Expr, params : Array<Expr>) {
        return differentiatePow(expr, [params[0], Expressions.createConstant(CFloat('0.5'))]);
    }

    public static function differentiateExp(expr : Expr, params : Array<Expr>) {
        return {left: Expressions.createCall(Expressions.createField(expr, 'exp'), params), right: null};
    }

    public static function differentiateLog(expr : Expr, params : Array<Expr>) {
        return {left: Expressions.createBinop(OpDiv, Expressions.createConstant(CFloat('1.0')), params[0]), right: null};
    }

}
#end