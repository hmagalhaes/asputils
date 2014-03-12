<%

'*
'* A tag reader.
'*
'* Given a markup language source code (eg.: XML, XHTML, UBB), it will read the
'* string and generate a nodes tree, being each node relative to each valid tag
'* found in the source code string.
'*
'* The output nodes tree is similar to DOM, found on Internet browsers.
'*
'* @package br.eti.hmagalhaes.asputil.tag
'*
'* @requires clGenericNode
'* @requires clGenericNodeAttribute
'* @requires clTagReaderOptions
'* @requires br.eti.hmagalhaes.asputil.collection.clArrayList
'*
'* @ver 0.2b (2011.08.17)
'* @author hudson@hmagalhaes.eti.br
'*
class clTagReader
	private options '* (clTagReaderOptions) Reader's options


	'* Internal "Constants"
	private IDENTIFIER_TYPE_OPENING
	private IDENTIFIER_TYPE_CLOSING
	private IDENTIFIER_TYPE_HTML_COMMENT
	private IDENTIFIER_TYPE_XML
	private IDENTIFIER_TYPE_INVALID
	private IDENTIFIER_TYPE_DOCTYPE



	private sub class_initialize()
		IDENTIFIER_TYPE_INVALID = 0
		IDENTIFIER_TYPE_OPENING = 1
		IDENTIFIER_TYPE_CLOSING = 2
		IDENTIFIER_TYPE_HTML_COMMENT = 3
		IDENTIFIER_TYPE_XML = 4
		IDENTIFIER_TYPE_DOCTYPE = 5

		set options = new clTagReaderOptions
	end sub

	'*

	'*
	'* Reader's behavioural options
	'* @return (clTagReaderOptions) Options
	'*
	public function getOptions()
		set getOptions = options
	end function

	'*
	'* Reader's behavioural options
	'* @param opt (clTagReaderOptions) Options
	'*
	public sub setOptions(byref opt)
		set options = opt
	end sub

	'*
	'* Reads the specified string identifying valid tags which will be added to
	'* an objects tree as a node (clGenericNode).
	'*
	'* @return (clGenericNode) The root node of the generated nodes tree. If no
	'* tag is found, the root tree will still be returned, but it will have no
	'* children.
	'*
	public function read(src)
		dim lenSrc : lenSrc = len(src)

		'* Posição atual da leitura
		dim readPointer : readPointer = 1

		'* root node
		dim root : set root = new clGenericNode
		call root.setTagName("root")
		call root.setHasTag(false)
		if (options.getSaveNodesInnerSource()) then
			call root.setInnerSource(src)
		end if
		'* call root.setContainer(true) '* opção padrão

		dim currentNode : set currentNode = root
		dim textNode

		'* Posição na string fonte após último identificador encontrado
		'* Usado para identificarmos os nós de texto
		dim lastReading : lastReading = readPointer

		dim identifier
		while (readPointer < lenSrc)
			identifier = readIdentifier(src, readPointer) '* returns: (boolean) found, (boolean) opening,
			                                 '* (clGenericNode) node, (int) markerIni, (int) markerFim
			if (identifier(0)) then
				'* Texto anterior ao identificador encontrado.
				call addTextNode(src, lastReading, identifier(3), currentNode)

				if (identifier(1)) then
					'* identificador de abertura:

					currentNode.getChildren().add(identifier(2))
					call identifier(2).setThisParent(currentNode)

					if (identifier(2).isContainer()) then
						'* Se a tag encontrada é container, ela passa a ser a tag atual na leitura.
						set currentNode = identifier(2)
					end if
				elseif (currentNode.hasParent()) then
					'* identificador de fechamento.
					'* A condição impede que ultrapassemos o elemento "root".

					if (closeNode(currentNode, identifier, src)) then
						'* Trocamos a tag atual
						set currentNode = currentNode.getParent()
					end if
				end if

				readPointer = identifier(5) '* continua a leitura após o identificador encontrado
				lastReading = identifier(2).tagReader_dump(0) '* atualiza a posição da última leitura
			else
				readPointer = identifier(5) '* nennhum identificador encontrado
			end if
		wend

		'* Texto após última tag encontrada
		call addTextNode(src, lastReading, lenSrc, currentNode)

		set read = root
	end function

	'*
	'* Generantes an string visualization of the nodes structure from the
	'* indicated node.
	'* The resultant string is written on the Response object.
	'* @param node (clGenericNode) Structure root node.
	'*
	public sub writeStructure(byref node)
		call writeStructure_real(node, response)
	end sub

	'*
	'* Generantes an string visualization of the nodes structure from the
	'* indicated node.
	'* The resultant string is returned.
	'* @param node (clGenericNode) Structure root node.
	'*
	public function saveStructure(byref node)
		dim helper : set helper = new clTagReader_responseHelper
		call writeStructure_real(node, helper)
		saveStructure = helper.text
		set helper = nothing
	end function

	'*
	'* Writes to the Response object the resultant source code string of the
	'* specified nodes tree.
	'* @param node (clGenericNode) Nodes tree root node.
	'*
	public sub write(byref node)
		call write_real(node, response)
	end sub

	'*
	'* Writes to a string, that will be returned, the resultant source code string
	'* of the specified nodes tree.
	'* @param node (clGenericNode) Nodes tree root node.
	'* @return (string) Resultant source code string.
	'*
	public function save(byref node)
		dim helper : set helper = new clTagReader_responseHelper
		call write_real(node, helper)
		save = helper.text
		set helper = nothing
	end function

	'*
	'* Searches the specified nodes tree by nodes' attributes name/value.
	'* Ps.1: The root node is checked as well.
	'* Ps.2: The resultant list order is not specified.
	'* Ps.3: It is possible to make searches by attribute name, value or both.
	'*
	'* @param node (clGenericNode) Nodes tree root node.
	'* @param name (string) Attribute name which a node must have to be a match.
	'* Use null to ignore the attribute name and search only by value.
	'* @param value (string) Attribute value which a node must have to be a match.
	'* Use null to ignore the attribute value and search only by name.
	'*
	'* @return (clArrayList<clGenericNode>) Found nodes list.
	'*
	public function getNodesByAttribute(byref node, name, value)
		dim resultList : set resultList = new clArrayList
		call getNodesByAttribute_innerCode(node, name, value, true, resultList)
		set getNodesByAttribute = resultList
	end function

	'*
	'* Searches the specified nodes list by nodes' attributes name/value.
	'* Ps.1: The resultant list order is not specified.
	'* Ps.2: It is possible to make searches by attribute name, value or both.
	'*
	'* @param list (clArrayList<clGenericNode>) Nodes list to be searched.
	'* @param name (string) Attribute name which a node must have to be a match.
	'* Use null to ignore the attribute name and search only by value.
	'* @param value (string) Attribute value which a node must have to be a match.
	'* Use null to ignore the attribute value and search only by name.
	'*
	'* @return (clArrayList<clGenericNode>) Found nodes list.
	'*
	public function getNodesByAttribute_fromList(byref list, name, value)
		dim resultList : set resultList = new clArrayList
		dim i
		dim maxi : maxi = list.size() - 1
		for i = 0 to maxi
			call getNodesByAttribute_innerCode(list.getItem(i), name, value, false, resultList)
		next
		set getNodesByAttribute_fromList = resultList
	end function

	'*
	'* Search the specified nodes tree by nodes' tag name.
	'* Ps.1: The indicated node is checked as well, not only its children.
	'* Ps.2: The resultant list order is not specified.
	'*
	'* @param node (clGenericNode) Nodes tree root node.
	'* @param tagName (string) Tag name to be searched.
	'* @return (clArrayList<clGenericNode>) Found nodes list.
	'*
	public function getNodesByTagName(byref node, tagName)
		dim resultList : set resultList = new clArrayList
		call getNodesByTagName_innerCode(node, tagName, true, resultList)
		set getNodesByTagName = resultList
	end function

	'*
	'* Search the specified nodes list by nodes' tag name.
	'* Ps.1: The resultant list order is not specified.
	'*
	'* @param node (clArrayList<clGenericNode>) Nodes list to be searched.
	'* @param tagName (string) Tag name to be searched.
	'* @return (clArrayList<clGenericNode>) Found nodes list.
	'*
	public function getNodesByTagName_fromList(byref list, tagName)
		dim resultList : set resultList = new clArrayList
		dim i
		dim maxi : maxi = list.size() - 1
		for i = 0 to maxi
			call getNodesByTagName_innerCode(list.getItem(i), tagName, false, resultList)
		next
		set getNodesByTagName_fromList = resultList
	end function


	'*
	'* Private stuff..................................................
	'*

	'*
	'* Split an attributes string and return an attributes list.
	'* @param attrString (string) Attributes string.
	'* @return (clArrayList<clGenericNodeAttribute>) List of identified attributes.
	'*
	private function splitTagAttributes(byval attrString)
		'* ex.: de formatos de entrada
		'*   " cellpadding='0' cellspacing='0' border='1'"
		'*   " ='0' cellspacing="0" border='1'"

		dim attrs : set attrs = new clArrayList '* attributes

		attrString = trim(attrString)
		if (attrString <> "") then
			dim limiter, value, name
			dim equalsPos : equalsPos = 1
			dim i : i = 1
			dim lenAttrString : lenAttrString = len(attrString)

			if (options.getSafeLoop() < 1) then  '* sem checagem de safeLoop > mais rápido
				while i < lenAttrString
					call splitTagAttributes_innerCode(i, attrString, equalsPos _
							, limiter, value, name, lenAttrString, attrs)
				wend
			else  '* com checagem
				dim safe : safe = 0
				while i < lenAttrString and safe < options.getSafeLoop()
					call splitTagAttributes_innerCode(i, attrString, equalsPos _
							, limiter, value, name, lenAttrString, attrs)
					safe = safe + 1
				wend
			end if
		end if

		set splitTagAttributes = attrs
	end function

	'*
	'* Don't use this.
	'* It's part of the "splitTagAttributes" method.
	'*
	private sub splitTagAttributes_innerCode(byref i, byref attrString _
			, byref equalsPos, byref limiter, byref value _
			, byref name, byref lenAttrString, byref attrs)

		equalsPos = instr(i, attrString, options.getEqualsMarker(), 1)
		if (equalsPos > 0) then
			'* nome do atributo
			name = getAttributeName(attrString, equalsPos)

			if (name <> "") then
				dim leAttr : set leAttr = new clGenericNodeAttribute
				call leAttr.setName(name)

				'* Limitador de conteúdo do valor.
				limiter = getAttributeValueLimiter(attrString, equalsPos) '* returns: limiterChar, valuePos1, qtdCharsValue
				call leAttr.setLimiter(limiter(0))

				'* Valor do atributo
				call leAttr.setValue( getAttributeValue(attrString, limiter(1), limiter(2)) )

				'* Atributo ok.
				call attrs.add(leAttr)

				'* Próxima leitura será após valor/limitador
				i = limiter(1) + limiter(2) + len(limiter(0))
			else
				i = equalsPos + 1 '* Próxima leitura será após marcador de igual
			end if
		else
			i = lenAttrString
		end if
	end sub

	'*
	'* Reads and attribute's name from an attributes string upon an equals sign
	'* position.
	'* Having "cellpadding='0' cellspacing='1' border=0" the following would be
	'* attributes' names: cellpadding, cellspacing, border.
	'* @param attrString (string) Attributes string
	'* @param equalsPos (int) Equals sign position in the above string.
	'* @return (string) Attribute's name. If the indicated position is not valid,
	'* returns empty string.
	'*
	private function getAttributeName(attrString, equalsPos)
		dim name : name = ""

		dim pos : pos = instrRev(attrString, " ", equalsPos) '* Espaço em branco anterior ao nome > limitador
		if (pos <= 0)  then '* Limite será início da string
			pos = 1
		else
			pos = pos + 1 '* para que o recorte não pesque o espaço em branco
		end if

		if (equalsPos > pos) then '* deve haver ao menos um caractere entre o limitador e o igual
			name = trim(mid(attrString, pos, equalsPos - pos))
		end if

		getAttributeName = name
	end function

	'*
	'* Reads an attribute's value from an attributes string upon the value's limiters
	'* positions.
	'* Ps.:In the following string, the quotes would be the so said limiters: [ <font color="red"> ]
	'* @param attrString (string) Attributes string
	'* @param posBegin (int) Begining position of the value in the above string
	'* @param charsQtt (int) Quantity of chars between value limiters.
	'* @returns (string) Attribute's value.
	'*
	private function getAttributeValue(attrString, posBegin, charsQtt)
		if (charsQtt > 0) then
			getAttributeValue = mid(attrString, posBegin, charsQtt)
		else
			getAttributeValue = ""
		end if
	end function

	private function getAttributeValueLimiter(attrString, equalsPos)
		dim res(2)
		res(0) = "" '* Char do limitador
		res(1) = equalsPos + 1 '* Posição inicial do conteúdo entre os limitadores
		res(2) = 0 '* Qtd. chars q compõem o valor

		dim lenAttrString : lenAttrString = len(attrString)

		if (lenAttrString > equalsPos + 1) then '* Deve haver ao menos 1 caractere após o símbolo de igual
			dim pos

			dim limiter : limiter = mid(attrString, equalsPos + 1, 1) '* símbolo limitador
			if (limiter = """" or limiter = "'") then '* limitador válido
				if (lenAttrString >= equalsPos + 2) then '* Deve haver espaço para o limitador final
					pos = instr(equalsPos + 2, attrString, limiter, 1) '* limitador final
					if (pos > 0) then
						res(0) = limiter
						res(1) = equalsPos + 2
						res(2) = pos - res(1)
					end if
				end if
			else '* sem limitador > espaço em branco será considerado limitador, ou final da string
				pos = instr(equalsPos + 1, attrString, " ", 1)
				if (pos <= 0) then
					pos = lenAttrString + 1
				end if

				'*res(0) = "" '* resultado padrão
				'*res(1) = equalsPos + 1 '* resultado padrão
				res(2) = pos - res(1)
			end if
		end if

		getAttributeValueLimiter = res
	end function

	'* Helper da rotina getNodesByTagName
	'* @param searchChildren (boolean) True = Os filhos do nó devem ser rastreados?
	'*    Obs.: Utilize False, caso esteja analizando uma lista resultado de outra
	'*    busca, caso contrário, os nós filhos dos nós resultado entrarão na varredura.
	private sub getNodesByTagName_innerCode(byref node, tagName, searchChildren, byRef resultList)
		if (node.getTagName() = tagName) then
			call resultList.add(node)
		end if

		if (searchChildren) then
			dim i
			for i = 0 to node.getChildren().size() - 1
				call getNodesByTagName_innerCode(node.getChildren().getItem(i), tagName _
						, searchChildren, resultList)
			next
		end if
	end sub

	'* Helper da rotina getNodesByAttribute
	'* @param searchChildren (boolean) True = Os filhos do nó devem ser rastreados?
	'*    Obs.: Utilize False, caso esteja analizando uma lista resultado de outra
	'*    busca, caso contrário, os nós filhos dos nós resultado entrarão na varredura.
	private sub getNodesByAttribute_innerCode(byref node, name, value, searchChildren, byref resultList)
		dim nameok
		if (isnull(name)) then
			nameok = true
		else
			nameok = node.getAttributeByName_array(name)(0)
		end if

		dim valueok
		if (isnull(value)) then
			valueok = true
		else
			valueok = node.getAttributeByValue_array(value)(0)
		end if

		if (nameok and valueok) then
			call resultList.add(node)
		end if

		if (searchChildren) then
			dim i
			dim maxi : maxi = node.getChildren().size() - 1
			for i = 0 to maxi
				call getNodesByAttribute_innerCode(node.getChildren().getItem(i), name _
						, value, searchChildren, resultList)
			next
		end if
	end sub

	'*
	'* Adiciona ao "currentNode" um nó de texto, caso exista algum texto entre as
	'* posições indicadas.
	'* @param src (string) String fonte.
	'* @param pos1 (int) Posição inicial.
	'* @param pos1 (int) Posição final.
	'* @param node (clGenericNode) Nó, onde o "TextNode" deverá ser incluído, caso
	'* exista conteúdo.
	'*
	private sub addTextNode(src, pos1, pos2, byref node)
		if (pos1 < pos2) then
			dim txt : txt = mid(src, pos1, pos2 - pos1)
			dim ok : ok = true

			if (options.getEmptyTextNodesMode() <> options.EMPTY_TEXT_NODES_ORIGINAL) then
				dim tmp : tmp = trim(txt)
				if (tmp <> "") then
					tmp = replace(replace(replace(tmp _
							, chr(9), "") _
							, chr(10), "") _
							, chr(13), "")
				end if

				if (tmp = "") then
					if (options.getEmptyTextNodesMode() = options.EMPTY_TEXT_NODES_NORMALIZED) then
						txt = " "
					else '* EMPTY_TEXT_NODES_IGNORED  (caso algum novo modo seja incluído, deverá haver revisão aqui
						ok = false
					end if
				end if
			end if

			if (ok) then
				if (options.getNormalizeTextNodes()) then
					while (instr(txt, "  ") > 0)
						txt = replace(txt, "  ", " ")
					wend
				end if

				dim textNode : set textNode = new clGenericNode
				call textNode.setTagName("::TextNode::")
				call textNode.setInnerSource(txt)
				call textNode.setContainer(false)
				call textNode.setTextNode(true)
				textNode.tagReader_dump(0) = pos2 + 1

				call node.getChildren().add(textNode)
			end if
		end if
	end sub

	'*
	'* Tenta fechar o nó indicado com o determinado identificador.
	'* Caso o nó em questão seja container e o identificador seja válido, a string
	'* fonte interna do nó será preenchida a partir da string original indicada.
	'* Caso contrário, nada será feito.
	'*
	'* @param identifier (array) Array resultado da rotina "readIdentifier", onde:
	'*     0: (boolean) Identificador válido
	'*     1: (boolean) Identificador de abertura de nó
	'*     2: (clGenericNode) Nó carregado
	'*     3: (int) Posição do marcador de início do identificador na string fonte original
	'*     4: (int) Posição do marcador de finalização do identificador na string fonte original
	'* @return (boolean) True = Indica que o identificador é válido para fechar o nó.
	'*
	private function closeNode(byref node, identifier, src)
		if ( node.isContainer() and (node.getTagName() = identifier(2).getTagName()) ) then
			if (options.getSaveNodesInnerSource()) then
				call node.setInnerSource(mid( _
						src _
						, node.tagReader_dump(0) _
						, identifier(3) - node.tagReader_dump(0) ))
			end if
			call node.setTagClosed(true)
			closeNode = true
		else
			closeNode = false
		end if
	end function

	'* @return (array) Onde:
	'*     0: (boolean) Identificador válido
	'*     1: (boolean) Identificador de abertura de nó
	'*     2: (clGenericNode) Nó carregado
	'*     3: (int) Posição do marcador de início do identificador na string fonte original
	'*     4: (int) Posição do marcador de finalização do identificador na string fonte original
	'*     5: (int) Nova posição para o ponteiro de leitura.
	'*
	private function readIdentifier(src, readPointer)
		dim res : res = array(false, null, null, null, null, readPointer + 1)
		dim lenSrc : lenSrc = len(src)

		'* marcador inicial
		dim marker1 : marker1 = instr(readPointer, src, options.getTagMarkers()(0), 1)
		if (marker1 > 0 and (marker1 + 1) < lenSrc) then '* Descarta identificadores no final do fonte.

			'* Tipo de identificador. Definido pelo primeiro char após o marcador inicial.
			dim identifierType : identifierType = getIdentifierType(src, marker1)
			if (identifierType <> IDENTIFIER_TYPE_INVALID) then

				'* Identificador de abertura?
				dim isOpening : isOpening = ( _
						identifierType = IDENTIFIER_TYPE_OPENING _
						or identifierType = IDENTIFIER_TYPE_HTML_COMMENT _
						or identifierType = IDENTIFIER_TYPE_XML _
						or identifierType = IDENTIFIER_TYPE_DOCTYPE _
						)

				if (options.getIdentifyHTMLComments() and (identifierType = IDENTIFIER_TYPE_HTML_COMMENT)) then
					'* Tag de comentário HTML. Precisa de cuidado especial, pois não segue
					'* o formato padrão de tags com identificador de abertura e fechamento.

					'* result:
					res(0) = true
					res(1) = true
					set res(2) = loadHTMLComment(src, marker1)
					'*res(3) = marker1 '* não será lido
					'*res(4) = marker1 '* não será lido
					res(5) = res(2).tagReader_dump(0)
				else
					'* marcador final
					dim marker2 : marker2 = instr(marker1 + 1, src, options.getTagMarkers()(1), 1)

					'* Conteúdo entre os marcadores
					dim tagString : tagString = trim( mid(src, marker1 + 1, marker2 - (marker1 + 1)) )
					if (tagString <> "") then '* descarta coisas tipo: "</>", "<>" ou "<        >"
						dim node : set node = new clGenericNode

						dim blank : blank = 0
						if (isOpening) then '* Identificador de abertura?

							'* Node.container define se o nó pode conter outros nós.
							'* Tags como "<br/>" definem nós q não podem ter nós internos.
							if (identifierType = IDENTIFIER_TYPE_XML _
									or identifierType = IDENTIFIER_TYPE_DOCTYPE) then
								call node.setContainer(true)
							else
								if (options.getSlashMarker() = right(tagString, 1)) then '* <tagname />
									call node.setContainer(false)
									tagString = left(tagString, len(tagString) - 1)
								'*else
									'*call node.setContainer(true) '* config. padrão do node
								end if
							end if

							blank = firstBlank(tagString) '* Espaço em branco que divide nome de atributos
						else
							'* Ignorar a barra que define o identificador de fechamento
							tagString = right(tagString, len(tagString) - 1)
						end if

						'* Nome do nó/tag e atributos
						if (blank > 0) then
							call node.setTagName(left(tagString, blank - 1))
							call node.setAttributes( splitTagAttributes(right(tagString, len(tagString) - blank)) )
						else
							call node.setTagName(tagString)
							'*call node.setAttributes(null) * config. padrão do node
						end if

						node.tagReader_dump(0) = marker2 + 1 '* posição posterior ao identificador na string fonte

						'* result:
						res(0) = true
						res(1) = isOpening
						set res(2) = node
						res(3) = marker1
						res(4) = marker2
						res(5) = marker2 + 1
					end if
				end if
			end if
		end if

		readIdentifier = res
	end function

	'* @return (clGenericNode)
	private function loadHTMLComment(src, opening)
		'* Posição do identificador de fechamento
		dim closing : closing = instr(opening + 4, src, "-->", 1)

		'* Posição posterior ao comentário.
		dim after
		if (closing > 0) then
			after = closing + 3
		else
			after = len(src)
		end if

		dim node : set node = new clGenericNode
		'*call node.setInnerSource( mid(src, opening + 4, closing - (opening + 4)) )  '* Conteúdo do comentário
		'* Marcadores fazem parte da string, pois é considerado textnode.
		call node.setInnerSource( mid(src, opening, (closing + 3) - opening) )

		call node.setContainer(false)
		call node.setTagName("::HTMLComent::")
		call node.setTextNode(true) '* comentário é considerado como um nó de texto.
		node.tagReader_dump(0) = after  '* Posição após o identificador de fechamento

		set loadHTMLComment = node
	end function

	'*
	'* Verifica o tipo de identificador que temos na posição indicada.
	'* @param src (string) String fonte.
	'* @param markerPos (int) Posição do marcador inicial do identificador a verificar.
	'* @return (int) Tipo de tag. Verificar as "constantes" "IDENTIFIER_TYPE_"
	'*
	private function getIdentifierType(src, markerPos)
		dim lenSrc : lenSrc = len(src)
		dim leType : leType = IDENTIFIER_TYPE_INVALID

		if ((markerPos + 1) < lenSrc) then '* Descarta identificadores no final do fonte.
			dim first : first = mid(src, markerPos + 1, 1)

			if (not invalidChar(first)) then
				select case first
					case options.getSlashMarker()  '* </tagname
						if ((markerPos + 2) < lenSrc) then
							if (not invalidChar( mid(src, markerPos + 2, 1) )) then
								leType = IDENTIFIER_TYPE_CLOSING
							end if
						end if

					case "?"  '* <?xml
						if ((markerPos + 4) < lenSrc) then
							if (mid(src, markerPos + 2, 3) = "xml") then
								leType = IDENTIFIER_TYPE_XML
							end if
						end if

					case "!"  '* <!--
						if ((markerPos + 3) < lenSrc) then
							if (mid(src, markerPos + 2, 2) = "--") then
								leType = IDENTIFIER_TYPE_HTML_COMMENT
							end if
						end if

					case else  '* <tagname
						leType = IDENTIFIER_TYPE_OPENING
				end select
			end if
		end if

		getIdentifierType = leType
	end function

	'*
	'* Tenta carregar um identificador de abertura de tag na string "src" indicada.
	'* @param src (string) String fonte.
	'* @return (array) Onde:
	'*     0: (boolean) identificador válido?
	'*     1: (clGenericTag) tag
	'*     2: (int) posição do marcador inicial
	'*     3: (int) posição do marcador final
	'*
	private function readOpeningIdentifier(src)
		dim tagName
		dim res : res = array(false, nothing, null, null)

		dim marker1 : marker1 = instr(pointer, src, options.getTagMarkers()(0), 1) '* marcador inicial

		dim tagString : tagString = mid(src, marker1 + 1, 1) '* primeiro char após o marcador
		if (not invalidChar(tagString)) then
			dim marker2 : marker2 = instr(marker1 + 1, src, options.getTagMarkers()(1), 1) '* marcador final

			tagString = mid(src, marker1 + 1, marker2 - (marker1 + 1)) '* Conteúdo entre os marcadores
			dim blank : blank = firstBlank(tagString) '* char em branco

			dim tag : set tag = new clGenericTag

			'* Nome da tag e atributos
			if (blank > 0) then
				call tag.setIdentifier(left(tagString, blank))
				call tag.setAttributes( splitAttributes(right(tagString, len(tagString) - blank)) )
			else
				call tag.setIdentifier(tagString)
				call tag.setAttributes(null)
			end if

			res(0) = true
			set res(1) = tag
			res(2) = marker1
			res(3) = marker2
		end if

		readOpeningIdentifier = res
	end function

	'*
	'* Retorna a posição do primeiro caractere "vazio" da string. Entra como este
	'* caractere os seguintes: ESPAÇO_EM_BRANCO, TAB, CARRIAGE_RETURN, LINE_FEED
	'* @return (int) Se nenhum caractere encontrado retorna 0, caso contrário retorna
	'* a posição do mesmo.
	'*
	private function firstBlank(str)
		dim pos, i
		dim achou : achou = 0
		dim blankChars : blankChars = options.getBlankChars()
		for i = 0 to ubound(blankChars)
			pos = instr(1, str, blankChars(i))
			if (pos > achou) then
				achou = pos
			end if
		next

		firstBlank = achou
	end function

	'*
	'* Verifica se o caractere informado é um dos "chars inválidos" para nome de tag.
	'* Esta verificação é feita ao validar o identificador de abertura de uma tag
	'* onde deve ser verificado o primeiro caractere após o marcador de início
	'* do identificador.
	'* São exemplos: ESPAÇO_EM_BRANCO, TAB, CARRIAGE_RETURN, LINE_FEED, ">"
	'*
	private function invalidChar(c)
		invalidChar = (c = " " or c = chr(9) or c = chr(13) or c = chr(10) or c = ">")
	end function

	'*
	'* Gera uma string para visualização da estrutura de nós a partir do nó
	'* indicado pelo parâmetro.
	'* @param node (clGenericNode) Nó a exibir a estrutura.
	'*
	private sub writeStructure_real(byref node, byref leResponse)
		dim i

		leResponse.write "<ul>"
			leResponse.write "<li>TagName =&gt; " & node.getTagName() & "</li>"

			leResponse.write "<li>Attributes =&gt; <ul>"
				if (not isnull(node.getAttributes())) then
					dim attrs : set attrs = node.getAttributes()
					dim maxi : maxi = attrs.size() - 1
					dim a
					for i = 0 to maxi
						set a = attrs.getItem(i)
						leResponse.write "<li>" & a.getName() & "=" & a.getLimiter() & a.getValue() & a.getLimiter() & "</li>"
					next
				end if
			leResponse.write "</ul></li>"

			leResponse.write "<li>Children =&gt;"
			maxi = node.getChildren().size() - 1
			for i = 0 to maxi
				call writeStructure_real(node.getChildren().getItem(i), leResponse)
			next
			leResponse.write "</li>"

			leResponse.write "<li>InnerSource =&gt; <div class='innersource'>" _
					& server.HTMLEncode(node.getInnerSource()) & "</div></li>"

		leResponse.write "</ul>"
	end sub

	'*
	'*    Escreve (response.write) a string fonte resultado do nó indicado no parâmetro
	'* e todos os seus nós filhos.
	'*   Vale citar que em nós de texto, será escrita a sua string fonte interna
	'* (node.getInnerSource()) e para outros tipos de nós, ou seja, aqueles gerados
	'* a partir de tags identificadas, terão escrito apenas o código relativo à sua
	'* tag, uma vez que o seu "innerSource" está dentro de um nó de texto alocado
	'* como filho.
	'* @param node (clGenericNode) Nó a partir do qual deve ser gerada a string fonte.
	'*
	private sub write_real(byref node, byref leResponse)
		if (node.isTextNode()) then
			leResponse.write node.getInnerSource()
		else
			dim i, maxi, tmp, list

			if (node.getHasTag()) then
				leResponse.write options.getTagMarkers()(0) & node.getTagName()

				set list = node.getAttributes()
				maxi = list.size() - 1
				for i = 0 to maxi
					set tmp = list.getItem(i)
					leResponse.write " " & tmp.getName() & options.getEqualsMarker() & tmp.getLimiter() & tmp.getValue() & tmp.getLimiter()
					'* attributeName="attributeValue"
				next
				set tmp = nothing
				set list = nothing

				if (not node.isContainer()) then '* fechamento de tag no identificador de abertura
					leResponse.write options.getSlashMarker()
				end if
				leResponse.write options.getTagMarkers()(1)
			end if

			set list = node.getChildren()
			maxi = list.size() - 1
			for i = 0 to maxi
				call write_real(list.getItem(i), leResponse)
			next
			set list = nothing

			if (node.isTagClosed()) then '* identificador/tag de fechamento
				leResponse.write options.getTagMarkers()(0) & options.getSlashMarker() & node.getTagName() & options.getTagMarkers()(1)
			end if
		end if
	end sub
end class


'*
'* Just a helper for the clTagReader class
'*
'* @package br.eti.hmagalhaes.util.tag
'*
'* @requires *no requirements*
'*
'* @ver 0.1b (2011.08.16)
'* @author hudson@hmagalhaes.eti.br
'*
class clTagReader_responseHelper
	public text

	public sub write(t)
		text = text & t
	end sub
end class

%>