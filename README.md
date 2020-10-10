# TransformationRule

[![Build Status](https://travis-ci.org/olekscode/TransformationRule.svg?branch=master)](https://travis-ci.org/olekscode/TransformationRule)
[![Build status](https://ci.appveyor.com/api/projects/status/xyq3u97y1dg1br6f?svg=true)](https://ci.appveyor.com/project/olekscode/transformationrule)
[![Coverage Status](https://coveralls.io/repos/github/olekscode/TransformationRule/badge.svg?branch=master)](https://coveralls.io/github/olekscode/TransformationRule?branch=master)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/olekscode/TransformationRule/master/LICENSE)

## How to install it?

To install `TransformationRule`, go to the Playground (Ctrl+OW) in your [Pharo](https://pharo.org/) image and execute the following Metacello script (select it and press Do-it button or Ctrl+D):

```Smalltalk
Metacello new
  baseline: 'TransformationRule';
  repository: 'github://olekscode/TransformationRule/src';
  load.
```

## How to depend on it?

If you want to add a dependency on `TransformationRule` to your project, include the following lines into your baseline method:

```Smalltalk
spec
  baseline: 'TransformationRule'
  with: [ spec repository: 'github://olekscode/TransformationRule/src' ].
```

If you are new to baselines and Metacello, check out the [Baselines](https://github.com/pharo-open-documentation/pharo-wiki/blob/master/General/Baselines.md) tutorial on Pharo Wiki.

## How to use it?

```Smalltalk
rule := TransformationRule
  antecedent: '`@rec doWithIndex: `@arg'
  consequent: '`@rec withIndexDo: `@arg'.
```

```Smalltalk
rule := ('`@rec doWithIndex: `@arg' -> '`@rec withIndexDo: `@arg') asTransformationRule.
```

```Smalltalk
rule antecedent. "`@rec doWithIndex: `@arg"
rule consequent. "`@rec withIndexDo: `@arg"

rule antecedentAST. "RBMessageNode(`@rec doWithIndex: `@arg)"
rule consequentAST. "RBMessageNode(`@rec withIndexDo: `@arg)"

rule isValid. "true"
```
