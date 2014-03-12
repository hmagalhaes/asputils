<%
'*
'* Configuration options for the clTagReader class.
'*
'* @package br.eti.hmagalhaes.asputil.tag
'*
'* @requires clGenericNode
'* @requires clGenericNodeAttribute
'* @requires br.eti.hmagalhaes.util.collection.clArrayList
'*
'* @ver 0.1b (2011.08.17)
'* @author hudson@hmagalhaes.eti.br
'*
class clTagReaderOptions
	'* Available options
	'* Check the getters and setters methods for comments.
	private tagNameList '* (array of string) It's still to be implemented.
	private safeLoop '* (int)
	private tagMarkers '* (array of string)
	private slashMarker '* (string)
	private equalsMarker '* (string)
	private blankChars '* (array of string)
	private identifyHTMLComments '* (boolean)
	private emptyTextNodesMode '* (int)
	private normalizeTextNodes '* (boolean)
	private saveNodesInnerSource '* (boolean)



	'* Approach modes to empty text nodes
	public EMPTY_TEXT_NODES_NORMALIZED '* Normalizes white spaces (a lot of white spaces together become only one)
	public EMPTY_TEXT_NODES_IGNORED '* Ignores the node. It is not added to the nodes tree.
	public EMPTY_TEXT_NODES_ORIGINAL '* Keep the text as it is.



	private sub class_initialize()
		EMPTY_TEXT_NODES_ORIGINAL = 0
		EMPTY_TEXT_NODES_IGNORED = 1
		EMPTY_TEXT_NODES_NORMALIZED = 2

		call setTagNameList(null)
		call setSafeLoop(0)
		call setTagMarkers2("<", ">")
		call setSlashMarker("/")
		call setEqualsMarker("=")
		call setBlankChars(array(" ", chr(9), chr(13), chr(10)))
		call setIdentifyHTMLComments(true)
		call setEmptyTextNodesMode(EMPTY_TEXT_NODES_NORMALIZED)
		call setNormalizeTextNodes(false)
		call setSaveNodesInnerSource(false)
	end sub

	'*

	'*
	'* It's still to be implemented.
	'* List of tag names that should be readed and included
	'* in the object tree. All other tags will be ignored and will be inside some
	'* text node.
	'* @param names (array of string)
	'*
	public sub setTagNameList(names)
		tagNameList = names
	end sub

	'*
	'* It's still to be implemented.
	'* List of tag names that should be readed and included
	'* in the object tree. All other tags will be ignored and will be inside some
	'* text node.
	'* @return (array of string)
	'*
	public function getTagNameList()
		getTagNameList = tagNameList
	end function

	'*
	'* Chars that marks the beginning and ending of a tag. E.g.: "<tagname>"
	'* Default: "<", ">"
	'* @return (array of string) Two position array with the beginning and the ending marker.
	'*
	public function getTagMarkers()
		getTagMarkers = tagMarkers
	end function

	'*
	'* Chars that marks the beginning and ending of a tag. E.g.: "<tagname>"
	'* Default: "<", ">"
	'* @param (array of string) Two position array with the beginning and the ending marker.
	'*
	public sub setTagMarkers(markers)
		tagMarkers = markers
	end sub

	'*
	'* Chars that marks the beginning and ending of a tag. E.g.: "<tagname>"
	'* Default: "<", ">"
	'* @param b (string) beginning marker
	'* @param e (string) Ending marker
	'*
	public sub setTagMarkers2(b, e)
		call setTagMarkers(array(b, e))
	end sub

	'*
	'* Set the tag markers to the UBB code style, what uses "[" and "]" instead
	'* of "<" and ">".
	'*
	public sub setTagMarkers_ubb()
		call setTagMarkers2("[", "]")
	end sub

	'*
	'* Slash char. It is used for tag closing identification. E.g.: "</tagname>"
	'* Default: "/".
	'* @return (string) Slash char.
	'*
	public function getSlashMarker()
		getSlashMarker = slashMarker
	end function

	'*
	'* Slash char. It is used for tag closing identification. E.g.: "</tagname>"
	'* Default: "/".
	'* @param marker (string) Slash char.
	'*
	public sub setSlashMarker(marker)
		slashMarker = marker
	end sub

	'*
	'* Enables the normalization of white spaces in not empty text nodes.
	'* E.g.: "Lorem      ipsum      dolor" will become "Lorem ipsum dolor".
	'* Default: false
	'* @param enabled (boolean) Enable the text nodes normalization?
	'*
	public sub setNormalizeTextNodes(enabled)
		normalizeTextNodes = enabled
	end sub

	'*
	'* Enables the normalization of white spaces in not empty text nodes.
	'* E.g.: "Lorem      ipsum      dolor" will become "Lorem ipsum dolor".
	'* Default: false
	'* @return (boolean) Is the text nodes normalization enabled?
	'*
	public function getNormalizeTextNodes()
		getNormalizeTextNodes = normalizeTextNodes
	end function

	'*
	'* Enabled/disables the HTML comments identification. A special beheaviour
	'* is needed because it doesn't use a common tag structure.
	'* Default: true
	'* @param enabled (boolean) Enable comments identification?
	'*
	public sub setIdentifyHTMLComments(enabled)
		identifyHTMLComments = enabled
	end sub

	'*
	'* HTML comments identification. A special beheaviour is
	'* needed because it doesn't use a common tag structure.
	'* Default: true
	'* @param enabled (boolean) Is comments identification enabled?
	'*
	public function getIdentifyHTMLComments()
		getIdentifyHTMLComments = identifyHTMLComments
	end function

	'*
	'* Defines how the reader should handle empty text nodes.
	'* Empty text nodes are those where only blank chars (blankChars option) are
	'* found within it.
	'* The available behaviours are defined by the "EMPTY_TEXT_NODES" prefixed
	'* "constants".
	'* Default: EMPTY_TEXT_NODES_NORMALIZED
	'* @param m (int) Empty text node mode
	'*
	public sub setEmptyTextNodesMode(m)
		emptyTextNodesMode = m
	end sub

	'*
	'* Defines how the reader should handle empty text nodes.
	'* Empty text nodes are those where only blank chars (blankChars option) are
	'* found within it.
	'* The available behaviours are defined by the "EMPTY_TEXT_NODES" prefixed
	'* "constants".
	'* Default: EMPTY_TEXT_NODES_NORMALIZED
	'* @param m (int) Empty text node mode
	'*
	public function getEmptyTextNodesMode()
		getEmptyTextNodesMode = emptyTextNodesMode
	end function

	'*
	'* Enables the saving of the inner string for all the nodes.
	'* This option applies only to non text nodes, because text nodes need to have
	'* have their inner source, it's their raison d'etre.
	'* Default: false
	'* @param enabled (boolean) Enable the inner source saving?
	'*
	public sub setSaveNodesInnerSource(enabled)
		saveNodesInnerSource = enabled
	end sub

	'*
	'* Enables the saving of the inner string for all the nodes.
	'* This option applies only to non text nodes, because text nodes need to have
	'* have their inner source, it's their raison d'etre.
	'* Default: false
	'* @param enabled (boolean) Is the inner source saving enabled?
	'*
	public function getSaveNodesInnerSource()
		getSaveNodesInnerSource = saveNodesInnerSource
	end function

	'*
	'* Debug control. It's used to limit the iterations number in some
	'* "while" iteration structures. Default: 0 (disabled control)
	'* @param iterations (int) Max number of iterations.
	'*
	public sub setSafeLoop(iterations)
		if (iterations < 1) then
			safeLoop = 0
		else
			safeLoop = iterations
		end if
	end sub

	'*
	'* Debug control. It's used to limit the iterations number in some
	'* "while" iteration structures. Default: 0 (disabled control)
	'* @return (int) Max number of iterations.
	'*
	public function getSafeLoop()
		getSafeLoop = safeLoop
	end function

	'*
	'* Equals sign char. It is used in tag attributes. E.g.: " attributeName='value' "
	'* Default: "=".
	'* @return (string) Equals sign char
	'*
	public function getEqualsMarker()
		getEqualsMarker = equalsMarker
	end function

	'*
	'* Equals sign char. It is used in tag attributes. E.g.: " attributeName='value' "
	'* Default: "=".
	'* @param e (string) Equals sign char
	'*
	public sub setEqualsMarker(e)
		equalsMarker = e
	end sub

	'*
	'* A list of chars, which will be treated as "white spaces" in the empty text
	'* nodes handling. More info on the "emptyTextNodesMode" option.
	'* Default: [WHITE SPACE], [TAB], [CARRIAGE RETURN], [LINE FEED]
	'* @return (array of string) List of blank chars.
	'*
	public function getBlankChars()
		getBlankChars = blankChars
	end function

	'*
	'* A list of chars, which will be treated as "white spaces" in the empty text
	'* nodes handling. More info on the "emptyTextNodesMode" option.
	'* Default: [WHITE SPACE], [TAB], [CARRIAGE RETURN], [LINE FEED]
	'* @param (array of string) List of blank chars.
	'*
	public sub setBlankChars(b)
		blankChars = b
	end sub
end class

%>