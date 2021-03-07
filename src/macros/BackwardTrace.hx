package macros;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;

class BackwardTrace {
    public static function performBackwardTrace(func : Function) : Function {
        return func;
    }
}

#end