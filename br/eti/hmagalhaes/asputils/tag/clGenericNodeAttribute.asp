<%

'*
'* A node attribute in a clGenericNode
'*
'* @package br.eti.hmagalhaes.asputil.tag
'*
'* @requires *no requirements*
'*
'* @ver 0.1b (2011.08.17)
'* @author hudson@hmagalhaes.eti.br
'*
class clGenericNodeAttribute
	'* Check the getters and setters methods for comments.
	private name '* (string)
	private value '* (string)
	private limiter '* (string)

	'*

	'*
	'* The attribute's name
	'* @return (String) Attribute's name
	'*
	public function getName()
		getName = name
	end function

	'*
	'* The attribute's name
	'* @param n (String) Attribute's name
	'*
	public sub setName(n)
		name = n
	end sub

	'*
	'* The attribute's value
	'* @return (String) Attribute's value
	'*
	public function getValue()
		getValue = value
	end function

	'*
	'* The attribute's value
	'* @param v (String) Attribute's value
	'*
	public sub setValue(v)
		value = v
	end sub

	'*
	'* The attribute's value limiter. E.g.: the quotes in ' attributename="value" '
	'* @return (String) Attribute's value limiter
	'*
	public function getLimiter()
		getLimiter = limiter
	end function

	'*
	'* The attribute's value limiter. E.g.: the quotes in ' attributename="value" '
	'* @param l (String) Attribute's value limiter
	'*
	public sub setLimiter(l)
		limiter = l
	end sub
end class

%>