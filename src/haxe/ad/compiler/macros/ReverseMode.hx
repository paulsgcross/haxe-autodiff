package haxe.ad.compiler.macros;


#if macro
import haxe.ds.Vector;
import haxe.macro.Expr.Function;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.ad.compiler.macros.reverse.*;

class ReverseMode {

    public static function perform(func : Function) : Function {
        var graph = {inputs: new Map(), nodes: []};

        handleInputVars(func.args, graph);
        forwardPass(func.expr, graph);
        
        var exprs = [];
        for(node in graph.nodes) {
            exprs.push(Expressions.createVars([Expressions.createVar(node.name, node.expr)]));
        }

        exprs.push(reversePass(graph, func.args.length));

        var newArgs = processArguments(func.args);
        var newExpr = Expressions.createBlock(exprs);
        
        return {
            args: newArgs,
            expr: newExpr,
            ret: null
        };
    }

    private static function processArguments(args : Array<FunctionArg>) : Array<FunctionArg> {
        var newArgs = [];
        for(arg in args) {
            newArgs.push(arg);
        }

        newArgs.push({
            name: 'gradient',
            type: TPath({
                pack: [],
                name: 'Vector',
                params: [TPType(TPath({
                    pack: [],
                    name: 'Float'
                }))]
            })
        });

        return newArgs;
    }

    private static function handleInputVars(args : Array<FunctionArg>, graph : Graph) {
        for(arg in args) {
            var idx = graph.nodes.length;
            var name = 'w' + idx;
            var parent = {leftidx: null, rightidx: null};
            var node = createNode(idx, name, Expressions.createConstant(CIdent(arg.name)), parent);
            graph.inputs.set(arg.name, idx);
            graph.nodes.push(node);
        }
    }

    public static function createNode(idx : Int, name : String, expr : Expr, parents : Parents) : Node {
        return {
            idx: idx,
            name: name,
            ref: Expressions.createConstant(CIdent(name)),
            expr: expr,
            parents: parents
        };
    }
    
    private static function reversePass(graph : Graph, count : Int) : Expr {
        var len = graph.nodes.length;
        var nodes = graph.nodes;
        
        var out = [];

        for(i in 0...len-1) {
            out.push(Expressions.createConstant(CFloat('0.0')));
        }
        out.push(Expressions.createConstant(CFloat('1.0')));

        for(i in 0...len) {
            var j = len - (i + 1);
            var node = nodes[j];
            var prev = out[j];
            var deriv = Derivatives.create(node.expr);
            
            var leftidx = node.parents.leftidx;
            var rightidx = node.parents.rightidx;

            if(leftidx != null) {
                if(deriv != null) {
                    var expr = Expressions.createBinop(OpMult, deriv.left, prev);
                    out[leftidx] = Expressions.createBinop(OpAdd, out[leftidx], expr);
                }
            }

            if(rightidx != null) {
                if(deriv != null) {
                    var expr = Expressions.createBinop(OpMult, deriv.right, prev);
                    out[rightidx] = Expressions.createBinop(OpAdd, out[rightidx], expr);
                }
            }

        }

        var result = [];
        for(i in 0...count) {
            var array = Expressions.createArray(
                Expressions.createConstant(CIdent('gradient')),
                Expressions.createConstant(CInt(Std.string(i)))
            );

            result.push(Expressions.createBinop(OpAssign, array, out[i]));
        }

        return Expressions.createBlock(result);
    }

    
    
    private static function forwardPass(expr : Expr, graph : Graph) : Void {
        var def = expr.expr;
        
        switch(def) {
            case EBlock(es):
                for(e in es) {
                    forwardPass(e, graph);
                }
            case EVars(vars):
                for(v in vars) {
                    forwardPass(v.expr, graph);
                }
            case EReturn(e):
                forwardPass(e, graph);
            case EBinop(_, _, _), EParenthesis(_), ECall(_, _), EConst(_):
                ForwardPass.evaluate(expr, graph);
            default:
        }
    }

}

#end