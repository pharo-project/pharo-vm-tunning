# pharo-vm-tunning

I am a project to store all the tools to tune the Pharo VM to execute different work loads.

## Installation

```smalltalk
Metacello new
	baseline: 'VMTunning';
	repository: 'github://pharo-project/pharo-vm-tunning';
	load
 ```

## GC Configuration

The GC Configuration class allows to read and set the parameters used by the garbage collector. 

It handles the following parameters: 

 - The Desired Eden size: this is the space where the young objects are created. This parameter (in bytes) should be lower than 64 Mbytes. Having bigger eden space it will reduce the number of scavenger operations and the tenuring of objects to the old space. This is good for applications creating a lot of short living objects. Setting this parameter requires the restart of the VM.

 - FullGCRatio, this is the ratio of growth of the old space that will trigger a full gc and compaction. This is a float number representing the percentage of growth (0 to 1.0). This is useful to extend if we have memory and we are allocating and nulling a lot of objects. I can be modified without restarting and my value is not stored in the image.

 - GrowthHeadroom: this is the size of the new segments the VM will allocate in the old space. When the VM requires memory to the OS it will perform request of this size. This value should be increase if the process will generate objects bigger or closer to this size, as maybe an object will require two requests to the OS. I can be modified without restarting and my value is not stored in the image.

 - ShrinkThreadshold: this is the maximum amount of free memory in the old space before executing a compactation and a release of memory to the operating system. I can be modified without restarting and my value is not stored in the image.

To use it is recommended to read the current configuration, modify it and write it to the VM

```
   GCConfiguration readFromVM
        fullGCRatio: 1.0;
        writeToVM.
```

An alternative is to apply the configuration during the execution of a block. 

```
   GCConfiguration readFromVM
        fullGCRatio: 1.0;
        activeDuring: [ "I do something important" ].
```     
