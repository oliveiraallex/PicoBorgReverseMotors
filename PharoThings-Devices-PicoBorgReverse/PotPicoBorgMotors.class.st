"
Create a instance of a motor:

motorLeft := (RpiBoard3B current) installDevice: (PotPicoBorgMotors sideLeftorRight: 'left').
motorRight := (RpiBoard3B current) installDevice: (PotPicoBorgMotors sideLeftorRight: 'right').

To use the motor:

motorLeft power: 1.
motorRight power: -1.

power: 0     -> motor is stopped
power: 0.75  -> motor moving forward at 75% power
power: -0.5  -> motor moving reverse at 50% power
power: 1     -> motor moving forward at 100% power
"
Class {
	#name : #PotPicoBorgMotors,
	#superclass : #PotPicoBorgDevice,
	#instVars : [
		'forwardCommand',
		'reverseCommand',
		'getCommand'
	],
	#category : #'PharoThings-Devices-PicoBorgReverse'
}

{ #category : #accessing }
PotPicoBorgMotors class >> sideLeftorRight: aString [
	aString = 'left'
		ifTrue: [ ^ self new
				forward: COMMAND_SET_A_FWD reverse: COMMAND_SET_A_REV;
				getCommand: COMMAND_GET_A;
				name: 'Left motor';
				yourself ].
	aString = 'right'
		ifTrue: [ ^ self new
				forward: COMMAND_SET_B_FWD reverse: COMMAND_SET_B_REV;
				getCommand: COMMAND_GET_B;
				name: 'Right motor';
				yourself ]
]

{ #category : #initialization }
PotPicoBorgMotors >> calculatePWM: anNumber [
	"Receive an number between 1 and -1 to set the PWM value between 0 and 255"
	| pwm |
	anNumber < 0
		ifTrue: [ pwm := -1 * 255 * anNumber.
			pwm > 255
				ifTrue: [ pwm := 255 ] ]
		ifFalse: [ pwm := 255 * anNumber.
			pwm > 255
				ifTrue: [ pwm := 255 ] ].
	^ pwm
]

{ #category : #initialization }
PotPicoBorgMotors >> forward: aForwardCommand reverse: aReverseCommand [
	forwardCommand := aForwardCommand.
	reverseCommand := aReverseCommand
]

{ #category : #accessing }
PotPicoBorgMotors >> getCommand: aGetCommand [
	getCommand := aGetCommand
]

{ #category : #accessing }
PotPicoBorgMotors >> getSpeed [
	self readCommand: getCommand
]

{ #category : #initialization }
PotPicoBorgMotors >> initialize [
	super initialize
]

{ #category : #initialization }
PotPicoBorgMotors >> power: aNumber [
	"Receive a number between -1 and 1 to set the motor power
	power: 0     -> motor is stopped
	power: 0.75  -> motor moving forward at 75% power
	power: -0.5  -> motor moving reverse at 50% power
	power: 1     -> motor moving forward at 100% power"
	| pwmValue | 
	pwmValue := self calculatePWM: aNumber.
	aNumber > 0
		ifTrue: [ self writeCommand: forwardCommand data: pwmValue ]
		ifFalse: [ self writeCommand: reverseCommand data: pwmValue ]
]

{ #category : #initialization }
PotPicoBorgMotors >> stop [
	self power: 0
]
