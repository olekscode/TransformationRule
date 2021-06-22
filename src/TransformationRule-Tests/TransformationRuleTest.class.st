Class {
	#name : #TransformationRuleTest,
	#superclass : #TestCase,
	#category : #'TransformationRule-Tests'
}

{ #category : #'as yet unclassified' }
TransformationRuleTest >> mockMethod [

	(1 to: 10) doWithIndex: [ :each :i | each + i ]
]

{ #category : #tests }
TransformationRuleTest >> testAntecedent [
	| expression rule |
	expression := '`@rec doWithIndex: `@arg'.
	
	rule := TransformationRule new.
	rule antecedent: expression.
	
	self assert: rule antecedent equals: expression.
]

{ #category : #tests }
TransformationRuleTest >> testApplyTo [
	| oldCode newCode ruleOldToNew ruleNewToOld |
	
	oldCode := 'mockMethod

	(1 to: 10) doWithIndex: [ :each :i | each + i ]'.
	
	newCode := 'mockMethod

	(1 to: 10) withIndexDo: [ :each :i | each + i ]'.
	
	ruleOldToNew := ('`@rec doWithIndex: `@arg' -> '`@rec withIndexDo: `@arg') asTransformationRule.
	ruleNewToOld := ('`@rec withIndexDo: `@arg' -> '`@rec doWithIndex: `@arg') asTransformationRule.
	
	self assert: (self class >> #mockMethod) sourceCode equals: oldCode.
	
	ruleOldToNew applyTo: (self class >> #mockMethod).
	self assert: (self class >> #mockMethod) sourceCode equals: newCode.
	
	ruleNewToOld applyTo: (self class >> #mockMethod).
	self assert: (self class >> #mockMethod) sourceCode equals: oldCode.
]

{ #category : #tests }
TransformationRuleTest >> testAsString [
	| rule |
	
	rule := TransformationRule
		antecedent: '`@rec doWithIndex: `@arg'
		consequent: '`@rec withIndexDo: `@arg'.
	
	self assert: rule asString equals: '`@rec doWithIndex: `@arg -> `@rec withIndexDo: `@arg'.
]

{ #category : #tests }
TransformationRuleTest >> testConsequent [
	| expression rule |
	expression := '`@rec withIndexDo: `@arg'.
	
	rule := TransformationRule new.
	rule consequent: expression.
	
	self assert: rule consequent equals: expression.
]

{ #category : #tests }
TransformationRuleTest >> testEquality [
	| rule1 rule2 rule3 rule4 rule5 |
	
	rule1 := ('`@rec doWithIndex: `@arg' -> '`@rec withIndexDo: `@arg') asTransformationRule.
	
	"Same as rule1"
	rule2 := ('`@rec doWithIndex: `@arg' -> '`@rec withIndexDo: `@arg') asTransformationRule.
	
	"Different antecedent"
	rule3 := ('`@rec collect: `@arg' -> '`@rec withIndexDo: `@arg') asTransformationRule.
	
	"Different consequent"
	rule4 := ('`@rec doWithIndex: `@arg' -> '`@rec collect: `@arg') asTransformationRule.
	
	"Different class"
	rule5 := 0.
	
	self assert: rule2 equals: rule1.
	self deny: rule3 equals: rule1.
	self deny: rule4 equals: rule1.
	self deny: rule5 equals: rule1.
]

{ #category : #tests }
TransformationRuleTest >> testFromString [
	| rule expected |
	
	rule := TransformationRule fromString: '`@rec doWithIndex: `@arg -> `@rec withIndexDo: `@arg'.
	
	expected := TransformationRule
		antecedent: '`@rec doWithIndex: `@arg'
		consequent: '`@rec withIndexDo: `@arg'.
	
	self assert: rule equals: expected.
]

{ #category : #tests }
TransformationRuleTest >> testIsValid [
	| rule1 rule2 rule3 rule4 |
	
	"Should be valid"
	rule1 := ('`@rec doWithIndex: `@arg' -> '`@rec withIndexDo: `@arg') asTransformationRule.
	
	"Should be invalid because antecedent is empty"
	rule2 := ('' -> '`@rec withIndexDo: `@arg') asTransformationRule.
	
	"Should be invalid because consequent is empty"
	rule3 := ('`@rec doWithIndex: `@arg' -> '') asTransformationRule.
	
	"Should be invalid because antecedent and consequent are the same"
	rule4 := ('`@rec doWithIndex: `@arg' -> '`@rec doWithIndex: `@arg') asTransformationRule.
	
	self assert: rule1 isValid.
	self deny: rule2 isValid.
	self deny: rule3 isValid.
	self deny: rule4 isValid.
]

{ #category : #tests }
TransformationRuleTest >> testParseAntecedentTree [
	| expression rule expectedAST |
	expression := '`@rec doWithIndex: `@arg'.
	
	rule := TransformationRule new.
	rule antecedent: expression.
	
	expectedAST := RBMessageNode
		receiver: (RBPatternVariableNode named: '`@rec')
		selector: (RBSelectorNode value: #doWithIndex:)
		arguments: { RBPatternVariableNode named: '`@arg' }.
	
	self assert: rule parseAntecedentTree equals: expectedAST.
]

{ #category : #tests }
TransformationRuleTest >> testParseConsequentTree [
	| expression rule expectedAST |
	expression := '`@rec withIndexDo: `@arg'.
	
	rule := TransformationRule new.
	rule consequent: expression.
	
	expectedAST := RBMessageNode
		receiver: (RBPatternVariableNode named: '`@rec')
		selector: (RBSelectorNode value: #withIndexDo:)
		arguments: { RBPatternVariableNode named: '`@arg' }.
	
	self assert: rule parseConsequentTree equals: expectedAST.
]

{ #category : #tests }
TransformationRuleTest >> testSton [
	| originalObject stonString recoveredObject |
	
	originalObject := ('`@rec doWithIndex: `@arg' -> '`@rec withIndexDo: `@arg') asTransformationRule.
	
	stonString := STON toString: originalObject.
	recoveredObject := STON fromString: stonString.
	
	self assert: recoveredObject equals: originalObject.
]
