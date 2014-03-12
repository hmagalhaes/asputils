<%

'*
'* A generic node, used in the nodes tree created by the clTagReader class.
'*
'* @package br.eti.hmagalhaes.asputil.tag
'*
'* @requires br.eti.hmagalhaes.util.collection.clArrayList
'*
'* @ver 0.2b (2011.08.17)
'* @author hudson@hmagalhaes.eti.br
'*
class clGenericNode
	'* Check the getters and setters methods for comments.
	private tagName '* (string)
	private innerSource '* (string)
	private attributes '* (clArrayList<clGenericNodeAttribute>)
	private children '* (clArrayList<clGenericNode>)
	private parent '* (clGenericNode)
	private hasAParent '* (boolean)
	private container '* (boolean)
	private textNode '* (boolean)
	private hasTag '* (boolean)
	private tagClosed '* (boolean)


	public tagReader_dump(0) '* (array of variant) IGNORE it. Used by the clTagReader class.
		'* 0: position in the source string, just after the node's opening tag.

	'*

	private sub class_initialize()
		call setAttributes(new clArrayList)
		call setChildren(new clArrayList)
		call setContainer(true)
		call clearParent()
		call setTextNode(false)
		call setHasTag(true)
		call setTagClosed(false)
	end sub

	'*

	'*
	'* Nodes's tag name.
	'* @return (String) Nodes's tag name.
	'*
	public function getTagName()
		getTagName = tagName
	end function

	'*
	'* Nodes's tag name.
	'* @param n (String) Nodes's tag name.
	'*
	public sub setTagName(n)
		tagName = n
	end sub

	'*
	'* Node's inner source string. What is between tags. In a DOM comparison, it
	'* would be the "innerHTML" property.
	'* @return (String) Node's inner source string.
	'*
	public function getInnerSource()
		getInnerSource = innerSource
	end function

	'*
	'* Node's inner source string. What is between tags. In a DOM comparison, it
	'* would be the "innerHTML" property.
	'* @return (String) Node's inner source string.
	'*
	public sub setInnerSource(t)
		innerSource = t
	end sub

	'*
	'* Identifies the node as a text node, which can not contain other tags, only
	'* an inner source string.
	'* Default: false
	'* @param t (boolean) Set as a text node?
	'*
	public sub setTextNode(t)
		textNode = t

		'* There's no use for this behaviour, yet
		'*if (t) then
		'*call setHasTag(false)
		'*end if
	end sub

	'*
	'* Identifies the node as a text node, which can not contain other tags, only
	'* an inner source string.
	'* Default: false
	'* @param t (boolean) Is this node a text node?
	'*
	public function isTextNode()
		isTextNode = textNode
	end function

	'*
	'* This node has identifier tags?
	'* The root node, created by the tag reader, and text nodes has no tag.
	'* Default: true
	'* @param h (boolean) Set as if this node has tags?
	'*
	public sub setHasTag(h)
		hasTag = h
	end sub

	'*
	'* This node has identifier tags?
	'* The root node, created by the tag reader, and text nodes has no tag.
	'* Default: true
	'* @return (boolean) Is this node has tags?
	'*
	public function getHasTag()
		getHasTag = hasTag
	end function

	'*
	'* The node's attributes list.
	'* E.g.: " <div class='classAttribute' id='idAttribute'> "
	'* @return (clArrayList<clGenericNodeAttribute>) Node's attributes list
	'*
	public function getAttributes()
		set getAttributes = attributes
	end function

	'*
	'* The node's attributes list.
	'* E.g.: " <div class='classAttribute' id='idAttribute'> "
	'* @param list (clArrayList<clGenericNodeAttribute>) Node's attributes list
	'*
	public function setAttributes(byref list)
		set attributes = list
	end function

	'*
	'* This node's children nodes.
	'* @return (clArrayList<clGenericNode>) Children nodes list.
	'*
	public function getChildren()
		set getChildren = children
	end function

	'*
	'* This node's children nodes.
	'* @return (clArrayList<clGenericNode>) Children nodes list.
	'*
	public function setChildren(byref list)
		set children = list
	end function

	'*
	'* Returns this node's parent node.
	'* To avoid checking with the slow function "TypeName", you can use the
	'* "hasParent" method.
	'* @return (clGenericNode) Nó pai.
	'*
	public function getParent()
		set getParent = parent
	end function

	'*
	'* Sets this node's parent node.
	'* Due to performance issues there's the following trick:
	'*     - The "setParent" method should be used when you don't know if the parent
	'*     to be setted, is an object or if it's a "Nothing" reference. It will
	'*     check the parameter with the "TypeName" function.
	'*     - The "setThisParent" should be used when you are certain that the parameter
	'*     is not a "Nothing" reference. It won't do a "TypeName" check.
	'*     - The "clearParent" should be used when you want to set this node's parent
	'*     to "Nothing".  It won't do a "TypeName" check.
	'* @param n (clGenericNode) Parent node to be setted.
	'*
	public sub setParent(byref p)
		if (TypeName(p) = "Nothing") then
			call clearParent()
		else
			call setThisParent(p)
		end if
	end sub

	'*
	'* Clears this node's parent node reference. It will become an orphan :(
	'* Due to performance issues there's the following trick:
	'*     - The "setParent" method should be used when you don't know if the parent
	'*     to be setted, is an object or if it's a "Nothing" reference. It will
	'*     check the parameter with the "TypeName" function.
	'*     - The "setThisParent" should be used when you are certain that the parameter
	'*     is not a "Nothing" reference. It won't do a "TypeName" check.
	'*     - The "clearParent" should be used when you want to set this node's parent
	'*     to "Nothing".  It won't do a "TypeName" check.
	'* @param n (clGenericNode) Parent node to be setted.
	'*
	public sub clearParent()
		set parent = nothing
		hasAParent = false
	end sub

	'*
	'* Sets this node's parent node.
	'* Due to performance issues there's the following trick:
	'*     - The "setParent" method should be used when you don't know if the parent
	'*     to be setted, is an object or if it's a "Nothing" reference. It will
	'*     check the parameter with the "TypeName" function.
	'*     - The "setThisParent" should be used when you are certain that the parameter
	'*     is not a "Nothing" reference. It won't do a "TypeName" check.
	'*     - The "clearParent" should be used when you want to set this node's parent
	'*     to "Nothing".  It won't do a "TypeName" check.
	'* @param n (clGenericNode) Parent node to be setted.
	'*
	public sub setThisParent(byref p)
		set parent = p
		hasAParent = true
	end sub

	'*
	'* Does this node has a parent node?
	'* ps.: Boolean check, no "TypeName" used.
	'* @return (boolean) Does this node has a parent node?
	'*
	public function hasParent()
		hasParent = hasAParent
	end function

	'*
	'* Indicates if this node had it's tag closed.
	'* It avoids that bad formated code, which contemplates non continer tags without
	'* the closing marker (eg.: "<br>" what should be "<br/>"), to get closed when
	'* a source code is generated by reading a nodes tree.
	'* Padrão: False
	'* @return (boolean) Is this node's tag closed?
	'*
	public function isTagClosed()
		isTagClosed = tagClosed
	end function

	'*
	'* Indicates if this node had it's tag closed.
	'* It avoids that bad formated code, which contemplates non continer tags without
	'* the closing marker (eg.: "<br>" what should be "<br/>"), to get closed when
	'* a source code is generated by reading a nodes tree.
	'* Padrão: False
	'* @param closed (boolean) Is this node's tag closed?
	'*
	public sub setTagClosed(closed)
		tagClosed = closed
	end sub

	'*
	'* Indicates if this node is a container, what can contain other nodes.
	'* (eg.: An HTML "<div>" tag is a container).
	'* @return (boolean) Is this node a container?
	'*
	public function isContainer()
		isContainer = container
	end function

	'*
	'* Sets if this node is a container, what can contain other nodes.
	'* (eg.: An HTML "<div>" tag is a container).
	'* @param c (boolean) Is this node a container?
	'*
	public sub setContainer(c)
		container = c
	end sub

	'*
	'* Gets a node's attribute by its name.
	'* If there are more than one attribute with the same name, only the first
	'* will be returned.
	'* @param name (string) Attribute's name to be searched.
	'* @return (clGenericNodeAttibute) Found attribute. If no attribute is found,
	'* it returns a "Nothing" reference.
	'*
	public function getAttributeByName(name)
		set getAttributeByName = getAttributeByName_array(name)(1)
	end function

	'*
	'* Gets a node's attribute by its name.
	'* If there are more than one attribute with the same name, only the first
	'* will be returned.
	'* Ps.: It's the same thing as "getAttributeByName" but it returns an array,
	'* so you can check it withou the "TypeName"...
	'*
	'* @param name (string) Attribute's name to be searched.
	'* @return (array) Two position array, where:
	'*     0: (boolean) Was the attribute found?
	'*     1: (clGenericNodeAttibute) Found attribute. If no attribute is found,
	'*     it returns a "Nothing" reference.
	'*
	public function getAttributeByName_array(name)
		dim i
		dim f : f = -1
		dim attrs : set attrs = getAttributes()
		while (i < attrs.size())
			if (attrs.getItem(i).getName() = name) then
				f = i
				i = attrs.size()
			else
				i = i + 1
			end if
		wend
		if (f > -1) then
			getAttributeByName_array = array(true, attrs.getItem(f))
		else
			getAttributeByName_array = array(false, nothing)
		end if
	end function

	'*
	'* Gets a node's attribute by its value.
	'* If there are more than one attribute with the same value, only the first
	'* will be returned.
	'* @param value (string) Attribute's value to be searched.
	'* @return (clGenericNodeAttibute) Found attribute. If no attribute is found,
	'* it returns a "Nothing" reference.
	'*
	public function getAttributeByValue(value)
		set getAttributeByValue = getAttributeByValue_array(value)(1)
	end function

	'*
	'* Gets a node's attribute by its value.
	'* If there are more than one attribute with the same value, only the first
	'* will be returned.
	'* Ps.: It's the same thing as "getAttributeByValue" but it returns an array,
	'* so you can check it withou the "TypeName"...
	'*
	'* @param value (string) Attribute's value to be searched.
	'* @return (array) Two position array, where:
	'*     0: (boolean) Was the attribute found?
	'*     1: (clGenericNodeAttibute) Found attribute. If no attribute is found,
	'*     it returns a "Nothing" reference.
	'*
	public function getAttributeByValue_array(value)
		dim i
		dim f : f = -1
		dim attrs : set attrs = getAttributes()
		while (i < attrs.size())
			if (attrs.getItem(i).getValue() = value) then
				f = i
				i = attrs.size()
			else
				i = i + 1
			end if
		wend
		if (f > -1) then
			getAttributeByValue_array = array(true, attrs.getItem(f))
		else
			getAttributeByValue_array = array(false, nothing)
		end if
	end function
end class

%>