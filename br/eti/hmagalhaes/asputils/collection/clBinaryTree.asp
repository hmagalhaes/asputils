<%

'* !!! Em desenvolvimento

'*
'* Implementation of a binary tree data structure.
'*
'* 1. Features
'* - It only works with objects, not primitive values.
'* - It is inspired in the Java Collections framework (just inspired!).
'*
'* 2. Mechanism:
'* It works with two sorting ways: natural order and comparator sorting.
'*
'* 2.1. Natural order
'* In order to use natural order, your object must implement a method with the
'* following signature:
'*     int compareTo(byref other)
'* This method must return the following:
'*     - some NEGATIVE int if your object is smaller than "other".
'*     - ZERO if both objects should be in the same position.
'*     - some POSITIVE int if your object is greater than "other".
'* If the object doesn't have the specified method, you'll have a runtime error
'* when you try to include it in the tree.
'*
'* 2.2. Comparator sorting
'* In this case the storable object doesn't need to implement anything special
'* because the sorting order will be defined by the external comparator.
'* The comparator can be any object that implements the following method:
'*     int compare(byref obj1, byref obj2)
'* The return rules are the following:
'*     - some NEGATIVE int if "obj1" is smaller than "obj2".
'*     - ZERO if both objects should be in the same position.
'*     - some POSITIVE int if "obj1" is greater than "obj2".
'* In order to use a comparator sorting, you need to define it using the
'* "setComparator" method. You should definitely do this before adding anything 
'* to the tree.
'*
'* @package br.eti.hmagalhaes.asputils.collection
'* @requires *no requirements*
'*
'* @since (2014.03.12)
'* @author hudson@hmagalhaes.eti.br
class clBinaryTree
	private root
	private comparator
	
	public NATURAL_ORDER
	public COMPARATOR_ORDER
	
	

	'* Public methods: Use these methods!
	'* ------------------------
	
	'* Allow you to set an Comparator to implement the elements sorting in 
	'* this tree.
	public sub setComparator(byref comparator)
		if (typeName(comparator) = "Nothing") then
			order = NATURAL_ORDER
		else
			order = COMPARATOR_ORDER
			set me.comparator = comparator
		end if
	end sub
	
	'* Offer an element to the tree, AKA add an element.
	public sub offer(byref e)
	end sub
	
	'* Peek the first element from the tree. It doesn't remove it, just return it.
	public function peek()
	end function
	
	'* Poll the first element from the tree. It return and also remove the
	'* element from the tree.
	public function poll()
	end function
	
		
	
	
	'* Private methods: Ignore it, it's just some weird code
	'* ------------------------
	private sub class_initialize()
		NATURAL_ORDER = 1
		COMPARATOR_ORDER = 2

		set root = nothing
		set comparator = nothing
		order = NATURAL_ORDER
	end sub
	
	
end class

%>