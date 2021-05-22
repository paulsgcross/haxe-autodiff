package testing;

class Compiler {
    static function main() {
        
    }
}

@:build(haxe.ad.compiler.AD.buildForward())
class Test {
  
  @:diff public static function funcMult(x : Float) : Float {
    return Math.cos(3*x);
  }

  public static function test(x : Float) : Float {
    return x;
  }

}
