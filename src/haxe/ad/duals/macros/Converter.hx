package haxe.ad.duals.macros;

#if macro
import haxe.macro.Expr.ComplexType;
import haxe.macro.Expr.FunctionArg;
import haxe.macro.*;
import haxe.macro.Expr.Field;
import haxe.macro.Expr.ExprDef;

final class Converter {
    public static function build() : Array<Field> {

        var fields = Context.getBuildFields();
        for(field in fields) {
            switch(field.kind) {
                case FFun(f):
                    trace('Converting... \n'); 

                    convertArgs(f.args);
                    propagateFunction(f.expr);
                    convertReturn(f.ret);
                default:
            }
        }
        return fields;
    }

    public static function propagateFunction(expr : Expr) {
        var def = expr.expr;
        switch(def) {
            case EBlock(exprs):
                for(expr in exprs) {
                    propagateFunction(expr);
                }
            case EBinop(op, e1, e2):
                propagateFunction(e1);
                propagateFunction(e2);
            case EVars(vars):
                for(variable in vars) {
                    propagateFunction(variable.expr);
                }
            case EWhile(_, expr, _), EFor(_, expr), EReturn(expr):
                propagateFunction(expr);
            case EConst(c):
                convertConstant(def);
            case ECall(expr, params):
                trace(expr);
                trace(params);
            default:
        }
    }

    public static function convertArgs(args : Array<FunctionArg>) : Void {
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

    public static function convertReturn(args : Null<ComplexType>) : Void {

    }

    public static function convertCall(c : ExprDef) : Void {
        trace(c);
    }

    public static function convertConstant(c : ExprDef) : Void {
        trace(c);
    }
}
#end