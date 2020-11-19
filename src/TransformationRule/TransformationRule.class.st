Class {
	#name : #TransformationRule,
	#superclass : #Object,
	#instVars : [
		'antecedent',
		'consequent',
		'antecedentTree',
		'consequentTree',
		'parseError'
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

{ #category : #'instance creation' }
TransformationRule class >> fromSton: stonReader [
	| rule |
	rule := super fromSton: stonReader.
	
	rule parseAntecedent.
	rule parseConsequent.
	
	^ rule
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
	self parseAntecedent.
]

{ #category : #accessing }
TransformationRule >> antecedentTree [
	^ antecedentTree
]

{ #category : #accessing }
TransformationRule >> antecedentTree: anObject [
	antecedentTree := anObject
]

{ #category : #operations }
TransformationRule >> applyTo: aMethod [
	| transformedCode |
	transformedCode := self transformedSourceCodeOf: aMethod.
	
	Author 
		useAuthor: 'TransformationRule'
		during: [ aMethod origin compile: transformedCode classified: aMethod protocol ].
]

{ #category : #testing }
TransformationRule >> canBeAppliedTo: aMethod [
	^ (self nodesMatchedByAntecedentIn: aMethod) isNotEmpty
]

{ #category : #accessing }
TransformationRule >> consequent [
	^ consequent
]

{ #category : #accessing }
TransformationRule >> consequent: aString [
	consequent := aString.
	self parseConsequent.
]

{ #category : #accessing }
TransformationRule >> consequentTree [
	^ consequentTree
]

{ #category : #accessing }
TransformationRule >> consequentTree: anObject [
	consequentTree := anObject
]

{ #category : #initialization }
TransformationRule >> initialize [
	super initialize.
	parseError := false.
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

{ #category : #testing }
TransformationRule >> nodesMatchedByAntecedentIn: aMethod [
	| matches searcher |
	
	matches := OrderedCollection new.
	searcher := RBParseTreeSearcher new.
	
	searcher
		matchesTree: antecedentTree
		do: [ :node :answer | matches add: (node -> answer) ].
		
	searcher executeTree: aMethod parseTree.
	
	^ matches
]

{ #category : #parsing }
TransformationRule >> parseAntecedent [
	antecedentTree := self parseExpression: antecedent.
]

{ #category : #parsing }
TransformationRule >> parseConsequent [
	consequentTree := self parseExpression: consequent.
]

{ #category : #parsing }
TransformationRule >> parseExpression: aString [
	^ RBParser
		parseRewriteExpression: aString
		onError: [ ^ nil ].
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

{ #category : #'ston persistence' }
TransformationRule >> stonOn: stonWriter [
	stonWriter writeObject: (self copy
		antecedentTree: nil;
		consequentTree: nil;
		yourself)
]

{ #category : #operations }
TransformationRule >> transformedSourceCodeOf: aMethod [
	| node rule |
	node := aMethod parseTree.
	
	rule := RBParseTreeRewriter new 
		replaceTree: antecedentTree
		withTree: consequentTree;
		yourself.
	
	RecursionStopper during: [
		(rule executeTree: node)
			ifFalse: [ ^ Error signal: 'Failed to transform the method' ] ].

	^ node formattedCode
]
