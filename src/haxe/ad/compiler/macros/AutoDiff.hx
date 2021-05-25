package haxe.ad.compiler.macros;

#if macro
import haxe.ds.StringMap;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.Field;
import haxe.macro.Expr.Function;
import haxe.macro.Expr.FieldType;

class AutoDiff {
    private static var _params : StringMap<String>;

    public static function buildForward() : Array<Field> {
        return build(ForwardMode.perform);
    }
    
    private static function build(method : Function -> Function) : Array<Field> {
        var fields = Context.getBuildFields();
        var newFields : Array<Field> = new Array();

        for(field in fields) {
            newFields.push(field);

            if(field.meta[0] == null)
                continue;
            
            if(field.meta[0].name != ':diff')
                continue;

            switch(field.kind) {
                case FieldType.FFun(fn):
                    _params = new StringMap();
                    var newField : Field = {
                        name: field.name + 'Diff',
                        access: field.access,
                        kind: FFun(method(fn)),
                        pos: Context.currentPos()

                    }
                    newFields.push(newField);
                default:
            }
        }

        return newFields;
    }  
    
    public static function checkParameter(e1 : Expr) : Bool {
        var def = e1.expr;
        switch(def) {
            case EConst(CIdent(f)):
                return _params.exists(f);
            default:
        }
        return false;
    }

    public static function addParameter(v : Var) : Bool {
        switch(v.type) {
            case TPath(p):
                if(p.name == 'Parameter')
                    _params.set(p.name, p.name);
                return true;
            default:
                return false;
        }
    }
}
#end