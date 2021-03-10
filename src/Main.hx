import cpp.VirtualArray.NativeVirtualArray;
import haxe.macro.Expr.ImportMode;

class Main {
  static function main() {
    var out = new Array();
    Test.funcMult_diff(2.0, 1.0, out);
    trace(out);
  }

}

@:build(macros.AD.buildForward())
class Test {
  /*
  public static function func1(x : Float) : Float {
    if(x > 0.0) {
      return Math.pow(x, 3);
    } else {
      return Math.pow(x, 2);
    }
  }
*/
  public static function funcMult(x : Float, result : Array<Float>) : Void {
      result.push(Math.pow(x, 1));
      result.push(Math.pow(x, 2));
      result.push(Math.pow(x, 3));
  }
}
