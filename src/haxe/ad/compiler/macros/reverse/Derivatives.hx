package haxe.ad.compiler.macros.reverse;

#if macro
import haxe.macro.Expr.Function;
import haxe.macro.Expr;
import haxe.macro.Context;

class Derivatives {
    public static function transformExpr(expr : Expr, graph : Graph) : Node {
        var def = expr.expr;
        
        switch(def) {
            case EBinop(op, e1, e2):
                var node1 = transformExpr(e1, graph);
                var node2 = transformExpr(e2, graph);

                var name = 'w' + graph.nodes.length;
                var node = ReverseMode.createNode(name, Expressions.createBinop(op, node1.ref, node2.ref));
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
                var name = 'w' + graph.nodes.length;
                var node = ReverseMode.createNode(name, Expressions.createConstant(c));
                graph.nodes.push(node);
                return node;
            default:
                return null;
        }
    }

    /*
    public static function transformExpr(expr : Expr, graph : Graph) : Node {
        var def = expr.expr;
        
        switch(def) {
            case EBinop(op, e1, e2):
                return transformBinop(op, e1, e2, graph);
            case EConst(c):
                var idx = graph.expressions.length;
                var const = Expressions.createConstant(c);
                var name = 'w' + idx;
                graph.expressions.push(createIntermediateVariable(name, const));
                graph.derivitives.push({left: null, leftidx: 0, right: null, rightidx: 0});
                return {name: name, expr: Expressions.createConstant(CIdent(name)), idx: idx};
            default:
                return null;
        }
    }
    
    private static function transformBinop(op : Binop, e1 : Expr, e2 : Expr, graph : Graph) : Node {
        var idx = graph.expressions.length;
        var parent1 = transformExpr(e1, graph);
        var parent2 = transformExpr(e2, graph);
        var binop = Expressions.createBinop(op, parent1.expr, parent2.expr);
        var name = 'w' + graph.expressions.length;
        graph.expressions.push(createIntermediateVariable(name, binop));

        graph.derivitives.push(createBinopDerivs(op, parent1, parent2));

        return {name: name, expr: Expressions.createConstant(CIdent(name)), idx: idx};
    }

    private static function createBinopDerivs(op : Binop, parent1 : Node, parent2 : Node) : Deriv {
        switch(op) {
            case OpMult:
                return {left: CIdent(parent2.name), leftidx: parent1.idx, right: CIdent(parent1.name), rightidx: parent2.idx};
            case OpAdd:
                return {left: CFloat('1.0'), leftidx: parent1.idx, right: CFloat('1.0'), rightidx: parent2.idx};
            case OpSub:
                return {left: CFloat('1.0'), leftidx: parent1.idx, right: CFloat('-1.0'), rightidx: parent2.idx};
            default:
                return {left: CIdent(parent2.name), leftidx: parent1.idx, right: CIdent(parent1.name), rightidx: parent2.idx};
        }
    }

    private static function createIntermediateVariable(name : String, expr : Expr) : Expr {
        return Expressions.createVars([Expressions.createVar(name, expr)]);
    }
    */
}
#end