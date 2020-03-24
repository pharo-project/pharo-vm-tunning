"
I am a simple reification of the GC configuration of the VM. 
I can read my data with #readFromVM and write myself with #writeToVM.
Also I have nice constructors for configurations and also I can be applied during a block with #activeDuring:
"
Class {
	#name : #GCConfiguration,
	#superclass : #Object,
	#instVars : [
		'desiredEdenSize',
		'growthHeadroom',
		'shrinkThreadshold',
		'fullGCRatio'
	],
	#category : #GCTunning
}

{ #category : #'as yet unclassified' }
GCConfiguration class >> readFromVM [

	^ self new
		readFromVM;
		yourself.
]

{ #category : #'from-to-the-vm' }
GCConfiguration >> activeDuring: aBlock [ 

	| old |
	old := self writeToVM.
	aBlock ensure: [ old writeToVM ]
]

{ #category : #accessing }
GCConfiguration >> desiredEdenSize [
	^ desiredEdenSize
]

{ #category : #accessing }
GCConfiguration >> desiredEdenSize: anInteger [ 
	desiredEdenSize := anInteger
]

{ #category : #accessing }
GCConfiguration >> fullGCRatio [
	^ fullGCRatio 
]

{ #category : #accessing }
GCConfiguration >> fullGCRatio: aNumber [ 
	fullGCRatio := aNumber
]

{ #category : #accessing }
GCConfiguration >> growthHeadroom [
	^ growthHeadroom
]

{ #category : #accessing }
GCConfiguration >> growthHeadroom: anInteger [ 
	growthHeadroom := anInteger
]

{ #category : #'from-to-the-vm' }
GCConfiguration >> readFromVM [

	desiredEdenSize := Smalltalk vm parameterAt: 45.
	growthHeadroom := Smalltalk vm parameterAt: 25. 
	shrinkThreadshold := Smalltalk vm parameterAt: 24.
	fullGCRatio := Smalltalk vm parameterAt: 55.
]

{ #category : #accessing }
GCConfiguration >> shrinkThreadshold [
	^ shrinkThreadshold
]

{ #category : #accessing }
GCConfiguration >> shrinkThreadshold: anInteger [ 
	shrinkThreadshold := anInteger
]

{ #category : #'from-to-the-vm' }
GCConfiguration >> writeToVM [

	| oldConfig oldDesiredEdenSize oldGrowthHeadroom oldShrinkThreadshold oldFullGCRatio |
	oldConfig := self class new.

	oldDesiredEdenSize := Smalltalk vm parameterAt: 45 put: desiredEdenSize.
	oldGrowthHeadroom := Smalltalk vm parameterAt: 25 put: growthHeadroom. 
	oldShrinkThreadshold := Smalltalk vm parameterAt: 24 put: shrinkThreadshold.
	oldFullGCRatio := Smalltalk vm parameterAt: 55 put: fullGCRatio asFloat.
	
	^ oldConfig
		desiredEdenSize: oldDesiredEdenSize;
		growthHeadroom: oldGrowthHeadroom;
		shrinkThreadshold: oldShrinkThreadshold;
		fullGCRatio: oldFullGCRatio;
		yourself.
]
