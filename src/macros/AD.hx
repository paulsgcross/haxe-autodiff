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
        var expr = func.expr;
        
        var block = processExpressionBlock(expr);
                
        var newFunc : Function = {
            args: func.args,
            ret: func.ret,
            expr: block
        };

        return newFunc;
    }

    static function processExpressionBlock(block : Expr) : Expr {
        var newExpressions : Array<Expr> = new Array();
        switch(block.expr) {
            case EBlock(expressions):
            for(expression in expressions) {
                var def = expression.expr;
                switch(def) {
                    case EFor(it, expr):
                        var newFor = Util.createFor(it, processExpressionBlock(expr));
                        newExpressions.push(newFor);
                    case EWhile(econd, e, normalWhile):
                        var newWhile = Util.createWhile(econd, processExpressionBlock(e), normalWhile);
                        newExpressions.push(newWhile);
                    case EIf(econd, eif, eelse):
                        var newWhile = Util.createIf(econd, processExpressionBlock(eif), eelse==null?null:processExpressionBlock(eelse));
                        newExpressions.push(newWhile);
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
                    case ECall(e1, params):
                        switch(e1.expr) {
                            case EField(e2, field):
                                switch(field) {
                                    case 'push':
                                        var index = 0;
                                        var newParams = new Array();
                                        for(param in params) {
                                            var newParam = handleInnerExpression('out' + Std.string(index++), param, newExpressions);
                                            newParams.push(newParam);
                                        }
                                        var returnExpr = {
                                            pos: Context.currentPos(),
                                            expr: ECall(e1, newParams)
                                        };
                                        newExpressions.push(returnExpr);
                                    default:
                                }
                            default:
                        }
                    case EReturn(expr):
                        switch (expr.expr) {
                            case EConst(c):
                                newExpressions.push(expression);
                            default:
                                var name = 'ret';
                                var returnExpr = {
                                    pos: Context.currentPos(),
                                    expr: EReturn(handleInnerExpression(name, expr, newExpressions))
                                };
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

    static function handleInnerExpression(name : String, expr : Expr, expressions : Array<Expr>) : Expr {
        var dname = 'd' + name;
        var ref = Util.createVariableReference(name);

        var newVar : Expr = Util.createNewVariable(name, {
            pos: Context.currentPos(),
            expr: EConst(CFloat('0.0'))
        });
        
        var newDVar : Expr = Util.createNewVariable(dname, {
            pos: Context.currentPos(),
            expr: EConst(CFloat('0.0'))
        });
        
        var newAssign = {
            pos: Context.currentPos(),
            expr: EBinop(Binop.OpAssign, ref, expr)
        };

        expressions.push(newVar);
        expressions.push(newDVar);
        expressions.push(newAssign);

        return ref;
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