<%

'*
'* An array wrapper for primitive variables storage.
'*
'* This implementation is intended to store anything that you don't need a "set"
'* keyword to work with. If you want to store Objects, use "clArrayList" instead.
'*
'* @package br.eti.hmagalhaes.asputils.collection
'* @requires *no requirements*
'*
'* @ver 0.1b (2011.09.01)
'* @author hudson@hmagalhaes.eti.br
'*
class clVarArrayList
	'* (array of primitives)
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
	'* @return (variant)
	'*
	public function getItem(i)
		getItem = itens(i)
	end function

	'*
	'* Replaces the value in the specified position
	'* @param val (variant) New value
	'* @param i (int) Item index
	'*
	public sub setItem(val, i)
		itens(i) = val
	end sub

	'*
	'* Adds a value to the list
	'* @param val (variant) The value to be added
	'*
	public sub add(val)
		call incList()
		call setItem(val, (size() - 1))
	end sub

	'*
	'* Inserts a value in the specified position. The current item in that
	'* position won't be replaced, it will be moved forward.
	'* @param val (variant) The value to be inserted
	'* @param i (int) The insertion position
	'*
	public sub insert(val, i)
		call incList()

		dim n
		for n = i+1 to size()-1
			call setItem(getItem(n-1), n)
		next
		call setItem(val, i)
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