class Main {
  static function main() {

    var dual1 = new DualNumber(3, 3);
    var dual2 = new DualNumber(3, 3);
    dual1.multiply(dual2);
    trace(dual1);

    trace(Test.func1(3, 3));
    trace(Test.func1_diff(3, 0, 3, 1));
    while(true) {

    }
  }

}

@:build(macros.AD.build())
class Test {
  /*
  public static function func1(x : Float) : Float {
    var z = 5*x + 6;
    var y = 1/(1+Math.exp(-z));
    var l = 0.5*Math.pow(y - 0.5, 2);
    return l;
  }
*/
  public static function func1(x1 : Float, x2 : Float) : Float {
    var z = x1/x2;
    return z;
  }
}