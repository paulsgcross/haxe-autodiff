class Main {
  static function main() {

    trace(Test.func1(2));
    trace(Test.func1_diff(2, 1.0));
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
 
public static function func1(x1 : Float) : Float {
    var z = Math.pow(x1, 3) + 2*Math.pow(x1, 2) - 4*x1 + 3;
    return z;
  }

}