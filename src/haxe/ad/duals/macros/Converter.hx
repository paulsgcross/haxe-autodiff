package haxe.ad.duals.macros;

import haxe.macro.Expr.Var;
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
            var meta = field.meta==null?null:field.meta[0];
            if(meta == null)
                continue;
            if(meta.name != ':makeDual')
                continue;

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

    private static function propagateFunction(in_expr : Expr) : Void {
        var def = in_expr.expr;
        switch(def) {
            case EBlock(exprs):
                for(expr in exprs) {
                    propagateFunction(expr);
                }
            case EBinop(_, e1, e2):
                propagateFunction(e1);
                propagateFunction(e2);
            case EVars(vars):
                for(variable in vars) {
                    trace(variable);
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
                in_expr.expr = convertConstant(c);
            default:
        }
    }

    private static function convertArgs(args : Array<FunctionArg>) : Void {
        for(arg in args) {
            switch(arg.type) {
                case TPath(p):
                    switch(p.name) {
                        case 'Array', 'Vector':
                            switch(p.params[0]) {
                                case TPType(t):
                                    switch(t) {
                                        case TPath(s):
                                            s.name = 'DualNumber';
                                            s.pack = ['haxe', 'ad', 'duals'];
                                        default:
                                    }
                                default:
                            }
                        case 'Float':
                            p.name = 'DualNumber';
                            p.pack = ['haxe', 'ad', 'duals'];
                    }
                default:
            }
        }
    }

    private static function convertReturn(args : Null<ComplexType>) : Void {
        switch(args) {
            case TPath(p):
                switch(p.name) {
                    case 'Float':
                        p.name = 'DualNumber';
                        p.pack = ['haxe', 'ad', 'duals'];
                        
                }
            default:
        }
    }

    private static function convertConstant(c : Constant) : ExprDef {
        switch(c) {
            case CIdent(_ => 'Math'):
                return EConst(CIdent('DualMath'));
            default:
                return EConst(c);
        }
    }
    /*
    private static function convertVar(variable : Var) : Var {
        var type = variable.type;
        switch(type) {
            case TPath(p):
                switch(p.name) {
                    case 
                }
        }
    }
    */
}
#end