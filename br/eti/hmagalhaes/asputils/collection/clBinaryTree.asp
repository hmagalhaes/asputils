<%

'* !!! Em desenvolvimento


'* Implements a binary tree data structure.
'* It works with two sorting ways: natural order and comparator sorting.
'* 
class clBinaryTree
	private root
	
	

	'* Public methods: Use these methods!
	'* ------------------------
	
	'* Allow you to set an Comparator to implement the elements sorting in 
	'* this tree.
	
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
		set root = nothing
	end sub
	
	
end class

%>