class Main {
  static function main() {
    trace(Test.square(3, 3));
    trace(Test.square_diff(3, 3));
    while(true) {

    }
  }

}

@:build(macros.AD.build())
class Test {
  public static function square(x1 : Float, x2 : Float) : Float {
    var z = 5*x1 + 6;
    var y = 1/(1+Math.exp(-z));
    return z;
  }
}