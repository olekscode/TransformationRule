Class {
	#name : #TransformationRule,
	#superclass : #Object,
	#instVars : [
		'antecedent',
		'consequent',
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
	antecedent := aString
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
	consequent := aString
]

{ #category : #testing }
TransformationRule >> hasParsingError [
	^ parseError
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
		matchesTree: self parseAntecedentTree
		do: [ :node :answer | matches add: (node -> answer) ].
		
	searcher executeTree: aMethod parseTree.
	
	^ matches
]

{ #category : #parsing }
TransformationRule >> parseAntecedentTree [
	^ self parseExpression: antecedent
]

{ #category : #parsing }
TransformationRule >> parseConsequentTree [
	^ self parseExpression: consequent
]

{ #category : #parsing }
TransformationRule >> parseExpression: aString [
	^ RBParser
		parseRewriteExpression: aString
		onError: [ 
			parseError := true.
			^ nil ].
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

{ #category : #operations }
TransformationRule >> transformedSourceCodeOf: aMethod [
	| node rule |
	node := aMethod parseTree.
	
	rule := RBParseTreeRewriter new 
		replaceTree: self parseAntecedentTree
		withTree: self parseConsequentTree;
		yourself.
	
	RecursionStopper during: [
		(rule executeTree: node)
			ifFalse: [ ^ Error signal: 'Failed to transform the method' ] ].

	^ node formattedCode
]
