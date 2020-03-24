"
I am a simple reification of the GC configuration of the VM. 
I can read my data with #readFromVM and write myself with #writeToVM.
Also I have nice constructors for configurations and also I can be applied during a block with #activeDuring:

I handle the following parameters: 

 - The Desired Eden size: this is the space where the young objects are created. This parameter (in bytes) should be lower than 64 Mbytes. Having bigger eden space it will reduce the number of scavenger operations and the tenuring of objects to the old space. This is good for applications creating a lot of short living objects.

 - FullGCRatio, this is the ratio of growth of the old space that will trigger a full gc and compaction. This is a float number representing the percentage of growth (0 to 1.0). This is useful to extend if we have memory and we are allocating and nulling a lot of objects. 

 - GrowthHeadroom: this is the size of the new segments the VM will allocate in the old space. When the VM requires memory to the OS it will perform request of this size. This value should be increase if the process will generate objects bigger or closer to this size, as maybe an object will require two requests to the OS. 

 - ShrinkThreadshold: this is the maximum amount of free memory in the old space before executing a compactation and a release of memory to the operating system.

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

{ #category : #'instance creation' }
GCConfiguration class >> forLargeObjectAllocation [

	"I create a configuration for executing the allocation of large objects as I expand the size of the new segments and the available space without executing a GC. Also I change the ratio to detect the execution of a Full GC, in this case the old space have to double itself before executing a FULL GC (grow a 100%)"

	^ self readFromVM
		growthHeadroom: 128 * 1024 * 1024;
		shrinkThreadshold: 100 * 1024 * 1024;
		fullGCRatio: 1.0;
		yourself.
]

{ #category : #'instance creation' }
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
