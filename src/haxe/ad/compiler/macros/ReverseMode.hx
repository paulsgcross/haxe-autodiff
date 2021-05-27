package haxe.ad.compiler.macros;


#if macro
import haxe.ds.Vector;
import haxe.macro.Expr.Function;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.ad.compiler.macros.reverse.*;

class ReverseMode {

    // TODO: Add derivatives
    // TODO: Mark input arguments as first variables
    // TODO: Prevent re-definitions

    public static function perform(func : Function) : Function {
        var graph = {inputs: new Map(), nodes: []};

        handleInputVars(func.args, graph);
        forwardPass(func.expr, graph);
        
        var exprs = [];
        for(node in graph.nodes) {
            exprs.push(Expressions.createVars([Expressions.createVar(node.name, node.expr)]));
        }
        exprs.push(func.expr);
        var newArgs = processArguments(func.args);
        var newExpr = Expressions.createBlock(exprs);//reversePass(graph, newArgs.length-1);
        
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
            var name = 'w' + graph.nodes.length;
            var node = createNode(name, Expressions.createConstant(CIdent(arg.name)));
            graph.inputs.set(arg.name, graph.nodes.length);
            graph.nodes.push(node);
        }
    }

    public static function createNode(name : String, expr : Expr) : Node {
        return {name: name, ref: Expressions.createConstant(CIdent(name)), expr: expr, leftParent: 0, rightParent: 0};
    }

    /*
    private static function reversePass(graph : Graph, count : Int) : Expr {
        var len = graph.derivitives.length;
        var derivs = graph.derivitives;
        var exprs = graph.expressions;

        var out = new Vector<Expr>(len);
        for(i in 0...len) {
            out[i] = Expressions.createConstant(CFloat('0.0'));
        }
        
        out[len-1] = Expressions.createConstant(CFloat('1.0'));
        
        for(i in 0...len) {
            var j = len - (i + 1);
            var parents = derivs[j];
            var prev = out[j];
            
            if(parents.left != null) {
                var expr = Expressions.createBinop(OpMult, Expressions.createConstant(parents.left), prev);
                out[parents.leftidx] = Expressions.createBinop(OpAdd, out[parents.leftidx], expr);
            }

            if(parents.right != null) {
                var expr = Expressions.createBinop(OpMult, Expressions.createConstant(parents.right), prev);
                out[parents.rightidx] = Expressions.createBinop(OpAdd, out[parents.rightidx], expr);
            }
        }
        
        exprs.push(Expressions.createVars([Expressions.createVar('out0', out[0])]));
        exprs.push(Expressions.createVars([Expressions.createVar('out1', out[1])]));

        return Expressions.createBlock(exprs);
    }
    */
    private static function forwardPass(expr : Expr, graph : Graph) : Void {
        var def = expr.expr;
        
        switch(def) {
            case EBlock(es):
                var exprs = [];
                for(e in es) {
                    exprs.push(forwardPass(e, graph));
                }
            case EReturn(e):
                forwardPass(e, graph);
            case EBinop(_, _, _), ECall(_, _), EConst(_):
                Derivatives.transformExpr(expr, graph);
            default:
        }
    }

}

#end