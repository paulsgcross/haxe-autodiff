# haxe-autodiff
An automatic differentiation library for haxe that includes an operator overloading implementation and an experimental macro implementation.

## What does it do?
[Automatic differentiation](https://en.wikipedia.org/wiki/Automatic_differentiation) employs a powerful method for finding the derivative of a function at compile time. It is distinct from numerical and symbolic differentiation. This library provides that functionality through two methods: operator overloading with abstractions, and source code transformation using macros.

Beyond this, each implementation has a forward and reverse mode. The forward mode is useful for functions that calculate many output values from fewer input values, whereas the reverse mode is useful for calculating fewer output values to many input values.

## What's useful about it?
Automatic differentiation is useful for problems in mechanics (such as physics engines) and incredibly useful for machine learning. Anywhere you need to know the derivative of a function, autodiff can be employed to calculate that derivative quickly (as opposed to symbolic differentiation) and robustly (as opposed to numerical differentiation).

## How do I use it?
There are two implementations in this package. The first is operator overloading which is provided through Haxe Abstracts and is contained within the ```haxe.ad.duals``` packages. These packages also include dual versions of some Math functions.

### Operator overloading

For forward mode, we use Dual Numbers where the derivative value can be accessed with the 'd' property:
```haxe
import haxe.ad.duals.forward.DualNumber;
using haxe.ad.duals.forward.DualMath;

public static function main() {
    var x = new DualNumber(2.0, 1.0);
    var y = new DualNumber(2.0, 0.0);

    var f = x*x + x*y; 
    var dx = f.d; // 2*x + y;

    var f = x.sin();
    var dx = f.d; // x.cos();
}
```
where the first argument in DualNumber is the value of the variable and the second argument is the seed. Set the seed to 1.0 to calculate the derivative with respect to that variable. All other seeds must be set to 0. In order to calculate the gradient of the function, we would have to run this same series of calculations for each seed.

For reverse mode, we use a Wengert List to create our variables:
```haxe
import haxe.ad.duals.reverse.WengertList;
using haxe.ad.duals.reverse.Gradient;


class Variables {
  public static function main() {
    var list = new WengertList();

    var x = list.createVariable(2.0);
    var y = list.createVariable(0.5);
    var z = x*y + 3.0*x - 3.0*y;

    var gz = z.calculateGrad(); // [y + 3.0, x - 3.0]
    var dx = gz.wrt(x); // y + 3.0;
    var dy = gz.wrt(y); // x - 3.0;
  }
```

where calculateGrad returns the gradient of the given variable. Note that reverse mode is less optimised than forward mode at runtime.

These implementations readily work with code branching and for loops, like so:

```haxe
import haxe.ad.duals.forward.DualNumber;
using haxe.ad.duals.forward.DualMath;

public static function main() {
    var x = new DualNumber(2.0, 1.0);

    for(i in 1..4)
        x += i*x;
    
    var dx = x.d; // 1 + 2 + 3
}
```

As things stand, the operator overloading implementation should be more than enough for most use cases.

### Source code transformation

This is still in the experimental stage. Currently, forward mode differentiation works (including for loops and code branching sans switch statements) without any issues. Reverse mode only works with simple return expressions but will support loops and branching in the future. Source code transformation is preferred because it provides less runtime overhead and the Haxe compiler can optimise more easily.

For forward mode, build with the AutoDiff macro found in ```haxe.ad.compiler.macros```, and mark functions using the @:forwardDiff metadata:

```haxe
@:build(haxe.ad.compiler.macros.AutoDiff.build())
class Main {
    public static function main() {
        var x  = square(2.0, 2.0);
        var dx = squareDiff(2.0, 1.0, 2.0, 0.0);

        var out = new Vector(4);
        var r = rotate(Math.PI, out);
        var r = rotateDiff(Math.PI, out);
    }

    @:forwardDiff public static function square(x : Float, y : Float) : Float {
        return x*x + x*y + y*y;
    }

    @:forwardDiff public static function rotate(angle : Float, out : Vector<Float>) : Void {
        out[0] = Math.cos(angle);
        out[1] = Math.sin(angle);
        out[2] = Math.sin(-angle);
        out[3] = Math.cos(angle);
    }
}
```

For reverse mode, build with the AutoDiff as before but instead use the @:reverseDiff metadata:
```haxe
@:build(haxe.ad.compiler.macros.AutoDiff.build())
class Main {
    public static function main() {
        var grad = new Vector(2);
        var z  = square(2.0, 2.0);
        var dz = squareDiff(2.0, 2.0, grad);
        var dx = grad[0];
        var dy = grad[1];
    }

    @:reverseDiff public static function square(x : Float, y : Float) : Float {
        return x*x + x*y + y*y;
    }
}
```

## What next?
I want to get the source code transformation implementations fully fleshed out, plus any other potential optimisations. It would be nice to have a utility method to quickly handle Jacobian matrices and for a way to do higher order derivatives. Hopefully, for any physics engine that employs constraint functions, this library should make it trivial to implement them.