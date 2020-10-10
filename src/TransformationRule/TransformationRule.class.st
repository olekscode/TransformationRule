Class {
	#name : #TransformationRule,
	#superclass : #Object,
	#instVars : [
		'antecedent',
		'consequent',
		'antecedentTree',
		'consequentTree'
	],
	#category : #TransformationRule
}

{ #category : #'as yet unclassified' }
TransformationRule class >> antecedent: anAntecedentString consequent: aConsequentString [
	^ self new
		antecedent: anAntecedentString;
		consequent: aConsequentString;
		yourself.
]

{ #category : #comparing }
TransformationRule >> = anObject [
	anObject class = self class
		ifFalse: [ ^ false ].
	
	^ anObject antecedent = antecedent and: [
		anObject consequent = consequent ]
]

{ #category : #accessing }
TransformationRule >> antecedent [
	^ antecedent
]

{ #category : #accessing }
TransformationRule >> antecedent: aString [
	antecedent := aString.
	antecedentTree := self parseExpression: antecedent.
]

{ #category : #accessing }
TransformationRule >> antecedentTree [
	^ antecedentTree
]

{ #category : #operations }
TransformationRule >> applyTo: aMethod [
	| node rule |
	node := aMethod parseTree.
	
	rule := RBParseTreeRewriter new 
		replaceTree: antecedentTree
		withTree: consequentTree;
		yourself.
	
	RecursionStopper during: [
		(rule executeTree: node)
			ifFalse: [ ^ Error signal: 'Failed to transform the method' ].
		"node replaceWith: rule tree. "
		Author 
			useAuthor: 'TransformationRule'
			during: [aMethod origin compile: node formattedCode classified: aMethod protocol].	
	]
]

{ #category : #accessing }
TransformationRule >> consequent [
	^ consequent
]

{ #category : #accessing }
TransformationRule >> consequent: aString [
	consequent := aString.
	consequentTree := self parseExpression: consequent.
]

{ #category : #accessing }
TransformationRule >> consequentTree [
	^ consequentTree
]

{ #category : #testing }
TransformationRule >> isValid [
	"Neither antecedent nor consequent can be empty"
	(antecedent isEmpty or: [ consequent isEmpty ])
		ifTrue: [ ^ false ].
		
	"Antecedent and consequent must be different"
	antecedent = consequent
		ifTrue: [ ^ false ].
		
	^ true
]

{ #category : #parsing }
TransformationRule >> parseExpression: aString [
	^ RBParser parseRewriteExpression: aString
]

{ #category : #printing }
TransformationRule >> printOn: aStream [
	aStream 
		nextPutAll: self class name;
		nextPutAll: ' (';
		nextPutAll: antecedent;
		nextPutAll: ' -> ';
		nextPutAll: consequent;
		nextPut: $).
]
