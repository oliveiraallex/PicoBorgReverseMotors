"
This module is designed to communicate with the PicoBorg Reverse
busNumber               I²C bus on which the PicoBorg Reverse is attached (Rev 1 is bus 0, Rev 2 is bus 1)
bus                     the smbus object used to talk to the I²C bus
i2cAddress              The I²C address of the PicoBorg Reverse chip to control
foundChip               True if the PicoBorg Reverse chip can be seen, False otherwise
printFunction           Function reference to call when printing text, if None ""print"" is used
"
Class {
	#name : #PicoBorgRev,
	#superclass : #PotPicoBorgRevMotors,
	#instVars : [
		'busNumber',
		'foundChip',
		'printFunction'
	],
	#category : #'PharoThings-Devices-PicoBorgReverseMotors'
}

{ #category : #initialization }
PicoBorgRev >> initialize [
		"Shared values used by this class"
    busNumber               := 1 .    "Check here for Rev 1 vs Rev 2 and select the correct bus"
    i2cAddress              := 16r44 . "I²C address, override for a different address"
    foundChip               := False.
    printFunction           := nil.
    i2cWrite                := nil.
    i2cRead                 := nil.
]

{ #category : #initialization }
PicoBorgRev >> writeCommand: aCommand data: aByte [
	"RawWrite(command, data)
	Sends a raw command on the I2C bus to the PicoBorg Reverse
	Command codes can be found at the top of PicoBorgRev.py, data is a list of 0 or more byte values
	Under most circumstances you should use the appropriate function instead of RawWrite"
	| rawOutput |
	rawOutput := aCommand asCharacter.
	
	
	
	i2cConnection read8BitsAt: rawOutput
]
