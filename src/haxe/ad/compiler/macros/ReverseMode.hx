package haxe.ad.compiler.macros;


#if macro
import haxe.ds.StringMap;
import haxe.macro.Expr.Function;
import haxe.macro.Expr;
import haxe.macro.Context;

class ReverseMode {

    private static var _list : Array<Expr>;

    public static function perform(func : Function) : Function {
        _list = new Array();

        transform(func.expr);

        var newArgs = func.args;
        var newExpr = construct(_list);
        var newRet = func.ret;
        
        return {
            args: newArgs,
            expr: newExpr,
            ret: newRet
        };
    }

    private static function transform(expr : Expr) : Void {
        var def = expr.expr;
        
        switch(def) {
            case EBlock(es):
                for(e in es) {
                    transform(e);
                }
            case EReturn(e):
                _list.push(expr);

                transform(e);
            case EVars(vars):
                for(v in vars) {
                    transform(v.expr);
                }    
            case EBinop(op, e1, e2):
                _list.push(transformBinop(op, e1, e2));

                transform(e1);
                transform(e2);
            case EConst(c):
                _list.push(expr);
            case ECall(e, params):
                _list.push(expr);
            default:
        }
    }

    private static function construct(list : Array<Expr>) : Expr {
        var len = list.length;
        var exprs = [];
        for(i in 0...len) {
            var j = len - (i + 1);
            var expr = list[j];
            exprs.push(expr);
        }
        
        return Expressions.createBlock(exprs);
    }

    private static function transformBinop(op : Binop, e1 : Expr, e2 : Expr) : Expr {
        switch(op) {
            case OpMult:
                var v = Expressions.createVar('g', Expressions.createBinop(OpAdd, e1, e2));
                return Expressions.createVars([v]);
            default:
        }
        return Expressions.createBinop(op, e1, e2);
    }
}
#end