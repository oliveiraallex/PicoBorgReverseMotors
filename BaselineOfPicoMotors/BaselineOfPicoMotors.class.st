Class {
	#name : #BaselineOfPicoMotors,
	#superclass : #BaselineOf,
	#category : #BaselineOfPicoMotors
}

{ #category : #baselines }
BaselineOfPicoMotors >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec package: 'PharoThings-Devices-PicoBorgReverse' ]
]
