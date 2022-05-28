#SingleInstance force
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; phpMyAdmin page from which you can view structure of a table
phpmyadmin_table_structure_URL =http://localhost/phpmyadmin/tbl_structure.php?db=myProject&table=name

; phpMyAdmin page from which you can view relationships of a table
phpmyadmin_table_relation_URL =http://localhost/phpmyadmin/tbl_relation.php?db=myProject&table=name

; project path in file system
project_path =C:\xampp\htdocs\myProject

; table name should usually be placed below. Put field name here if you want to unscaffold a field
; this name will be used for scaffolding and unscaffoldling
; if you are scaffolding make sure a table with this name exists in the database
table_or_field_name := snakeCase("business-types")

; press accent key, it is below Escape key on the keyboard
`:: scaffoldFiles()

; select text and press Ctrl + Shift + Accent to unscaffold
^+`:: goto, unscaffold

; shift + accent to output marker
; scaffolder will replace this marker
+`:: Send Â¿ value1 Â¿{Left 3}+{Left} ; output marker

; press Ctrl + Accent to output marker for repetitive injection
^`::
		Clipboard := """ " Clipboard " """
		Send ^v
	return

; Ctrl + Alt + x to exit
^!x:: ExitApp

#IfWinActive, ahk_class SciTEWindow ahk_exe SciTE.exe
F5::
	Send ^s
	Sleep 100
	Reload
return


modelName(){
	global singular, table_or_field_name
	singular := table_or_field_name 
}

scaffoldFiles(){
	global singular
	
	fetchDatabaseDesign()
		
	myTT(singular)
	plural := scaffoldModel("Â¿ valueCC2 Â¿")
	if(plural = "")
		myTT("plural not found")
	else{
		
		; **************
		; add here
		; **************
	
	}
	
	myTT("scaffold done")
}


	;~ `:: printUsingScaffold( "MA", 1, -1) ; merge all
	
	
	
	
	unscaffold:
		waitClipboard()
		
		content := Clipboard
		fetchDatabaseDesign()
		StringCaseSense, On
		
		cases =AT`tCC`tS`tSH`tC`tL`tU`tT
		StringSplit, cases, cases, `t
		
		Loop 10 {
			outer_index := A_Index
			
			Loop %cases0% {
				name := scaffoldModel("Â¿ value" cases%A_Index% outer_index " Â¿")
				content := StrReplace(content, name, "Â¿ value" cases%A_Index% outer_index " Â¿")
			}
		}

		StringCaseSense, Off
		
		clip_two := content
		
		StringReplace, content, content, `r, , All
		StringReplace, content, content, `", `"`", All
		
		content := RegExReplace(content, """( \w+ )""", "$1")
		content := encodeLinesAndTabs(content)
		Clipboard := content
	return
	
	; params
	; L = use last line
	; M = merge to clipboard
	; S = skip line
	; A = all lines
	; C = from Clipboard
	printUsingScaffold( params = "", nRows = 1, nColumns = -1, next = 1 ){
		global
		local row
		
		useLastLine := InStr(params, "L")
		mergeToClipboard := InStr(params, "M")
		skipLine := InStr(params, "S")
		allLines := InStr(params, "A")
		fromClipboard := InStr(params, "C")
		
		StringSplit, clipList, clipList, `n, `r
		if(allLines){
			;~ clipList_A_Index = 0
			nRows := clipList0 - clipList_A_Index + 1
		}
		
		if(useLastLine){
			clipList_A_Index := clipList0 - 1
		}
		

		switch++
		
		if(!InStr(scaffold_template, "Â¿ value"))
			scaffold_template=Â¿ value1 Â¿
		
		if(fromClipboard){
			row := replaceMarker()
		}else{
			Loop % nRows
			{
				thisRow := fetchRow(nColumns, 1, next)
				row .= thisRow
			}
		}
		
		if(skipLine)
			return

		StringReplace, row, row, % chr(254), `t, All
		StringReplace, row, row, % chr(255), `n, All

		Clipboard=
		
		Clipboard .= row
		;~ myTT(Clipboard)
		
		
		if(!mergeToClipboard){
			Sleep 100
			Send ^v
		}
	}
	
scaffoldFields(template, withID = 1){
	global clipList, scaffold_template, oldClipList, modelName, clipList_A_Index
	
	clipList := oldClipList
	
	if(withID)
		clipList := "id`tbigint(20)`t`t`t`n" clipList
	
	scaffold_template := template
	clipList_A_Index = 0
	ClipLoad()
	Clipboard=
	printUsingScaffold( "MA", 1, 5)
	return Clipboard
}
	
scaffoldModel(template){
	global
	
	value0=-1
	clipList := modelName
	scaffold_template := template
	clipList_A_Index = 0
	StringSplit, clipList, clipList, `n, `r
	ClipLoad()
	Clipboard=
	printUsingScaffold("M", 1, 2)
	return Clipboard
}

fetchRow(nColumns=-1, fillTemplate = 0, next = 1, isRecursiveRun = 0){
	global
	
	if(! next){
		value0 -= 2
		clipList_A_Index -= 2
	}
	
	if(clipCells0 = "" or clipCells0 = 0)
		ClipLoad()
	
	if(nColumns = -1)
		nColumns := clipCells0
	else if(nColumns = 0)
		nColumns := clipList0 - clipList_A_Index
	
	t := scaffold_template
	
	if(nColumns = "" or nColumns = 0)
		nColumns=1
	
	loop %nColumns%
	{
		result := fetchValue(0, 0, 1)
		if(result.status = "fail"){
			if(!isRecursiveRun){
				return fetchRow(nColumns, fillTemplate, next, 1)
			}
			break
		}
		
		if(fillTemplate){
			t := replaceMarker(result.value, t, A_Index)
		}
	}
	
	value0++
	StringReplace, t, t, Â¿ value0 Â¿, % value0, All
	
	return t
}

replaceMarker(replacement = "qpmz_default_never_used_by_anyone", hayStack = "qpmz_default_never_used_by_anyone", index = 1 ){
	global scaffold_template
	
	if(replacement = "qpmz_default_never_used_by_anyone")
		replacement := Clipboard
	if(hayStack = "qpmz_default_never_used_by_anyone")
		hayStack := scaffold_template

	value%index% := replacement
	valueC%index% := camelCase(value%index%)
	valueCC%index% := capitalCamelCase(value%index%)
	valueS%index% := snakeCase(value%index%)
	valueSH%index% := snakecasewithhyphen(value%index%)
	valueU%index% := capitalCase(value%index%)
	valueAT%index% := allTitleCase(value%index%)
	valueT%index% := titleCase(value%index%)
	valueL%index% := lowerCase(value%index%)
	
	StringReplace, hayStack, hayStack, Â¿ value%index% Â¿, % value%index%, All
	StringReplace, hayStack, hayStack, Â¿ valueC%index% Â¿, % valueC%index%, All
	StringReplace, hayStack, hayStack, Â¿ valueCC%index% Â¿, % valueCC%index%, All
	StringReplace, hayStack, hayStack, Â¿ valueS%index% Â¿, % valueS%index%, All
	StringReplace, hayStack, hayStack, Â¿ valueSH%index% Â¿, % valueSH%index%, All
	StringReplace, hayStack, hayStack, Â¿ valueU%index% Â¿, % valueU%index%, All
	StringReplace, hayStack, hayStack, Â¿ valueAT%index% Â¿, % valueAT%index%, All
	StringReplace, hayStack, hayStack, Â¿ valueT%index% Â¿, % valueT%index%, All
	StringReplace, hayStack, hayStack, Â¿ valueL%index% Â¿, % valueL%index%, All
	
	return hayStack
}

	
mergeDataTypesAndRelationships(dataTypes, relations){
	global singularToPlural, pluralToSingular
	StringSplit, dataTypes, dataTypes, `n, `r
	StringSplit, relations, relations, `n, `r
	fields =
	
	Loop %dataTypes0%
	{
		dataType := dataTypes%A_Index%
		StringSplit, dataType, dataType, `t
		fields := fields dataType
		
		relationFound := 0
		
		Loop %relations0%
		{
			relation := relations%A_Index%
			StringSplit, relation, relation, `t
			
			if(dataType1 = relation1){
				relationFound := 1
				
				singular := pluralToSingular[relation2]
				
				fields := fields "`t" singular "`t" relation2
				break
			}
		}
		
		if(!relationFound)
			fields := fields "`t" "`t"
		
		if(A_Index != dataTypes0)
			fields := fields "`n"
	}

	return fields
}

getDataTypesByHttp(){
	global
	
	name := scaffoldModel("Â¿ valueS2 Â¿")
	
	url := phpmyadmin_table_structure_URL
	url := RegExReplace( url, "&table=\w+", "")
	url := RegExReplace( url, "&$", "")
	url := url "&table=" name
	
	UrlDownloadToFile %url%, %A_ScriptDir%\table_info.html
	
	FileRead, table_info, %A_ScriptDir%\table_info.html
	
	table_info := RegExReplace(table_info, "\s+", " ")
	table_info := RegExReplace(table_info, ".*tablestructure(.*)fieldsForm_checkall.*", "$1")
	StringReplace, table_info, table_info, <tr, % chr(255), All
	StringSplit, row, table_info, % chr(255)

	table_info=
	
	Loop %row0%
	{
		if(A_Index >= 4 ){
			StringReplace, row%A_Index%, row%A_Index%, <td, % chr(255), All
			StringSplit, column, row%A_Index%, % chr(255)

			name := RegExReplace(column3, ").*for=""checkbox_row_.{1,2}"">[ ](\S*)[ ]*.*", "$1")
			dataType := RegExReplace(column4, ").*lang=""en"">[ ](\S*)[ ]*.*", "$1")
			nullable := RegExReplace(column7, ").*>(\S*)</td>", "$1")
			table_info := table_info name "`t" dataType "`t" nullable
			
			if(A_Index != row0 and name != "id")
				table_info := table_info "`n"
		}
	}
	
	return table_info
}
	
getRelationsByHttp(){
	global
	
	name := scaffoldModel("Â¿ valueS2 Â¿")
	
	url := phpmyadmin_table_relation_URL
	url := RegExReplace( url, "&table=\w+", "")
	url := RegExReplace( url, "&$", "")
	url := url "&table=" name
	
	UrlDownloadToFile %url%, %A_ScriptDir%\table_info.html
	
	FileRead, table_info, %A_ScriptDir%\table_info.html
	
	table_info := RegExReplace(table_info, "\\""", """")
	table_info := RegExReplace(table_info, "\\n", " ")
	table_info := RegExReplace(table_info, "\s+", " ")
	table_info := RegExReplace(table_info, ".*Foreign key constraints(.*)id=""ir_div"".*", "$1")
	StringReplace, table_info, table_info, <tr, % chr(255), All
	StringSplit, row, table_info, % chr(255)

	table_info=
	
	Loop %row0%
	{
		if(A_Index >= 4 and A_Index <= row0 - 2){
			StringReplace, row%A_Index%, row%A_Index%, <td, % chr(255), All
			StringSplit, column, row%A_Index%, % chr(255)

			name := RegExReplace(column4, ").*selected=""selected"">[ ](\S*)[ ]*.*", "$1")
			relatedTable := RegExReplace(column6, ").*selected=""selected"">[ ](\S*)[ ]*.*", "$1")
			table_info := table_info name "`t" relatedTable "`n"
		}
	}
	
	return table_info
}
	
fetchDatabaseDesign(){
	global modelName, oldClipList, singularToPlural, pluralToSingular, singular
	
	modelName()
	
	singularToPlural := {}
	singularToPlural["country"] := "countries"
	
	pluralToSingular := {}
	
	for index, value in singularToPlural
		pluralToSingular[value] := index
	
	result := singularToPlural[singular]
	if(result){
		plural := result
	}else{
		result := pluralToSingular[singular]
		if(result){
			plural := singular
			singular := result
		}else{
			plural := singular "s"
		}
	}
	
	modelName := singular "`t" plural
	
	dataTypes := getDataTypesByHttp()
	relations := getRelationsByHttp()
	oldClipList := mergeDataTypesAndRelationships(dataTypes, relations)

}

HasVal(haystack, needle) {
	if !(IsObject(haystack)) || (haystack.Length() = 0)
		return 0
	for index, value in haystack
		if (value = needle)
			return index
	return 0
}

capitalcase(source = "qpmz_default_never_used_by_anyone"){
	return genericWordCaseFormatter(source, " ", 3, 3)
}

alltitlecase(source = "qpmz_default_never_used_by_anyone"){
	return genericWordCaseFormatter(source, " ", 2, 2)
}

titlecase(source = "qpmz_default_never_used_by_anyone"){
	return genericWordCaseFormatter(source, " ", 2, 1)
}


lowerCase(source = "qpmz_default_never_used_by_anyone"){
	return genericWordCaseFormatter(source, " ", 1, 1)
}

snakeCaseWithHyphen(source = "qpmz_default_never_used_by_anyone"){
	return genericWordCaseFormatter(source, "-", 1, 1)
}


snakeCase(source = "qpmz_default_never_used_by_anyone"){
	return genericWordCaseFormatter(source, "_", 1, 1)
}


capitalCamelCase(source = "qpmz_default_never_used_by_anyone"){
	return genericWordCaseFormatter(source, "", 2, 2)
}


camelCase(source = "qpmz_default_never_used_by_anyone"){
	return genericWordCaseFormatter(source, "", 1, 2)
}

genericWordCaseFormatter(source = "qpmz_default_never_used_by_anyone", replaceWith:="", firstWordFormat = 1, otherWordsFormat = 1){
	if(source = "qpmz_default_never_used_by_anyone"){
		waitClipboard()
		source := Clipboard
		replaceClipboard=1
	}
	
	;~ source := RegExReplace(source, "\W+", " ")
	
	StringReplace, source, source, _, %A_Space%, All
	StringReplace, source, source, -, %A_Space%, All
	StringSplit, source, source, %A_Space%
	tempz=
	loop %source0%
	{
		if(A_Index = 1)	
			if(firstWordFormat = 1)
				StringLower, tempx, source%A_Index%
			else if(firstWordFormat = 2)
				StringUpper, tempx, source%A_Index%, T
			else if(firstWordFormat = 3)
				StringUpper, tempx, source%A_Index%
			else
				tempx := source%A_Index%
		else
			if(otherWordsFormat = 1)
				StringLower, tempx, source%A_Index%
			else if(otherWordsFormat = 2)
				StringUpper, tempx, source%A_Index%, T
			else if(otherWordsFormat = 3)
				StringUpper, tempx, source%A_Index%
			else
				tempx := source%A_Index%
		
		if(A_Index = 1)	
			tempz:= tempz tempx
		else
			tempz:= tempz replaceWith tempx
	}
	
	if(replaceClipboard=1)
		Clipboard := tempz
	
	return tempz
}

RemoveTT:
	SetTimer, RemoveTT, Off  ; i.e. the timer turns itself off here.
	ToolTip
	TT_showing:=0
return

MyTT(TT, loggingStyle = 0) {
	global TT_showing
	global Old_TT
	global TTStore
	global currWin
	global suspendClicks
	
	if(loggingStyle)
		TT := TT ": " %TT%
	
	if(TT_showing)
		TT=%TT%`n%Old_TT%

	TT_showing:=1
	t := SubStr(TT, 1, 500)
	t:= RegExReplace(t, "s)^((.*?\R){10}).*", "$1")

	ToolTip % t
	SetTimer, RemoveTT, 4000
	Old_TT:=TT
}

mergeClipboard(copy = 1, encodeAsSingleElement = 0, copyResult = 1)
{
	return waitClipboard(copy, 1, encodeAsSingleElement, copyResult)
}

waitClipboard(copy = 1, merge = 0, encodeAsSingleElement = 0, copyResult = 1)
{
	global clipList, clipList_A_Index
	
	Sleep 100
	
	if(copy = 1)
	{
		oldClipboard := Clipboard
		Clipboard=
		Send ^c
		Sleep 100
	}
	
	ClipWait, 0.5
	;~ Send {Esc}
	
	if !ErrorLevel
	{		
		temp := RegExReplace(Clipboard, "s)^((.*?\R){10}).*", "$1")
		
		if(encodeAsSingleElement)
		{
			StringReplace, Clipboard, Clipboard, `t, % chr(254), All
			StringReplace, Clipboard, Clipboard, `n, % chr(255), All
		}
		
		if(merge){
			if (clipList != "")
				clipList .= "`n" Clipboard
			else
				clipList := Clipboard
			
			StringSplit, clipList, clipList, `n, `r
			
			if(copyResult){
				output=
				loop % clipList0-clipList_A_Index {
					t := clipList_A_Index + A_Index
					if (output != "")
						output .= "`n" clipList%t%
					else
						output := clipList%t%
				}
				Clipboard := output
			}
		}
			
		myTT(temp)
		;~ Send {Esc}{Tab} 
	}
	else{
		MyTT("Clipboard could not be loaded")
		Clipboard := oldClipboard
	}
	
	return Clipboard
}


decodeLinesAndTabs(haystack, Start="", End=""){
	return encodeLinesAndTabs(haystack, Start, End, "", "", 1)
}

encodeLinesAndTabs(haystack, Start="", End="", afterStart="", beforeEnd="", reverse=0)
{
	if(Start != ""){
		StringReplace, haystack, haystack,%Start%,% Chr(250)
		StringSplit, haystack,haystack,% Chr(250)
	}else
		haystack2 := haystack
	
	if(End != ""){
		StringReplace,haystack2,haystack2, % End, % Chr(250)
		StringSplit, haystack2,haystack2,% Chr(250)
	}else
		haystack21 := haystack2
	
	
	if(reverse){
		StringReplace,haystack21,haystack21, ``n,`n, ALL
		StringReplace,haystack21,haystack21, ``r,`r, ALL
		StringReplace,haystack21,haystack21, ``t,`t, ALL
		StringReplace,haystack21,haystack21, ``:,`:, ALL
		StringReplace,haystack21,haystack21, ```;,`;, ALL
		StringReplace,haystack21,haystack21, ```,,`,, ALL
		StringReplace,haystack21,haystack21, ```%,`%, ALL
		StringReplace,haystack21,haystack21, ````,``, ALL
	}else{
		StringReplace,haystack21,haystack21,``, ````, ALL
		StringReplace,haystack21,haystack21,`n, ``n, ALL
		StringReplace,haystack21,haystack21,`r, ``r, ALL
		StringReplace,haystack21,haystack21,`t, ``t, ALL
		StringReplace,haystack21,haystack21,`,, ```,, ALL
		StringReplace,haystack21,haystack21,`:, ``:, ALL
		StringReplace,haystack21,haystack21,;, % "```;", ALL
		StringReplace,haystack21,haystack21,`%, ```%, ALL
	}
	
	haystack2:= haystack21 beforeEnd End haystack22

	if( !reverse and RegExMatch(haystack2, "^\s"))
		Start := Start "``" afterStart
	haystack:= haystack1 Start haystack2
	
	return haystack
}


ClipLoad(){
	global
	
	clipList_A_Index++
	clipCells_A_Index = 0
	
	;~ if(clipList0 = "")
	StringSplit, clipList, clipList, `n, `r
	if(clipList_A_Index > clipList0){
		clipList_A_Index := clipList0
		myTT("Reached end of list")
		clipLine := ""
		return 0
	}else{
		clipLine := clipList%clipList_A_Index%
		StringSplit, clipCells, clipLine, `t, `r`n
		return 1
	}
}


fetchValue(toClipboard = 0, skipBlanks = 0, next = 1, isRecursiveRun = 0){
	global clipCells_A_Index, clipCells0, clipList_A_Index
	status := "success"

	Loop {
		if(next)
			clipCells_A_Index++
		else
			clipCells_A_Index--
		
		if (clipCells_A_Index > clipCells0 or clipCells_A_Index < 1) {
			if(! isRecursiveRun){
				if(clipCells_A_Index < 1){
					clipList_A_Index -= 2
					success := ClipLoad()
					clipCells_A_Index := clipCells0 + 1
				}else
					success := ClipLoad()
				
				if(success)
					return fetchValue(toClipboard, skipBlanks, next, 1)
				status := "fail"
			}
			value := ""
			;~ status := "fail"
			break
		}
		
		value := clipCells%clipCells_A_Index%
		
		if(skipBlanks){
			if (RegExMatch(value, "\w"))
				break
		}else
			break
	}
	
	if(toClipboard){
		Clipboard := value
		myTT("Clipboard", 1)
		Sleep 100
	}

	return {value: value, status: status}
}

runSubScaffold( functionName, withID = 0, reverse = 0 ){
	global oldClipList
	
	if(withID)
		clipList := "id`tbigint(20)`t`t`t`n" oldClipList
	
	StringSplit, clipList, clipList, `n, `r
	output=
	
	Loop %clipList0%
	{
		field := clipList%A_Index%
		StringSplit, field, field, `t
		
		
		t := %functionName%( field1, field2, field3, field4, field5 )
		
		if( !reverse ){
			t := replaceMarker(field1, t, 1)
			t := replaceMarker(field4, t, 4)
			t := replaceMarker(field5, t, 5)
		}
		output := output t
	}
	
	return output
}
