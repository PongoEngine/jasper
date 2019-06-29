Jasper
=================

[![Build Status](https://travis-ci.org/PongoEngine/jasper.svg?branch=master)](https://travis-ci.org/PongoEngine/jasper) [![Join the chat at https://gitter.im/pongo-jasper/community](https://badges.gitter.im/pongo-jasper/community.svg)](https://gitter.im/pongo-jasper/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Jasper is a port of Kiwi for developing GUIs in haxe.

## Example Usage
```haxe
var x = new Variable("x");
var y = new Variable("y");
var solver = new Solver();

solver.addConstraint(x <= y);
solver.addConstraint(y == x + 3.0);
solver.addConstraint((x == 10.0) | Strength.WEAK);
solver.addConstraint((y == 10.0) | Strength.WEAK);

solver.updateVariables();

trace("x = " + x.m_value); // x = 10
trace("y = " + y.m_value); // y = 13
```

## Motivation

The motivation to develop Jasper was to port a cassowary implementation to haxe. There were already two projects but one was not completely typed and the other did not use operator overloading for easy constraint creation. Jasper's goal is to be completely typed and also use the same operators for constraint development as the c++ implementation.

## Acknowledgments

https://github.com/nucleic/kiwi

https://github.com/alexbirkett/kiwi-java

https://github.com/Tw1ddle/haxe-kiwi

https://github.com/underscorediscovery/cassowary-hx

## License

Jasper is [MIT licensed](./LICENSE).