Class {
	#name : #GCConfigurationTest,
	#superclass : #TestCase,
	#instVars : [
		'previousConfiguration'
	],
	#category : #GCTunning
}

{ #category : #running }
GCConfigurationTest >> setUp [

	super setUp.
	previousConfiguration := GCConfiguration readFromVM.
]

{ #category : #running }
GCConfigurationTest >> tearDown [

	previousConfiguration writeToVM.
	super tearDown
]

{ #category : #'tests - writing to the VM' }
GCConfigurationTest >> testDuringExecutionOfBlockChangesTheValues [

	| new old |
	new := GCConfiguration readFromVM.
	old := GCConfiguration readFromVM.

	new growthHeadroom: new growthHeadroom * 4.
	new shrinkThreadshold: new shrinkThreadshold * 4.	
	new fullGCRatio: new fullGCRatio * 4.
	
	new activeDuring: [  | current |
			current := GCConfiguration readFromVM.
			self assert: new growthHeadroom equals: current growthHeadroom.
			self assert: new shrinkThreadshold equals: current shrinkThreadshold.
			self assert: new fullGCRatio equals: current fullGCRatio ].
]

{ #category : #'tests - writing to the VM' }
GCConfigurationTest >> testDuringExecutionOfBlockRestoresTheValues [

	| new old current |
	new := GCConfiguration readFromVM.
	old := GCConfiguration readFromVM.

	new growthHeadroom: new growthHeadroom * 4.
	new shrinkThreadshold: new shrinkThreadshold * 4.	
	new fullGCRatio: new fullGCRatio * 4.
	
	new activeDuring: [ ].
	
	current := GCConfiguration readFromVM.
	self assert: old growthHeadroom equals: current growthHeadroom.
	self assert: old shrinkThreadshold equals: current shrinkThreadshold.
	self assert: old fullGCRatio equals: current fullGCRatio
]

{ #category : #'tests - reading from VM' }
GCConfigurationTest >> testReadingFromVMDesiredEdenSizeMatchesValue [

	| conf |
	conf := GCConfiguration readFromVM.
	self assert: conf desiredEdenSize equals: (Smalltalk vm parameterAt: 45). 
]

{ #category : #'tests - reading from VM' }
GCConfigurationTest >> testReadingFromVMFullGCRatioIsAFloat [

	| conf |
	conf := GCConfiguration readFromVM.
	self assert: conf fullGCRatio isFloat
]

{ #category : #'tests - reading from VM' }
GCConfigurationTest >> testReadingFromVMFullGCRatioMatchesValue [

	| conf |
	conf := GCConfiguration readFromVM.
	self assert: conf fullGCRatio equals: (Smalltalk vm parameterAt: 55). 
]

{ #category : #'tests - reading from VM' }
GCConfigurationTest >> testReadingFromVMGrowthHeadroomMatchesValue [

	| conf |
	conf := GCConfiguration readFromVM.
	self assert: conf growthHeadroom equals: (Smalltalk vm parameterAt: 25). 
]

{ #category : #'tests - reading from VM' }
GCConfigurationTest >> testReadingFromVMShrinkThreadsholdMatchesValue [

	| conf |
	conf := GCConfiguration readFromVM.
	self assert: conf shrinkThreadshold equals: (Smalltalk vm parameterAt: 24). 
]

{ #category : #'tests - reading from VM' }
GCConfigurationTest >> testReadingFromVMTenuringThresholdMatchesValue [

	| conf |
	conf := GCConfiguration readFromVM.
	self assert: conf tenuringThreshold equals: (Smalltalk vm parameterAt: 6)
]

{ #category : #'tests - writing to the VM' }
GCConfigurationTest >> testWritingReturnsTheOldConfigurationWithDesiredEdenSize [

	| conf old oldValue|
	conf := GCConfiguration readFromVM.
	oldValue := Smalltalk vm parameterAt: 45.
	
	conf desiredEdenSize: conf desiredEdenSize * 4.
	
	old := conf writeToVM.
	
	self assert: old desiredEdenSize equals: oldValue. 
]

{ #category : #'tests - writing to the VM' }
GCConfigurationTest >> testWritingReturnsTheOldConfigurationWithFullGCRatio [

	| conf old oldValue|
	conf := GCConfiguration readFromVM.
	oldValue := Smalltalk vm parameterAt: 55.
	
	conf fullGCRatio: conf fullGCRatio * 4.
	
	old := conf writeToVM.
	
	self assert: old fullGCRatio equals: oldValue. 
]

{ #category : #'tests - writing to the VM' }
GCConfigurationTest >> testWritingUpdatesDesiredEdenSize [

	| conf old oldValue|
	conf := GCConfiguration readFromVM.
	oldValue := Smalltalk vm parameterAt: 45.
	
	conf desiredEdenSize: conf desiredEdenSize * 4.
	
	old := conf writeToVM.
	
	self assert: conf desiredEdenSize equals: (Smalltalk vm parameterAt: 45). 
]

{ #category : #'tests - writing to the VM' }
GCConfigurationTest >> testWritingUpdatesFullGCRatio [

	| conf old |
	conf := GCConfiguration readFromVM.
	
	conf fullGCRatio: conf fullGCRatio * 4.
	
	old := conf writeToVM.
	
	self assert: conf fullGCRatio equals: (Smalltalk vm parameterAt: 55). 
]
