Class {
	#name : #BaselineOfTransformationRule,
	#superclass : #BaselineOf,
	#category : #BaselineOfTransformationRule
}

{ #category : #baselines }
BaselineOfTransformationRule >> baseline: spec [
	<baseline>
	spec for: #common do: [	
		"Packages"
		spec 
			package: 'TransformationRule';
			package: 'TransformationRule-Tests' with: [ spec requires: #('TransformationRule') ] ]
]
