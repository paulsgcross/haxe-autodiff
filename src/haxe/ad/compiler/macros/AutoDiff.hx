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

    private static function build() : Array<Field> {
        var fields = Context.getBuildFields();
        var newFields : Array<Field> = new Array();

        for(field in fields) {
            newFields.push(field);

            if(field.meta[0] == null)
                continue;
            
            var method : Function -> Function = null;
            if(field.meta[0].name == ':forwardDiff') {
                method = ForwardMode.perform;
            } else if (field.meta[0].name == ':reverseDiff') {
                method = ReverseMode.perform;
            } else {
                continue;
            }

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
    
}
#end