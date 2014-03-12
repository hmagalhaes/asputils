<%

'*
'* An array wrapper for objects storage.
'*
'* This implementation is intended to store only objects, where you need to use
'* the "set" keyword to work with. If you want to store anything else, use
'* "clVarArrayList" instead.
'*
'* @package br.eti.hmagalhaes.asputils.collection
'* @requires *no requirements*
'*
'* @ver 0.1.1b (2001.09.01)
'* @author hudson@hmagalhaes.eti.br
'*
class clArrayList
	'* (array of object)
	private itens()
	'* (int)
	private leSize

	'*

	private sub class_initialize()
		setSize(0)
	end sub

	private sub class_terminate()
		call removeAll()
	end sub

	'*

	'*
	'* List size.
	'* ps.: It doesn't use "ubound", so there's no performance issue here.
	'* @return (int)
	'*
	public function size()
		size = leSize
	end function

	'*
	'* Gets the item in the specified position
	'* @param i (int) Item index
	'*
	public function getItem(i)
		set getItem = itens(i)
	end function

	'*
	'* Replaces the object in the specified position
	'* @param obj (Object) New object
	'* @param i (int) Item index
	'*
	public sub setItem(byref obj, i)
		set itens(i) = obj
	end sub

	'*
	'* Adds an object to the list
	'* @param obj (Object) The object to be added
	'*
	public sub add(byRef obj)
		call incList()
		call setItem(obj, (size() - 1))
	end sub

	'*
	'* Inserts an objects in the specified position. The current item in that
	'* position won't be replaced, it will be moved forward.
	'* @param obj (Object) The objects to be inserted
	'* @param i (int) The insertion position
	'*
	public sub insert(byref obj, i)
		call incList()

		dim n
		for n = i+1 to size()-1
			call setItem(getItem(n-1), n)
		next
		call setItem(obj, i)
	end sub

	'*
	'* Removes all list items
	'*
	public sub removeAll()
		dim i
		dim maxi : maxi = size() - 1
		for i = 0 to maxi
			set itens(i) = nothing
		next

		redim itens(0)
		call setSize(0)
	end sub

	'*
	'* Removes the item  in the specified position
	'* @param index (int) Item index
	'*
	public sub removeItem(index)
		if (index < size() - 1) then
			dim i
			dim j
			for i = index to size() - 2
				call setItem(getItem(i+1), i)
			next
		end if

		call setSize(size() - 1)
		redim preserve itens(size())
	end sub

	'* Private stuff -----------------------------------------------------------

	'*
	'* Increases list's size
	'*
	private sub incList()
		call setSize(size() + 1)
		redim preserve itens(size())
	end sub

	'*
	'* Updates the size flag
	'* @param s (int) Size.
	'*
	private sub setSize(s)
		leSize = s
	end sub
end class

%>