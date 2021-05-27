package haxe.ad.compiler.macros.reverse;

class FieldDerivatives {
    public static function createCosDeriv(expr : Expr,  in_params : Array<Expr>, graph : Graph) : Expr {
        var call = Expressions.createCall(Expressions.createField(expr, 'sin'), in_params);
        call = Expressions.createUnop(Unop.OpNeg, false, call);
        return Expressions.createBinop(Binop.OpMult, Derivatives.transformExpr(in_params[0]), call);
    }

    public static function differentiateExp(expr : Expr,  in_params : Array<Expr>, graph : Graph) : Expr {
        var call = Expressions.createCall(Expressions.createField(expr, 'exp'), in_params);
        return Expressions.createBinop(Binop.OpMult, Derivatives.transformExpr(in_params[0]), call);
    }

}