class Main {
  static function main() {
    trace(Test.func1(3));
    trace(Test.func1_diff(3));
    while(true) {

    }
  }

}

@:build(macros.AD.build())
class Test {
  public static function func1(x : Float) : Float {
    var z = 5*x + 6;
    var y = 1/(1+Math.exp(-z));
    var l = 0.5*((y - 0.5)*(y - 0.5));
    return l;
  }

  public static function func2(x1 : Float, x2 : Float) : Float {
    var z = x1*x2 + Math.sin(x1);
    return z;
  }
}