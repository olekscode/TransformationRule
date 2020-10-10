Extension { #name : #Association }

{ #category : #'*TransformationRule' }
Association >> asTransformationRule [
	^ TransformationRule antecedent: key consequent: value.
]
