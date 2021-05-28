package haxe.ad.compiler.macros.reverse;

#if macro
import haxe.macro.Expr.Function;
import haxe.macro.Expr;
import haxe.macro.Context;

class ForwardPass {
    public static function evaluate(expr : Expr, graph : Graph) : Node {
        var def = expr.expr;
        
        switch(def) {
            case EBinop(op, e1, e2):
                var node1 = evaluate(e1, graph);
                var node2 = evaluate(e2, graph);

                var idx = graph.nodes.length;
                var parent = {leftidx: node1.idx, rightidx: node2.idx};
                var name = 'w' + graph.nodes.length;
                var node = ReverseMode.createNode(idx, name, Expressions.createBinop(op, node1.ref, node2.ref), parent);
                graph.nodes.push(node);
                return node;
            case ECall(e, params):
                var newParams = [];
                for(param in params) {
                    newParams.push(param);
                }
                var node = evaluate(newParams[0], graph);
                newParams[0] = node.ref;

                var idx = graph.nodes.length;
                var parent = {leftidx: node.idx, rightidx: null};
                var name = 'w' + graph.nodes.length;
                var node = ReverseMode.createNode(idx, name, Expressions.createCall(e, newParams), parent);
                graph.nodes.push(node);
                return node;
            case EConst(c):
                switch(c) {
                    case CIdent(s):
                        var idx = graph.inputs.get(s);
                        if(idx != null) {
                            return graph.nodes[idx];
                        }
                    default:
                }
                
                var idx = graph.nodes.length;
                var name = 'w' + graph.nodes.length;
                var parent = {leftidx: null, rightidx: null};
                var node = ReverseMode.createNode(idx, name, Expressions.createConstant(c), parent);
                graph.nodes.push(node);
                return node;
            default:
                return null;
        }
    }

}
#end