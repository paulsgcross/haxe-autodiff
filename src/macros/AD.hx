package macros;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;

class AD {
    macro static public function buildForward() : Array<Field> {
        return build(ForwardTrace.performForwardTrace);
    }
    
    macro static public function buildBackward() : Array<Field> {
        return build(ForwardTrace.performForwardTrace);
    }

    static function build(method : Function -> Function) : Array<Field> {
        var fields = Context.getBuildFields();
        var newFields : Array<Field> = new Array();

        for(field in fields) {
            newFields.push(field);
            switch(field.kind) {
                case FieldType.FFun(fn):
                    var newFn = processFunction(fn);
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

    static function processFunction(func : Function) : Function {
        var newExpressions : Array<Expr> = new Array();
        var expr = func.expr;
        var index = 0;
        
        var block = processExpressionBlock(expr, newExpressions);
                
        var newFunc : Function = {
            args: func.args,
            ret: func.ret,
            expr: block
        };

        return newFunc;
    }

    static function processExpressionBlock(block : Expr, newExpressions : Array<Expr>) : Expr {
        var index = 0;
        switch(block.expr) {
            case EBlock(expressions):
            for(expression in expressions) {
                var def = expression.expr;
                switch(def) {
                    case EFor(it, expr):
                        trace(expr.expr);
                    case EVars(vars):
                        var variable = vars[0];
                        switch(variable.expr.expr) {
                            case EConst(c):
                                switch(c) {
                                    case CFloat(f) | CInt(f):
                                        createNewDVarDeclaration(variable, newExpressions);
                                        newExpressions.push(expression);
                                        continue;
                                    default:
                                }
                            default:
                        }

                        createNewDVarDeclaration(variable, newExpressions);
                        createNewVarDeclaration(variable, newExpressions);
                    case EReturn(expr):
                        switch (expr.expr) {
                            case EConst(c):
                                newExpressions.push(expression);
                            default:
                                var name = 'ret' + Std.string(index++);
                                var newVar : Expr = Util.createNewVariable(name, expr);
                                
                                var returnExpr = {
                                    pos: Context.currentPos(),
                                    expr: EReturn(Util.createVariableReference(name))
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

        var newBlock = {
            pos: Context.currentPos(),
            expr: EBlock(newExpressions)
        }

        return newBlock;
    }

    static function createNewVarDeclaration(variable : Var, expressions : Array<Expr>) : Void {
        var newVarName = {
            pos: Context.currentPos(),
            expr: EConst(CIdent(variable.name))
        }

        var newVar = {
            pos: Context.currentPos(),
            expr: EConst(CFloat('0.0'))
        }

        var newExpr = {
            pos: Context.currentPos(),
            expr: EVars([{
                name: variable.name,
                isFinal: variable.isFinal,
                expr: newVar,
                type: variable.type
            }])
        };

        var newAssign = {
            pos: Context.currentPos(),
            expr: EBinop(Binop.OpAssign, newVarName, variable.expr)
        };

        expressions.push(newExpr);
        expressions.push(newAssign);
    }

    static function createNewDVarDeclaration(variable : Var, expressions : Array<Expr>) : Void {
        var newVarName = {
            pos: Context.currentPos(),
            expr: EConst(CIdent(variable.name))
        }

        var newDVar = {
            pos: Context.currentPos(),
            expr: EConst(CFloat('0.0'))
        }

        var newDExpr = {
            pos: Context.currentPos(),
            expr: EVars([{
                name: 'd'+variable.name,
                isFinal: variable.isFinal,
                expr: newDVar,
                type: variable.type
            }])
        };

        expressions.push(newDExpr);
    }
}
#end