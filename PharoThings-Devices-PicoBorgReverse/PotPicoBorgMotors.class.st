"
Code based on the official PiBorg Pico Borg Reverse code:
https://www.piborg.org/blog/picoborg-reverse-examples
"
Class {
	#name : #PotPicoBorgMotors,
	#superclass : #PotI2CDevice,
	#classVars : [
		'COMMAND_ALL_OFF',
		'COMMAND_GET_A',
		'COMMAND_GET_B',
		'COMMAND_GET_DRIVE_FAULT',
		'COMMAND_GET_ENC_MODE',
		'COMMAND_GET_ENC_MOVING',
		'COMMAND_GET_ENC_SPEED',
		'COMMAND_GET_EPO',
		'COMMAND_GET_EPO_IGNORE',
		'COMMAND_GET_FAILSAFE',
		'COMMAND_GET_ID',
		'COMMAND_GET_LED',
		'COMMAND_MOVE_ALL_FWD',
		'COMMAND_MOVE_ALL_REV',
		'COMMAND_MOVE_A_FWD',
		'COMMAND_MOVE_A_REV',
		'COMMAND_MOVE_B_FWD',
		'COMMAND_MOVE_B_REV',
		'COMMAND_RESET_EPO',
		'COMMAND_SET_ALL_FWD',
		'COMMAND_SET_ALL_REV',
		'COMMAND_SET_A_FWD',
		'COMMAND_SET_A_REV',
		'COMMAND_SET_B_FWD',
		'COMMAND_SET_B_REV',
		'COMMAND_SET_ENC_MODE',
		'COMMAND_SET_ENC_SPEED',
		'COMMAND_SET_EPO_IGNORE',
		'COMMAND_SET_FAILSAFE',
		'COMMAND_SET_I2C_ADD',
		'COMMAND_SET_LED',
		'COMMAND_VALUE_FWD',
		'COMMAND_VALUE_OFF',
		'COMMAND_VALUE_ON',
		'COMMAND_VALUE_REV',
		'I2C_ID_PICOBORG_REV',
		'I2C_MAX_LEN',
		'I2C_SLAVE',
		'PWM_MAX'
	],
	#category : #'PharoThings-Devices-PicoBorgReverse'
}

{ #category : #'instance creation' }
PotPicoBorgMotors class >> defaultI2CAddress [
	^16r44
]

{ #category : #initialization }
PotPicoBorgMotors >> connect [
	super connect
]

{ #category : #initialization }
PotPicoBorgMotors >> initialize [
	"Constant values"
	I2C_SLAVE := 16r0703.
	PWM_MAX := 255.
	I2C_MAX_LEN := 4.
	I2C_ID_PICOBORG_REV := 16r15.
	COMMAND_SET_LED := 1.	"Set the LED status"
	COMMAND_GET_LED := 2.	"Get the LED status"
	COMMAND_SET_A_FWD := 3.	"Set motor 2 PWM rate in a forwards direction"
	COMMAND_SET_A_REV := 4.	"Set motor 2 PWM rate in a reverse direction"
	COMMAND_GET_A := 5.	"Get motor 2 direction and PWM rate"
	COMMAND_SET_B_FWD := 6.	"Set motor 1 PWM rate in a forwards direction"
	COMMAND_SET_B_REV := 7.	"Set motor 1 PWM rate in a reverse direction"
	COMMAND_GET_B := 8.	"Get motor 1 direction and PWM rate"
	COMMAND_ALL_OFF := 9.	"Switch everything off"
	COMMAND_RESET_EPO := 10.	"Resets the EPO flag, use after EPO has been tripped and switch is now clear"
	COMMAND_GET_EPO := 11.	"Get the EPO latched flag"
	COMMAND_SET_EPO_IGNORE := 12.	"Set the EPO ignored flag, allows the system to run without an EPO"
	COMMAND_GET_EPO_IGNORE := 13.	"Get the EPO ignored flag"
	COMMAND_GET_DRIVE_FAULT := 14.	"Get the drive fault flag, indicates faults such as short-circuits and under voltage"
	COMMAND_SET_ALL_FWD := 15.	"Set all motors PWM rate in a forwards direction"
	COMMAND_SET_ALL_REV := 16.	"Set all motors PWM rate in a reverse direction"
	COMMAND_SET_FAILSAFE := 17.	"Set the failsafe flag, turns the motors off if communication is interrupted"
	COMMAND_GET_FAILSAFE := 18.	"Get the failsafe flag"
	COMMAND_SET_ENC_MODE := 19.	"Set the board into encoder or speed mode"
	COMMAND_GET_ENC_MODE := 20.	"Get the boards current mode, encoder or speed"
	COMMAND_MOVE_A_FWD := 21.	"Move motor 2 forward by n encoder ticks"
	COMMAND_MOVE_A_REV := 22.	"Move motor 2 reverse by n encoder ticks"
	COMMAND_MOVE_B_FWD := 23.	"Move motor 1 forward by n encoder ticks"
	COMMAND_MOVE_B_REV := 24.	"Move motor 1 reverse by n encoder ticks"
	COMMAND_MOVE_ALL_FWD := 25.	"Move all motors forward by n encoder ticks"
	COMMAND_MOVE_ALL_REV := 26.	"Move all motors reverse by n encoder ticks"
	COMMAND_GET_ENC_MOVING := 27.	"Get the status of encoders moving"
	COMMAND_SET_ENC_SPEED := 28.	"Set the maximum PWM rate in encoder mode"
	COMMAND_GET_ENC_SPEED := 29.	"Get the maximum PWM rate in encoder mode"
	COMMAND_GET_ID := 16r99.	"Get the board identifier"
	COMMAND_SET_I2C_ADD := 16rAA.	"Set a new I2C address"
	COMMAND_VALUE_FWD := 1.	"I2C value representing forward"
	COMMAND_VALUE_REV := 2.	"I2C value representing reverse"
	COMMAND_VALUE_ON := 1.	"I2C value representing on"
	COMMAND_VALUE_OFF := 0	"I2C value representing off"
]

{ #category : #testing }
PotPicoBorgMotors >> isConnected [
	^ i2cConnection notNil
]

{ #category : #accessing }
PotPicoBorgMotors >> peripherals [
	"Subclasses should return collection of all pins and devices which they are configured with"
	
	^#()
]

{ #category : #communication }
PotPicoBorgMotors >> readCommand: aCommand [ 
	"RawRead(command, length, [retryCount])
	Reads data back from the PicoBorg Reverse after sending a GET command
	Command codes can be found at the top of PicoBorgRev.py, length is the number of bytes to read back
	The function checks that the first byte read back matches the requested command
	If it does not it will retry the request until retryCount is exhausted (default is 3 times)
	Under most circumstances you should use the appropriate function instead of RawRead"

	i2cConnection writeData: aCommand.
	^ i2cConnection read8BitsAt: I2C_MAX_LEN.
]

{ #category : #communication }
PotPicoBorgMotors >> writeCommand: aCommand data: anInteger [
	"RawWrite(command, data)
	Sends a raw command on the I2C bus to the PicoBorg Reverse
	Command codes can be found at the top of PicoBorgRev.py, data is a list of 0 or more byte values
	Under most circumstances you should use the appropriate function instead of RawWrite"

	i2cConnection write8BitsAt: aCommand data: anInteger
]
