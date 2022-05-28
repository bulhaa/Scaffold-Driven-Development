create_put_function_name_here(reverse = 0){
	global clipList, scaffold_template, oldClipList, modelName, clipList_A_Index, project_path
	
	form_fields := scaffoldFields("copy and paste sub template here for repetitive items")

	directory := scaffoldModel("select this and press Shift + Accent to add placeholder")
	name := scaffoldModel("select this and press Shift + Accent to add placeholder")
	
	file =%project_path%\resources\views\livewire\%directory%\list-%name%.blade.php
	if(reverse){
		; this part is used for unscaffolding
		FileRead, content, %file%
		StringReplace, content, content, `r, , All
		
		StringReplace, content, content, %form_fields%, " form_fields "
	}else{
		; this part is used for scaffolding
		content := scaffoldModel("copy and paste main template here")
	}
	
	FileCreateDir, %project_path%\resources\views\livewire\%directory%
	
	
	FileDelete, %file%
	FileAppend, %content%, %file%
}