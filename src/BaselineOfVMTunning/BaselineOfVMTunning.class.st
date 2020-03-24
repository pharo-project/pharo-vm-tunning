Class {
	#name : #BaselineOfVMTunning,
	#superclass : #Object,
	#category : #BaselineOfVMTunning
}

{ #category : #baselines }
BaselineOfVMTunning >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		spec package: 'GCTunning'
	]
]
