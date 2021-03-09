class Main {
  static function main() {

    trace(Test.func1(0));
    trace(Test.func1_diff(0, 1.0));
    while(true) {

    }
  }

}

@:build(macros.AD.buildForward())
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
    var z = 0.0;
    if(x1 > 0.5) {
      z = 2*x1;
    } else {
      z = 3*x1;
    }
    
    return z;
  }

}
