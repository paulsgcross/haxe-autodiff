package haxe.ad.duals.macros;

#if macro
import haxe.macro.Expr.ComplexType;
import haxe.macro.Expr.FunctionArg;
import haxe.macro.*;
import haxe.macro.Expr.Field;
import haxe.macro.Expr.ExprDef;
import haxe.macro.Expr.Constant;

final class Converter {
    public static function build() : Array<Field> {

        var fields = Context.getBuildFields();
        for(field in fields) {
            switch(field.kind) {
                case FFun(f):
                    trace('Converting... \n'); 

                    convertArgs(f.args);
                    f.expr = propagateFunction(f.expr);
                    convertReturn(f.ret);
                default:
            }
        }
        return fields;
    }

    private static function propagateFunction(expr : Expr) : Expr {
        var def = expr.expr;
        switch(def) {
            case EBlock(exprs):
                var newExprs = [];
                for(expr in exprs) {
                    newExprs.push(propagateFunction(expr));
                }
            case EBinop(_, e1, e2):
                var e1 = propagateFunction(e1);
                var e2 = propagateFunction(e2);
            case EVars(vars):
                var newVars = [];
                for(variable in vars) {
                    propagateFunction(variable.expr);
                }
            case EWhile(_, expr, _), EFor(_, expr), EReturn(expr):
                propagateFunction(expr);
            case ECall(expr, params):
                propagateFunction(expr);
                for(param in params) {
                    propagateFunction(param);
                }
            case EField(expr, field):
                propagateFunction(expr);
            case EConst(c):
                convertConstant(c);
            default:
                return expr;
        }
    }

    private static function convertArgs(args : Array<FunctionArg>) : Void {
        for(arg in args) {
            switch(arg.type) {
                case TPath(p):
                    if(p.name == 'Float')
                        trace('Do conversion.'); 
                    if(p.name == 'Array')
                        trace('Do conversion.'); 
                default:
            }
        }
    }

    private static function convertReturn(args : Null<ComplexType>) : Void {

    }

    private static function convertCall(c : ExprDef) : Void {
    //    trace(c);
    }

    private static function convertConstant(c : Constant) : Expr {
        switch(c) {
            case CIdent(_ => 'Math'):
                return {
                    expr: EConst(CIdent('DualMath')),
                    pos: Context.currentPos()
                }
            default:
                return {
                    expr: EConst(c),
                    pos: Context.currentPos()
                }
        }
    }

    private static function makeDual() : Void {
        
    }
}
#end