Class {
	#name : #TransformationRuleTest,
	#superclass : #TestCase,
	#category : #'TransformationRule-Tests'
}

{ #category : #tests }
TransformationRuleTest >> testAntecedent [
	| expression rule expectedAST |
	expression := '`@rec doWithIndex: `@arg'.
	
	rule := TransformationRule new.
	rule antecedent: expression.
	
	expectedAST := RBMessageNode
		receiver: (RBPatternVariableNode named: '`@rec')
		selector: (RBSelectorNode value: #doWithIndex:)
		arguments: { RBPatternVariableNode named: '`@arg' }.
	
	self assert: rule antecedent equals: expression.
	self assert: rule antecedentAST equals: expectedAST.
]

{ #category : #tests }
TransformationRuleTest >> testConsequent [
	| expression rule expectedAST |
	expression := '`@rec withIndexDo: `@arg'.
	
	rule := TransformationRule new.
	rule consequent: expression.
	
	expectedAST := RBMessageNode
		receiver: (RBPatternVariableNode named: '`@rec')
		selector: (RBSelectorNode value: #withIndexDo:)
		arguments: { RBPatternVariableNode named: '`@arg' }.
	
	self assert: rule consequent equals: expression.
	self assert: rule consequentAST equals: expectedAST.
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
