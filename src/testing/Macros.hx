package testing;

class Macros {
    static function main() {
        
    }
}

@:build(haxe.ad.macros.AD.buildForward())
class Test {
  
  @:diff public static function funcMult(x : Float) : Float {
    return Math.cos(3*x);
  }

  public static function test(x : Float) : Float {
    return x;
  }

}
