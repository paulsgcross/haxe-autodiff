package macros;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;

class AD {
    macro static public function build() : Array<Field> {
        var fields = Context.getBuildFields();
        var newFields : Array<Field> = new Array();
        for(field in fields) {
            newFields.push(field);
            switch(field.kind) {
                case FieldType.FFun(fn):
                    var newFn = processFunctionReturns(fn);
                    var newField : Field = {
                        name: field.name + "_diff",
                        access: field.access,
                        kind: FieldType.FFun(ForwardTrace.performForwardTrace(newFn)),
                        pos: Context.currentPos()
                    };
                    newFields.push(newField);
                default:
            }
        }

        return newFields;
    }

    static function processFunctionReturns(func : Function) : Function {
        var newExpressions : Array<Expr> = new Array();
        var expr = func.expr;
        var index = 0;
        switch(expr.expr) {
            case EBlock(exprs):
                for(expression in exprs) {
                    var def = expression.expr;
                    switch(def) {
                        case EReturn(expr):
                            switch (expr.expr) {
                                case EConst(c):
                                    newExpressions.push(expression);
                                default:
                                    var name = 'ret' + Std.string(index++);
                                    var newVar : Expr = Util.createNewVariable(name, expr);
                                    
                                    var returnExpr = {
                                        pos: Context.currentPos(),
                                        expr: EReturn({
                                            pos: Context.currentPos(),
                                            expr: EConst(CIdent(name))
                                        })
                                    };

                                    newExpressions.push(newVar);
                                    newExpressions.push(returnExpr);
                            }
                            
                        default:
                            newExpressions.push(expression);
                    }
                }
            default:
        }

        var newFunc : Function = {
            args: func.args,
            ret: func.ret,
            expr: {
                pos: Context.currentPos(),
                expr: EBlock(newExpressions)
            }
        };

        return newFunc;
    }

    

}
#end