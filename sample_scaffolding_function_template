; change function name to something like listView_formFields
sample_sub_function( field_name, data_type, nullability, related_table_singular, related_table_plural ){
	;ignoreArr := {}
	;ignoreArr["deleted_at"] := 1

	;if( ignoreArr[field_name] )
	;	return ""
	
	if( InStr(data_type, "int(") )
		return "copy and paste sub template here for repetitive items"
	else
		return "copy and paste sub template here for repetitive items"
}

; change function to something like create_listview
sample_main_function(reverse = 0){
	global clipList, scaffold_template, oldClipList, modelName, clipList_A_Index, project_path
	
	; conditional repetitive injection
	form_fields := runSubScaffold( "sample_sub_function", 1)
	
	; unconditional repetitive injection
	table_headers := scaffoldFields("copy and paste sub template here for repetitive items")


	; Â¿ valueS1 Â¿
	; 1 will give singular
	; 2 will give plural, (replace 1 with 2 for plural form)
	
	; replace S with any of below to tell scaffolder to change case
	; AT: All Title Case
	; CC: CapitalCamelCase
	; S: snake_case
	; SH: snake-case-with-hyphen
	; C: camelCase
	; L: lower case
	; U: UPPER CASE
	; T: Title case
	directory := scaffoldModel("select this and press Shift + Accent to add placeholder")
	file_name := scaffoldModel("select this and press Shift + Accent to add placeholder")
	
	file =%project_path%\resources\views\livewire\%directory%\list-%file_name%.blade.php
	if(reverse){
		; this part is used for unscaffolding
		; this part turns an existing file into a template
		; replaces repetitive parts with placeholders
		FileRead, content, %file%
		StringReplace, content, content, `r, , All
		
		; any variables you use for repetitive injection should be replaced below
		StringReplace, content, content, %form_fields%, " form_fields "
		StringReplace, content, content, %table_headers%, " table_headers "
	}else{
		; this part is used for scaffolding
		content := scaffoldModel("copy and paste main template here")
	}
	
	FileCreateDir, %project_path%\resources\views\livewire\%directory%
	
	
	FileDelete, %file%
	FileAppend, %content%, %file%
}
