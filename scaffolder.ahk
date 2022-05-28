#SingleInstance force
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; phpMyAdmin page from which you can view structure of a table
phpmyadmin_table_structure_URL =http://localhost/phpmyadmin/tbl_structure.php?db=case_manager&table=name

; phpMyAdmin page from which you can view relationships of a table
phpmyadmin_table_relation_URL =http://localhost/phpmyadmin/tbl_relation.php?db=case_manager&table=name

; project path in file system
project_path =C:\xampp\htdocs\case-manager

; press accent key left of '1' on the keyboard to scaffold files
`:: scaffoldFiles()

; select text and press Ctrl + Shift + Accent to unscaffold
^+`:: goto, unscaffold

; shift + accent to output marker
; scaffolder will replace this marker
+`:: Send ¿ value1 ¿{Left 3}+{Left} ; output marker

; press Ctrl + Accent to output marker for nested scaffold
^`::
		Clipboard := """ " Clipboard " """
		Send ^v
	return

; Ctrl + Alt + x to exit
^!x:: ExitApp

modelName(){
	global singular
	
	singular := snakeCase("organisation-types")
}

scaffoldFiles(){
	global singular
	
	fetchDatabaseDesign()
		
	myTT(singular)
	plural := scaffoldModel("¿ valueCC2 ¿")
	if(plural = "")
		myTT("plural not found")
	else{
		;~ createFactory()
		;~ createSeeder()
		;~ updateDatabaseSeeder()
		;~ createController()`
		
		;~ createModel()
		;~ createImportModel()
		
		;~ createLiveWireImportController()
		;~ createLiveWireListController()
		;~ createLiveWireManageController()
		;~ createLiveWireSelectController()
		;~ createLiveWireShowController()
		
		
		;~ createLiveWireImportView()
		createLiveWireListView()
		;~ createLiveWireManageView()
		;~ createLiveWireShowView()
		
		;~ updateRoutesFile()
		;~ updateSidebar()
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
				name := scaffoldModel("¿ value" cases%A_Index% outer_index " ¿")
				content := StrReplace(content, name, "¿ value" cases%A_Index% outer_index " ¿")
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
		
		if(!InStr(scaffold_template, "¿ value"))
			scaffold_template=¿ value1 ¿
		
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
	StringReplace, t, t, ¿ value0 ¿, % value0, All
	
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
	
	StringReplace, hayStack, hayStack, ¿ value%index% ¿, % value%index%, All
	StringReplace, hayStack, hayStack, ¿ valueC%index% ¿, % valueC%index%, All
	StringReplace, hayStack, hayStack, ¿ valueCC%index% ¿, % valueCC%index%, All
	StringReplace, hayStack, hayStack, ¿ valueS%index% ¿, % valueS%index%, All
	StringReplace, hayStack, hayStack, ¿ valueSH%index% ¿, % valueSH%index%, All
	StringReplace, hayStack, hayStack, ¿ valueU%index% ¿, % valueU%index%, All
	StringReplace, hayStack, hayStack, ¿ valueAT%index% ¿, % valueAT%index%, All
	StringReplace, hayStack, hayStack, ¿ valueT%index% ¿, % valueT%index%, All
	StringReplace, hayStack, hayStack, ¿ valueL%index% ¿, % valueL%index%, All
	
	return hayStack
}

casts(){
	global oldClipList
	StringSplit, oldClipList, oldClipList, `n, `r
	output=
	
	Loop %oldClipList0%
	{
		field := oldClipList%A_Index%
		StringSplit, field, field, `t
		
		name := scaffoldModel("¿ valueS1 ¿")
		
		if(field2 = "datetime" or field2 = "timestamp" )
			t := "`        '¿ valueS1 ¿' => 'datetime'`,`n"
		else
			t := ""
		
		t := replaceMarker(field1, t, 1)
		t := replaceMarker(field4, t, 3)
		output := output t
	}
	
	return output
}

appends(){
	global oldClipList
	StringSplit, oldClipList, oldClipList, `n, `r
	output=
	
	Loop %oldClipList0%
	{
		field := oldClipList%A_Index%
		StringSplit, field, field, `t
		
		name := scaffoldModel("¿ valueS1 ¿")
		
		if(field2 = "datetime" or field2 = "timestamp" or field2 = "date" )
			t := "`        '¿ valueS1 ¿_for_editing'`,`n"
		else
			t := ""
		
		t := replaceMarker(field1, t, 1)
		t := replaceMarker(field4, t, 3)
		output := output t
	}
	
	return output
}

validation_rules(){
	global oldClipList
	StringSplit, oldClipList, oldClipList, `n, `r
	output=
	
	Loop %oldClipList0%
	{
		field := oldClipList%A_Index%
		StringSplit, field, field, `t
		
		name := scaffoldModel("¿ valueS1 ¿")
		
		arr := ["created_by", "updated_by", "created_at", "updated_at", "deleted_at"]

		if( HasVal(arr, field1) )
			continue
		
		required := ""
		if( InStr(field3, "No") )
			required := "required|"
		
		numeric := ""
		if( InStr(field2, "int(") )
			numeric := "numeric|"
		
		if(field2 = "datetime" or field2 = "timestamp" or field2 = "date" )
			t := "`            'editing.¿ value1 ¿_for_editing' => '" required "max`:100'`,`n"
		else
			t := "`            'editing.¿ value1 ¿' => '" required numeric "max`:100'`,`n"
		
		t := replaceMarker(field1, t, 1)
		t := replaceMarker(field4, t, 3)
		output := output t
	}
	
	return output
}

nullable(){
	global oldClipList
	StringSplit, oldClipList, oldClipList, `n, `r
	output=
	
	Loop %oldClipList0%
	{
		field := oldClipList%A_Index%
		StringSplit, field, field, `t
		
		name := scaffoldModel("¿ valueS1 ¿")
		
		if( InStr(field3, "Yes") )
			t := "`        '¿ valueS1 ¿' => ''`,`n"
		else
			t := ""
		
		t := replaceMarker(field1, t, 1)
		t := replaceMarker(field4, t, 3)
		output := output t
	}
	
	return output
}

dateGettersAndSetters(){
	global oldClipList
	StringSplit, oldClipList, oldClipList, `n, `r
	output=
	
	Loop %oldClipList0%
	{
		field := oldClipList%A_Index%
		StringSplit, field, field, `t
		
		name := scaffoldModel("¿ valueS1 ¿")
		
		if(field2 = "datetime" or field2 = "timestamp" or field2 = "date" )
			t := "`    public function get¿ valueCC1 ¿ForEditingAttribute()`n    {`n        return $this->¿ valueS1 ¿ ? $this->¿ valueS1 ¿->format('m/d/Y') `: ''`;`n    }`n`n    public function set¿ valueCC1 ¿ForEditingAttribute($value)`n    {`n        $this->¿ valueS1 ¿ = $value ? Carbon`:`:parse($value) `: null`;`n    }`n`n"
		else
			t := ""
		
		t := replaceMarker(field1, t, 1)
		t := replaceMarker(field4, t, 3)
		output := output t
	}
	
	return output
}

scaffold_Model_relations(){
	global oldClipList
	StringSplit, oldClipList, oldClipList, `n, `r
	output=
	
	Loop %oldClipList0%
	{
		field := oldClipList%A_Index%
		StringSplit, field, field, `t
		
		name := scaffoldModel("¿ valueL1 ¿")
		plural := scaffoldModel("¿ valueL2 ¿")
		model := scaffoldModel("¿ valueCC1 ¿")
		
		if(field4 != "" )
			t := "`    /**`n     * Get the ¿ valueL4 ¿ that owns the " name ".`n     */`n    public function ¿ valueC1 ¿()`n    {`n        return $this->belongsTo(¿ valueCC4 ¿`:`:class`, '¿ valueS1 ¿'`, 'id')`;`n    }`n`n    // /**`n    //  * Get the " plural " for the ¿ valueL4 ¿.`n    //  */`n    // public function ¿ valueC2 ¿()`n    // {`n    //     return $this->hasMany(" model "`:`:class`, 'id'`, '¿ valueS1 ¿')`;`n    // }`n`n"
		else
			t := ""
		
		t := replaceMarker(field1, t, 1)
		t := replaceMarker(field4, t, 4)
		t := replaceMarker(field5, t, 5)
		output := output t
	}
	
	return output
}

createModel(){
	global clipList, scaffold_template, oldClipList, modelName, clipList_A_Index, project_path
	
	name := scaffoldModel("¿ valueS1 ¿")

	properties := scaffoldFields("` * @property integer $¿ valueS1 ¿`n")
	casts := casts()
	appends := appends()
	validation_rules := validation_rules()
	nullable := nullable()
	fillable := scaffoldFields("`        '¿ valueS1 ¿'`,`n")
	keys := scaffoldFields("`            '¿ value1 ¿'`,`n")
	relations := scaffold_Model_relations()
	dateGettersAndSetters := dateGettersAndSetters()
	
	content := scaffoldModel("<?php`nnamespace App\Models`;`n`nuse Carbon\Carbon`;`nuse Illuminate\Database\Eloquent\Factories\HasFactory`;`nuse Illuminate\Database\Eloquent\Model`;`nuse WithPagination`;`nuse Illuminate\Support\Facades\Auth`;`nuse Illuminate\Database\Eloquent\SoftDeletes`;`n`n/**`n * Class ¿ valueCC1 ¿`n * @package App\Models\ModelBase`n * `n" properties " */`nclass ¿ valueCC1 ¿ extends Model`n{`n    use HasFactory`, SoftDeletes`;`n`n    /**`n     * The table associated with the model.`n     *`n     * @var string`n     */`n    protected $table = '¿ valueS2 ¿'`;`n`n    /**`n     * The primary key for the model.`n     *`n     * @var string`n     */`n    protected $primaryKey = 'id'`;`n`n    /**`n     * Indicates if the IDs are auto-incrementing.`n     *`n     * @var bool`n     */`n    public $incrementing = true`;`n`n    /**`n     * Indicates if the model should be timestamped.`n     *`n     * @var bool`n     */`n    public $timestamps = true`;`n`n`n    const STATUSES = [`n        'success' => 'Success'`,`n        'failed' => 'Failed'`,`n        'processing' => 'Processing'`,`n    ]`;`n`n    protected $guarded = []`;`n    protected $casts = [`n" casts "    ]`;`n    protected $appends = [`n" appends "    ]`;`n`n    protected function rules()`n    {`n        return [`n" validation_rules "        ]`;`n    }`n`n    public $nullable = [`n" nullable "    ]`;`n`n    /**`n     * This is model Observer which helps to do the same actions automatically when you creating or updating models`n     *`n     * @var array`n     */`n    protected static function boot()`n    {`n        parent`:`:boot()`;`n        static`:`:creating(function ($model) {`n            $model->created_by = Auth`:`:id()`;`n            $model->updated_by = Auth`:`:id()`;`n            $model->created_at = now()`;`n            $model->updated_at = now()`;`n        })`;`n        static`:`:updating(function ($model) {`n            $model->updated_by = Auth`:`:id()`;`n        })`;`n    }`n`n    /**`n     * The attributes that are mass assignable.`n     *`n     * @var array<int`, string>`n     */`n    protected $fillable = [`n" fillable "   ]`;`n`n    // /**`n    //  * The attributes that should be hidden.`n    //  *`n    //  * @var array<string`, string>`n    //  */`n    // protected $hidden = [`n    // ]`;`n`n    /**`n     * @return string[]`n     */`n    public static function keys()`: array`n    {`n        return [`n" keys "        ]`;`n    }`n`n" dateGettersAndSetters "`n`n" relations "}`n")
	
	name := scaffoldModel("¿ valueCC1 ¿")
	
	FileDelete, %project_path%\app\Models\%name%.php
	FileAppend, %content%, %project_path%\app\Models\%name%.php
}
	
createFactory(){
	global clipList, scaffold_template, oldClipList, modelName, clipList_A_Index, project_path
	
	definitions := scaffoldFields("`            '¿ value1 ¿' => $this->faker->name()`,`n")
	
	content := scaffoldModel("<?php`n`nnamespace Database\Factories`;`n`nuse Illuminate\Database\Eloquent\Factories\Factory`;`nuse Illuminate\Support\Str`;`n`n/**`n * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\¿ valueCC1 ¿>`n */`nclass ¿ valueCC1 ¿Factory extends Factory`n{`n    /**`n     * Define the model's default state.`n     *`n     * @return array<string`, mixed>`n     */`n    public function definition()`n    {`n        return [`n" definitions "`n        ]`;`n    }`n`n    // /**`n    //  * `n    //  *`n    //  * @return static`n    //  */`n    // public function unverified()`n    // {`n    //     return $this->state(function (array $attributes) {`n    //         return [`n    //             'email_verified_at' => null`,`n    //         ]`;`n    //     })`;`n    // }`n}`n")
	
	name := scaffoldModel("¿ valueCC1 ¿Factory")
	
	FileDelete, %project_path%\database\factories\%name%.php
	FileAppend, %content%, %project_path%\database\factories\%name%.php
}
	
createSeeder(){
	global clipList, scaffold_template, oldClipList, modelName, clipList_A_Index, project_path
	
	attributes := scaffoldFields("`            '¿ value1 ¿' => 'test'`,`n")
	
	content := scaffoldModel("<?php`n`nnamespace Database\Seeders`;`n`nuse Illuminate\Database\Console\Seeds\WithoutModelEvents`;`nuse Illuminate\Database\Seeder`;`nuse Illuminate\Support\Facades\DB`;`nuse Illuminate\Support\Str`;`n`nclass ¿ valueCC1 ¿Seeder extends Seeder`n{`n    /**`n     * Run the database seeds.`n     *`n     * @return void`n     */`n    public function run()`n    {`n        DB`:`:table('¿ valueS2 ¿')->insert([`n" attributes "`n        ])`;`n    }`n}`n")
	
	name := scaffoldModel("¿ valueCC1 ¿Seeder")
	file =%project_path%\database\seeders\%name%.php
	
	FileDelete, %file%
	FileAppend, %content%, %file%
}
	
updateDatabaseSeeder(){
	global clipList, scaffold_template, oldClipList, modelName, clipList_A_Index, project_path
	
	seeder := scaffoldModel("`            // ¿ valueCC1 ¿Seeder`:`:class`,`n")
	
	file =%project_path%\database\seeders\DatabaseSeeder.php
	FileRead, content, %file%
	StringReplace, content, content, `        ])`;, %seeder%`        ])`;
	
	FileDelete, %file%
	FileAppend, %content%, %file%
}
	
createController(){
	global clipList, scaffold_template, oldClipList, modelName, clipList_A_Index, project_path
	
	content := scaffoldModel("<?php`n`nnamespace App\Http\Controllers`;`n`nuse App\Http\Controllers\Controller`;`nuse App\Http\Requests\Create¿ valueCC1 ¿Request`;`nuse App\Models\¿ valueCC1 ¿`;`n`nclass ¿ valueCC1 ¿Controller extends Controller`n{`n    protected $routePath = '¿ values1 ¿'`;`n    protected $viewPath = '¿ values1 ¿'`;`n`n    /**`n     * Display a listing of the resource.`n     *`n     * @return \Illuminate\Contracts\View\View`n     */`n    public function index()`n    {`n        $¿ values2 ¿ = ¿ valueCC1 ¿`:`:query()->paginate()`;`n        return view(""¿ values1 ¿.index""`, compact('¿ values2 ¿'))`;`n    }`n`n    /**`n     * Show the form for creating a new resource.`n     *`n     * @return \Illuminate\Contracts\View\View`n     */`n    public function create()`n    {`n        $item = new ¿ valueCC1 ¿()`;`n        $item->_token = csrf_token()`;`n        $item->_uri = ""/¿ values1 ¿""`;`n        return view(""¿ values1 ¿.edit""`, compact('item'))`;`n    }`n`n    /**`n     * Store a newly created resource in storage.`n     *`n     * @param Create¿ valueCC1 ¿Request $request`n     * @return \Illuminate\Routing\Redirector`n     */`n    public function store(Create¿ valueCC1 ¿Request $request)`n    {`n        $item = new ¿ valueCC1 ¿`;`n        $item->fill($request->validated())`;`n        $item->save()`;`n        return redirect(""/¿ values1 ¿/$item->id"")`;`n    }`n`n    /**`n     * Display the specified resource.`n     *`n     * @param int $id`n     * @return \Illuminate\Contracts\View\View`n     */`n    public function show($id)`n    {`n        $¿ values1 ¿ = ¿ valueCC1 ¿`:`:query()->findOrFail($id)`;`n        return view(""¿ values1 ¿.show""`, compact('¿ values1 ¿'))`;`n    }`n`n    /**`n     * Show the form for editing the specified resource.`n     *`n     * @param int $id`n     * @return \Illuminate\Contracts\View\View`n     */`n    public function edit($id)`n    {`n        $item = ¿ valueCC1 ¿`:`:query()->findOrFail($id)`;`n        $item->_token = csrf_token()`;`n        $item->_method = 'PATCH'`;`n        $item->_uri = ""/¿ values1 ¿/$item->id""`;`n        return view(""¿ values1 ¿.edit""`, compact('item'))`;`n    }`n`n    /**`n     * Update the specified resource in storage.`n     *`n     * @param int $id`n     * @param Create¿ valueCC1 ¿Request $request`n     * @return \Illuminate\Routing\Redirector`n     */`n    public function update($id`, Create¿ valueCC1 ¿Request $request)`n    {`n        $item = ¿ valueCC1 ¿`:`:query()->findOrFail($id)`;`n        $item->update($request->validated())`;`n        return redirect(""/¿ values1 ¿/$item->id"")`;`n    }`n`n    /**`n     * Remove the specified resource from storage.`n     *`n     * @param int $id`n     * @return \Illuminate\Routing\Redirector`n     */`n    public function destroy($id)`n    {`n        ¿ valueCC1 ¿`:`:destroy($id)`;`n        return redirect(""/¿ values1 ¿"")`;`n    }`n}`n")
	
	name := scaffoldModel("¿ valueCC1 ¿Controller")
	file =%project_path%\app\Http\Controllers\%name%.php
	
	FileDelete, %file%
	FileAppend, %content%, %file%
}
	
scaffold_ListController_relations(){
	global oldClipList
	StringSplit, oldClipList, oldClipList, `n, `r
	output=
	
	Loop %oldClipList0%
	{
		field := oldClipList%A_Index%
		StringSplit, field, field, `t
		
		skip := {"created_by": 1, "updated_by": 1}
		
		if(field4 != "" and !skip[field1] )
			t := "`            '¿ valueS1 ¿'`,`n"
		else 
			continue
		
		t := replaceMarker(field1, t, 1)
		t := replaceMarker(field4, t, 4)
		t := replaceMarker(field5, t, 5)
		output := output t
	}
	
	return output
}
	
createLiveWireListController(reverse = 0){
	global clipList, scaffold_template, oldClipList, modelName, clipList_A_Index, project_path
	
	;~ name := scaffoldModel("¿ valueS1 ¿")

	relations := scaffold_ListController_relations()
	
	directory := scaffoldModel("¿ valueCC1 ¿")
	name := scaffoldModel("¿ valueCC2 ¿")
	file =%project_path%\app\Http\Livewire\%directory%\List%name%.php

	if(reverse){
		FileRead, content, %file%
		StringReplace, content, content, `r, , All
		
		StringReplace, content, content, %relations%, " relations "
	}else
		content := scaffoldModel("<?php`n`nnamespace App\Http\Livewire\¿ valueCC1 ¿`;`n`nuse Livewire\Component`;`nuse App\Models\¿ valueCC1 ¿`;`nuse Illuminate\Support\Carbon`;`nuse App\Http\Livewire\DataTable\WithSorting`;`nuse App\Http\Livewire\DataTable\WithCachedRows`;`nuse App\Http\Livewire\DataTable\WithBulkActions`;`nuse App\Http\Livewire\DataTable\WithPerPagePagination`;`n`nclass List¿ valueCC1 ¿s extends Component`n{`n    use WithPerPagePagination`, WithSorting`, WithBulkActions`, WithCachedRows`;`n`n    public $showDeleteModal = false`;`n    public $showEditModal = false`;`n    public $showFilters = false`;`n    public $filters = [`n        'search' => ''`,`n        'status' => ''`,`n        'amount-min' => null`,`n        'amount-max' => null`,`n        'created_at-min' => null`,`n        'created_at-max' => null`,`n    ]`;`n    public ¿ valueCC1 ¿ $editing`;`n`n    protected $queryString = ['sorts']`;`n`n    protected $listeners = ['refresh¿ valueCC1 ¿s' => '$refresh']`;`n`n    protected function rules()`n    {`n        return ¿ valueCC1 ¿`:`:rules()`;`n    }`n`n    public function mount() { $this->editing = $this->makeBlank¿ valueCC1 ¿()`; }`n    public function updatedFilters() { $this->resetPage()`; }`n`n    public function exportSelected()`n    {`n        return response()->streamDownload(function () {`n            echo $this->selectedRowsQuery->toCsv()`;`n        }`, '¿ valueS1 ¿s.csv')`;`n    }`n`n    public function deleteSelected()`n    {`n        $deleteCount = $this->selectedRowsQuery->count()`;`n`n        $this->selectedRowsQuery->delete()`;`n`n        $this->showDeleteModal = false`;`n`n        $this->notify('You\'ve deleted '.$deleteCount.' ¿ valueS1 ¿s')`;`n    }`n`n    public function makeBlank¿ valueCC1 ¿()`n    {`n        return ¿ valueCC1 ¿`:`:make(['date' => now()`, 'status' => 'success'])`;`n    }`n`n    public function toggleShowFilters()`n    {`n        $this->useCachedRows()`;`n`n        $this->showFilters = ! $this->showFilters`;`n    }`n`n    public function create()`n    {`n        $this->useCachedRows()`;`n`n        if ($this->editing->getKey()) $this->editing = $this->makeBlank¿ valueCC1 ¿()`;`n`n        $this->showEditModal = true`;`n    }`n`n    public function edit(¿ valueCC1 ¿ $¿ valueS1 ¿)`n    {`n        $this->useCachedRows()`;`n`n        if ($this->editing->isNot($¿ valueS1 ¿)) $this->editing = $¿ valueS1 ¿`;`n`n        $this->showEditModal = true`;`n    }`n`n    public function save()`n    {`n        nullableToNull($this->editing)`;`n        $this->validate()`;`n`n        $this->editing->save()`;`n`n        $this->showEditModal = false`;`n    }`n`n    public function resetFilters() { $this->reset('filters')`; }`n`n    public function getRowsQueryProperty()`n    {`n        $query = ¿ valueCC1 ¿`:`:query()`n            ->when($this->filters['status']`, fn($query`, $status) => $query->where('status'`, $status))`n            ->when($this->filters['amount-min']`, fn($query`, $amount) => $query->where('amount'`, '>='`, $amount))`n            ->when($this->filters['amount-max']`, fn($query`, $amount) => $query->where('amount'`, '<='`, $amount))`n            ->when($this->filters['created_at-min']`, fn($query`, $created_at) => $query->where('created_at'`, '>='`, Carbon`:`:parse($created_at)))`n            ->when($this->filters['created_at-max']`, fn($query`, $created_at) => $query->where('created_at'`, '<='`, Carbon`:`:parse($created_at)))`n            ->when($this->filters['search']`, fn($query`, $search) => $query->where('name'`, 'like'`, '`%'.$search.'`%'))`;`n`n        return $this->applySorting($query)`;`n    }`n`n    public function getRowsProperty()`n    {`n        return $this->cache(function () {`n            return $this->applyPagination($this->rowsQuery)`;`n        })`;`n    }`n`n    public function render()`n    {`n        return view('livewire.¿ valueSH1 ¿.list-¿ valueSH1 ¿s'`, [`n            '¿ valueS1 ¿s' => $this->rows`,`n        ])`;`n    }`n`n    public function getListeners()`n    {`n        return collect([`n" relations "        ])->mapWithKeys(function ($key) {`n                return [""{$key}Updated"" => 'updateDependingValue']`;`n            })`n            ->toArray()`;`n    }`n`n    public function updateDependingValue($data)`n    {`n        $name = $data['name']`;`n        $value = $data['value']`;`n`n        $this->editing->{$name} = $value`;`n    }`n`n}`n")
	
	FileCreateDir, %project_path%\app\Http\Livewire\%directory%
	
	
	FileDelete, %file%
	FileAppend, %content%, %file%
}
	
createLiveWireManageController(){
	global clipList, scaffold_template, oldClipList, modelName, clipList_A_Index, project_path
	
	;~ name := scaffoldModel("¿ valueS1 ¿")
	;~ validation_rules := scaffoldFields("`        '" name ".¿ value1 ¿' => 'required|min`:6'`,`n")
	
	content := scaffoldModel("<?php`n`nnamespace App\Http\Livewire\¿ valueCC1 ¿`;`n`nuse Livewire\Component`;`nuse App\Models\¿ valueCC1 ¿`;`n`nclass Manage¿ valueCC1 ¿ extends Component`n{`n    public ¿ valueCC1 ¿ $businessEntityType`;`n    public ¿ valueCC1 ¿ $editing`;`n    public $isEditing = false`;`n`n    protected function rules()`n    {`n        return ¿ valueCC1 ¿`:`:rules()`;`n    }`n`n    public function mount($businessEntityType = null)`n    {`n        if ($businessEntityType) {`n            $this->editing = $businessEntityType`;`n            $this->isEditing = true`;`n        } else {`n            $this->editing = ¿ valueCC1 ¿`:`:make()`;`n        }`n    }`n`n    public function render()`n    {`n        return view('livewire.¿ valueSH1 ¿.manage-¿ valueSH1 ¿')`;`n    }`n`n    public function save()`n    {`n        $this->validate()`;`n        `n        $this->editing->save()`;`n        return redirect()->route('¿ valueS2 ¿')`;`n    }`n`n}")
	
	name := scaffoldModel("¿ valueCC1 ¿\Manage¿ valueCC1 ¿")
	file =%project_path%\app\Http\Livewire\%name%.php
	
	FileDelete, %file%
	FileAppend, %content%, %file%
}
	
createLiveWireShowController(){
	global clipList, scaffold_template, oldClipList, modelName, clipList_A_Index, project_path
	
	content := scaffoldModel("<?php`n`nnamespace App\Http\Livewire\¿ valueCC1 ¿`;`n`nuse Livewire\Component`;`nuse App\Models\¿ valueCC1 ¿`;`n`nclass Show¿ valueCC1 ¿ extends Component`n{`n    public ¿ valueCC1 ¿ $businessEntityType`;`n`n    public function render()`n    {`n        return view('livewire.¿ valueSH1 ¿.show-¿ valueSH1 ¿'`, [`n            '¿ valueS1 ¿' => $this->businessEntityType ])`;`n    }`n`n    public function delete($id)`n    {`n        ¿ valueCC1 ¿`:`:find($id)->delete()`;`n        session()->flash('message'`, '¿ valueAT1 ¿ deleted successfully.')`;`n        return redirect()->route('¿ valueSH2 ¿')`;`n    }`n}")
	
	name := scaffoldModel("¿ valueCC1 ¿\Show¿ valueCC1 ¿")
	file =%project_path%\app\Http\Livewire\%name%.php
	
	FileDelete, %file%
	FileAppend, %content%, %file%
}

createLiveWireSelectController(){
	global clipList, scaffold_template, oldClipList, modelName, clipList_A_Index, project_path
	
	content := scaffoldModel("<?php `nnamespace App\Http\Livewire\¿ valueCC1 ¿`;`n`nuse Livewire\Component`;`nuse App\Models\¿ valueCC1 ¿`;`nuse Asantibanez\LivewireSelect\LivewireSelect`;`nuse Illuminate\Support\Collection`;`n`nclass Select¿ valueCC1 ¿ extends LivewireSelect`n{`n    public function options($searchTerm = null) `: Collection `n    {`n        if(!empty($searchTerm))`n            $¿ valueS2 ¿ = ¿ valueCC1 ¿`:`:where('name'`, 'like'`, '`%' . $searchTerm . '`%')->get()`;`n        else`n            $¿ valueS2 ¿ = ¿ valueCC1 ¿`:`:get()`;`n`n        $list = []`;`n        foreach ($¿ valueS2 ¿ as $key => $¿ valueS1 ¿) {`n            $list[] = [`n                'value' => $¿ valueS1 ¿->id`,`n                'description' => $¿ valueS1 ¿->name`,`n            ]`;`n        }`n`n        return collect($list)`;`n    }`n`n    public function selectedOption($searchTerm = null) `: Collection `n    {`n        $¿ valueS1 ¿ = ¿ valueCC1 ¿`:`:find($searchTerm)`;`n`n        $list = [`n            'value' => $¿ valueS1 ¿->id`,`n            'description' => $¿ valueS1 ¿->name`,`n        ]`;`n`n        return collect($list)`;`n    }`n}")
	
	name := scaffoldModel("¿ valueCC1 ¿\Select¿ valueCC1 ¿")
	file =%project_path%\app\Http\Livewire\%name%.php
	
	FileDelete, %file%
	FileAppend, %content%, %file%
}

scaffold_LiveWireImportController_rules(){
	global oldClipList
	
	if(withID)
		oldClipList := "id`tbigint(20)`t`n" oldClipList
	
	StringSplit, oldClipList, oldClipList, `n, `r
	output=
	
	Loop %oldClipList0%
	{
		field := oldClipList%A_Index%
		StringSplit, field, field, `t
		
		name := scaffoldModel("¿ valueS1 ¿")
		
		if( InStr(field3, "No") )
			t := "`        'fieldColumnMap.¿ valueS1 ¿' => 'required'`,`n"
		else
			t := ""
		
		t := replaceMarker(field1, t, 1)
		t := replaceMarker(field4, t, 3)
		output := output t
	}
	
	return output
}
	
scaffold_LiveWireImportController_createFields(){
	global oldClipList
	
	if(withID)
		oldClipList := "id`tbigint(20)`t`n" oldClipList
	
	StringSplit, oldClipList, oldClipList, `n, `r
	output=
	
	Loop %oldClipList0%
	{
		field := oldClipList%A_Index%
		StringSplit, field, field, `t
		
		name := scaffoldModel("¿ valueS1 ¿")
		
		if(field2 = "datetime" or field2 = "timestamp" )
			t := "`                        ""¿ valueS1 ¿"" =>  $row['¿ valueS1 ¿'] ?  Carbon`:`:createFromFormat('d/m/Y H`:i'`, $row['¿ valueS1 ¿'])->format('Y-m-d H:i:s') `: null`,`n"
		else
			t := "`                        ""¿ value1 ¿"" => $row['¿ value1 ¿']`,`n"
		
		t := replaceMarker(field1, t, 1)
		t := replaceMarker(field4, t, 3)
		output := output t
	}
	
	return output
}
	
scaffold_LiveWireImportController_guesses(withID){
	global oldClipList
	
	if(withID)
		oldClipList := "id`tbigint(20)`t`n" oldClipList
	
	StringSplit, oldClipList, oldClipList, `n, `r
	output=
	
	Loop %oldClipList0%
	{
		field := oldClipList%A_Index%
		StringSplit, field, field, `t
		
		name := scaffoldModel("¿ valueS1 ¿")
		
		if(field2 = "datetime" or field2 = "timestamp" )
			t := "`            '¿ valueS1 ¿' => ['¿ valueS1 ¿_for_editing'`, '¿ valueS1 ¿'`, 'alternateName']`,`n"
		else
			t := "`            '¿ valueS1 ¿' => ['¿ valueS1 ¿'`, 'alternateName']`,`n"
		
		t := replaceMarker(field1, t, 1)
		t := replaceMarker(field4, t, 3)
		output := output t
	}
	
	return output
}

createLiveWireImportController(){
	global clipList, scaffold_template, oldClipList, modelName, clipList_A_Index, project_path
	
	fieldColumnMap := scaffoldFields("`        '¿ valueS1 ¿' => ''`,`n", 0)
	rules := scaffold_LiveWireImportController_rules()
	customAttributes := scaffoldFields("`        'fieldColumnMap.¿ valueS1 ¿' => '¿ valueS1 ¿'`,`n", 0)
	createFields := scaffold_LiveWireImportController_createFields()
	guesses := scaffold_LiveWireImportController_guesses(0)
	
	content := scaffoldModel("<?php`n`nnamespace App\Http\Livewire\¿ valueCC1 ¿`;`n`nuse Carbon\Carbon`;`nuse App\Csv`;`nuse Validator`;`nuse Livewire\Component`;`nuse App\Models\¿ valueCC1 ¿`;`nuse Livewire\WithFileUploads`;`nuse Illuminate\Support\Str`;`nuse Maatwebsite\Excel\Facades\Excel`;`nuse App\Imports\¿ valueCC2 ¿Import`;`n`nclass Import¿ valueCC2 ¿ extends Component`n{`n    use WithFileUploads`;`n`n    public $showModal = false`;`n    public $showFields = false`;`n    public $upload`;`n    public $columns`;`n    public $fieldColumnMap = [`n" fieldColumnMap "    ]`;`n`n    protected $rules = [`n" rules "    ]`;`n`n    protected $customAttributes = [`n" customAttributes "    ]`;`n`n    public function updatingUpload($value)`n    {`n        Validator`:`:make(`n            ['upload' => $value]`,`n            ['upload' => 'required|mimes`:xlsx`,csv']`,`n        )->validate()`;`n    }`n`n    public function updatedUpload()`n    {`n        if( $this->upload && $this->upload->getMimeType() == ""application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"" ){`n            Excel`:`:import(new ¿ valueCC2 ¿Import`, $this->upload)`;`n            $this->reset()`;`n`n            $this->emit('refresh¿ valueCC2 ¿')`;`n`n            $this->notify('Imported ¿ valueS2 ¿!')`;`n        }else{`n            $this->columns = Csv`:`:from($this->upload)->columns()`;`n`n`n            $this->guessWhichColumnsMapToWhichFields()`;`n        }`n    }`n`n    public function import()`n    {`n        $this->validate()`;`n`n        $importCount = 0`;`n`n        Csv`:`:from($this->upload)`n            ->eachRow(function ($row) use (&$importCount) {`n                foreach (\App\Models\¿ valueCC1 ¿`:`:nullable() as $key => $column) {`n                    $row[$key] = $row[$key] ? $row[$key] `: null`;`n                }`n`n                $row = $this->extractFieldsFromRow($row)`;`n                `n                ¿ valueCC1 ¿`:`:create(`n                    [`n" createFields "                    ]`n                )`;`n`n                $importCount++`;`n            })`;`n`n        $this->reset()`;`n`n        $this->emit('refresh¿ valueCC2 ¿')`;`n`n        $this->notify('Imported '.$importCount.' ¿ valueS2 ¿!')`;`n    }`n`n    public function extractFieldsFromRow($row)`n    {`n        $attributes = collect($this->fieldColumnMap)`n            ->filter()`n            ->mapWithKeys(function($heading`, $field) use ($row) {`n                return [$field => $row[$heading]]`;`n            })`n            ->toArray()`;`n`n        return $attributes + ['created_at' => now()]`;`n    }`n`n    public function guessWhichColumnsMapToWhichFields()`n    {`n        $guesses = [`n" guesses "        ]`;`n`n        foreach ($this->columns as $column) {`n            $match = collect($guesses)->search(fn($options) => in_array(strtolower($column)`, $options))`;`n`n            if ($match) $this->fieldColumnMap[$match] = $column`;`n        }`n    }`n}`n")
	
	directory := scaffoldModel("¿ valueCC1 ¿")
	FileCreateDir, %project_path%\app\Http\Livewire\%directory%
	
	name := scaffoldModel("¿ valueCC1 ¿\Import¿ valueCC2 ¿")
	file =%project_path%\app\Http\Livewire\%name%.php
	
	FileDelete, %file%
	FileAppend, %content%, %file%
}

scaffold_ImportModel_fields(withID = 0){
	global oldClipList
	
	if(withID)
		oldClipList := "id`tbigint(20)`t`n" oldClipList
	
	StringSplit, oldClipList, oldClipList, `n, `r
	output=
	
	Loop %oldClipList0%
	{
		;~ if(A_Index = 1)
			;~ continue
		
		field := oldClipList%A_Index%
		StringSplit, field, field, `t
		
		name := scaffoldModel("¿ valueS1 ¿")
		
		if(field2 = "datetime" or field2 = "timestamp" )
			t := "`           '¿ valueS1 ¿'     => $row[" A_Index "] ? \PhpOffice\PhpSpreadsheet\Shared\Date`:`:excelToDateTimeObject($row[" A_Index "]) `: null`,`n"
		else
			t := "`           '¿ valueS1 ¿'     => $row[" A_Index "]`,`n"
		
		t := replaceMarker(field1, t, 1)
		t := replaceMarker(field4, t, 3)
		output := output t
	}
	
	return output
}

createImportModel(){
	global clipList, scaffold_template, oldClipList, modelName, clipList_A_Index, project_path
	
	fields := scaffold_ImportModel_fields()
	
	content := scaffoldModel("<?php`n`nnamespace App\Imports`;`n`nuse Carbon\Carbon`;`nuse App\Models\¿ valueAT1 ¿`;`nuse Illuminate\Support\Facades\Hash`;`nuse Maatwebsite\Excel\Concerns\ToModel`;`nuse PhpOffice\PhpSpreadsheet\Shared\Date`;`n`nclass ¿ valueAT2 ¿Import implements ToModel`n{`n    /**`n     * @param array $row`n     *`n     * @return ¿ valueAT1 ¿|null`n     */`n    public function model(array $row)`n    {`n        if($row[12] == ""last_activity_date"")`n            return null`;`n        `n        return new ¿ valueAT1 ¿([`n" fields "        ])`;`n    }`n}")
	
	name := scaffoldModel("¿ valueCC2 ¿Import")
	file =%project_path%\app\Imports\%name%.php
	
	FileDelete, %file%
	FileAppend, %content%, %file%
}

scaffoldTableFields(){
	global oldClipList
	
	clipList := "id`tbigint(20)`t`n" oldClipList
	StringSplit, clipList, clipList, `n, `r
	output=
	
	name := scaffoldModel("¿ valueS1 ¿")
	plural := scaffoldModel("¿ valueSH2 ¿")
		
	Loop %clipList0%
	{
		field := clipList%A_Index%
		StringSplit, field, field, `t
		
		arr := ["deleted_at"]

		if( HasVal(arr, field1) )
			continue
		
		if(field4 != "") ; if relation is there
			t := "`                        <x-table.cell>`n                            <a href=""{{ $" name "['¿ valueS1 ¿'] ? route('¿ valueSH5 ¿.show'`, $" name "['¿ valueS1 ¿']) `: '' }}"">`n                                <span href=""#"" class=""inline-flex space-x-2 truncate text-sm leading-5"">`n                                    {{ $" name "->¿ valueS1 ¿ ? $" name "->¿ valueS1 ¿->name `: '' }}`n                                </span>`n                            </a>`n                        </x-table.cell>`n`n"
		else if(field2 = "datetime" or field2 = "timestamp" )
			t := "`                        <x-table.cell>`n                            <a href=""{{ route('" plural ".show'`, $" name "['id']) }}"">`n                                {{ getDateForHumans($" name "->¿ valueS1 ¿) }}`n                            </a>`n                        </x-table.cell>`n`n"
		else 
			t := "`                        <x-table.cell>`n                            <a href=""{{ route('" plural ".show'`, $" name "['id']) }}"">`n                                <span href=""#"" class=""inline-flex space-x-2 truncate text-sm leading-5"">`n                                    {{ $" name "->¿ valueS1 ¿ }}`n                                </span>`n                            </a>`n                        </x-table.cell>`n`n"
		
		t := replaceMarker(field1, t, 1)
		t := replaceMarker(field4, t, 4)
		t := replaceMarker(field5, t, 5)
		output := output t
	}
	
	return output
}
	
scaffoldFormFields(){
	global oldClipList
	StringSplit, oldClipList, oldClipList, `n, `r
	output=
	
	Loop %oldClipList0%
	{
		field := oldClipList%A_Index%
		StringSplit, field, field, `t
		
		name := scaffoldModel("¿ valueS1 ¿")
		
		arr := ["created_by", "updated_by", "created_at", "updated_at", "deleted_at"]

		if( HasVal(arr, field1) )
			continue
		
		; check if "an" or "a" should be used
		aOrAn := "a"
		vowels := ["a", "e", "i", "o", "u"]
		firstCharacter := SubStr(field1, 1, 1)
		if( HasVal(vowels, firstCharacter) )
			aOrAn := "an"
		
		required := ""
		if( InStr(field3, "No") )
			required := ":required=""true"" "
		
		if(field4 != ""){
			t := "`                    <div class=""w-full md`:w-1/2 px-3 mb-6 md`:mb-0"">`n                        <x-input.group for=""¿ valueS1 ¿"" label=""¿ valueAT91 ¿"" " required " `:error=""$errors->first('editing.¿ valueS1 ¿')"">`n                            <livewire`:¿ valueSH4 ¿.select-¿ valueSH4 ¿`n                              name=""¿ valueS4 ¿""`n                              placeholder=""Choose " aOrAn " ¿ valueL4 ¿""`n                            />`n                            <?php /* `:searchable=""true"" */ ?>`n                        </x-input.group>`n                    </div>`n`n"
			without_id := StrReplace(field1, "_id", "")
			t := replaceMarker(without_id, t, 91)
		}else 
		if(field2 = "datetime" or field2 = "timestamp" or field2 = "date" )
			t := "`                    <div class=""w-full md`:w-1/2 px-3 mb-6 md`:mb-0"">`n                        <x-input.group for=""¿ valueS1 ¿_for_editing"" label=""¿ valueAT1 ¿""  " required " `:error=""$errors->first('editing.¿ valueS1 ¿_for_editing')"">`n                            <x-input.date wire`:model=""editing.¿ valueS1 ¿_for_editing"" id=""¿ valueS1 ¿_for_editing"" />`n                        </x-input.group>`n                    </div>`n`n"
		else if(field2 = "int")
			t := "`                <x-input.group for=""¿ valueS1 ¿"" label=""¿ valueAT1 ¿""  " required " `:error=""$errors->first('editing.¿ valueS1 ¿')"">`n                    <x-input.money wire`:model=""editing.¿ valueS1 ¿"" id=""¿ valueS1 ¿"" />`n                </x-input.group>`n`n"
		else
			t := "`                    <div class=""w-full md`:w-1/2 px-3 mb-6 md`:mb-0"">`n                        <x-input.group for=""¿ valueS1 ¿"" label=""¿ valueAT1 ¿""  " required " `:error=""$errors->first('editing.¿ valueS1 ¿')"">`n                            <x-input.text wire`:model=""editing.¿ valueS1 ¿"" id=""¿ valueS1 ¿"" placeholder=""¿ valueAT1 ¿"" />`n                        </x-input.group>`n                    </div>`n`n"
		t := replaceMarker(field1, t, 1)
		t := replaceMarker(field4, t, 4)
		t := replaceMarker(field5, t, 5)
		output := output t
	}
	
	return output
}
	
scaffoldTableHeaders(){
	global oldClipList
	clipList := "id`tbigint(20)`t`t`t`n" oldClipList
	StringSplit, clipList, clipList, `n, `r
	output=
	
	Loop %clipList0%
	{
		field := clipList%A_Index%
		StringSplit, field, field, `t
		
		name := scaffoldModel("¿ valueS1 ¿")
		
		arr := ["deleted_at"]

		if( HasVal(arr, field1) )
			continue
		
		t := "`                    <x-table.heading sortable multi-column wire`:click=""sortBy('¿ valueS1 ¿')"" `:direction=""$sorts['¿ valueS1 ¿'] ?? null"" class="""">¿ valueAT1 ¿</x-table.heading>`n"
		
		t := replaceMarker(field1, t, 1)
		t := replaceMarker(field4, t, 4)
		t := replaceMarker(field5, t, 5)
		output := output t
	}
	
	return output
}
	
createLiveWireListView(reverse = 0){
	global clipList, scaffold_template, oldClipList, modelName, clipList_A_Index, project_path
	
	table_headers := scaffoldTableHeaders()

	table_rows := scaffoldTableFields()
	
	form_fields := scaffoldFormFields()

	directory := scaffoldModel("¿ valueSH1 ¿")
	name := scaffoldModel("¿ valueSH2 ¿")
	file =%project_path%\resources\views\livewire\%directory%\list-%name%.blade.php
	if(reverse){
		FileRead, content, %file%
		StringReplace, content, content, `r, , All
		
		StringReplace, content, content, %table_headers%, " table_headers "
		StringReplace, content, content, %table_rows%, " table_rows "
		StringReplace, content, content, %form_fields%, " form_fields "
	}else{
	
		content := scaffoldModel("<div>`n    <h1 class=""text-2xl font-semibold text-gray-900"">¿ valueAT1 ¿s</h1>`n`n    <div class=""py-4 space-y-4"">`n        <!-- Top Bar -->`n        <div class=""flex justify-between"">`n            <div class=""w-2/4 flex space-x-4"">`n                <x-input.text wire`:model=""filters.search"" placeholder=""Search ¿ valueAT1 ¿s..."" />`n`n                <x-button.link wire`:click=""toggleShowFilters"">@if ($showFilters) Hide @endif Advanced Search...</x-button.link>`n            </div>`n`n            <div class=""space-x-2 flex items-center"">`n                <x-input.group borderless paddingless for=""perPage"" label=""Per Page"">`n                    <x-input.select wire`:model=""perPage"" id=""perPage"">`n                        <option value=""10"">10</option>`n                        <option value=""25"">25</option>`n                        <option value=""50"">50</option>`n                    </x-input.select>`n                </x-input.group>`n`n                <x-dropdown label=""Bulk Actions"">`n                    <x-dropdown.item type=""button"" wire`:click=""exportSelected"" class=""flex items-center space-x-2"">`n                        <x-icon.download class=""text-cool-gray-400""/> <span>Export</span>`n                    </x-dropdown.item>`n`n                    <x-dropdown.item type=""button"" wire`:click=""$toggle('showDeleteModal')"" class=""flex items-center space-x-2"">`n                        <x-icon.trash class=""text-cool-gray-400""/> <span>Delete</span>`n                    </x-dropdown.item>`n                </x-dropdown>`n`n                <livewire`:¿ valueSH1 ¿.import-¿ valueSH1 ¿s />`n`n                <x-button.primary wire`:click=""create""><x-icon.plus/> New</x-button.primary>`n            </div>`n        </div>`n`n        <!-- Advanced Search -->`n        <div>`n            @if ($showFilters)`n            <div class=""bg-cool-gray-200 p-4 rounded shadow-inner flex relative"">`n                <?php /* <div class=""w-1/2 pr-2 space-y-4"">`n                    <x-input.group inline for=""filter-status"" label=""Status"">`n                        <x-input.select wire`:model=""filters.status"" id=""filter-status"">`n                            <option value="""" disabled>Select Status...</option>`n`n                            @foreach (App\Models\¿ valueCC1 ¿`:`:STATUSES as $value => $label)`n                            <option value=""{{ $value }}"">{{ $label }}</option>`n                            @endforeach`n                        </x-input.select>`n                    </x-input.group>`n`n                    <x-input.group inline for=""filter-amount-min"" label=""Minimum Amount"">`n                        <x-input.money wire`:model.lazy=""filters.amount-min"" id=""filter-amount-min"" />`n                    </x-input.group>`n`n                    <x-input.group inline for=""filter-amount-max"" label=""Maximum Amount"">`n                        <x-input.money wire`:model.lazy=""filters.amount-max"" id=""filter-amount-max"" />`n                    </x-input.group>`n                </div> */ ?>`n`n                <div class=""w-1/2 pl-2 space-y-4"">`n                    <x-input.group inline for=""filter-created_at-min"" label=""Minimum Date"">`n                        <x-input.date wire`:model=""filters.created_at-min"" id=""filter-created_at-min"" placeholder=""MM/DD/YYYY"" />`n                    </x-input.group>`n`n                    <x-input.group inline for=""filter-created_at-max"" label=""Maximum Date"">`n                        <x-input.date wire`:model=""filters.created_at-max"" id=""filter-created_at-max"" placeholder=""MM/DD/YYYY"" />`n                    </x-input.group>`n`n                    <x-button.link wire`:click=""resetFilters"" class=""absolute right-0 bottom-0 p-4"">Reset Filters</x-button.link>`n                </div>`n            </div>`n            @endif`n        </div>`n`n        <!-- ¿ valueAT1 ¿s Table -->`n        <div class=""flex-col space-y-4"">`n            <x-table>`n                <x-slot name=""head"">`n                    <x-table.heading class=""pr-0 w-8"">`n                        <x-input.checkbox wire`:model=""selectPage"" />`n                    </x-table.heading>`n" table_headers "                   <x-table.heading />`n                </x-slot>`n`n                <x-slot name=""body"">`n                    @if ($selectPage)`n                    <x-table.row class=""bg-cool-gray-200"" wire`:key=""row-message"">`n                        <x-table.cell colspan=""6"">`n                            @unless ($selectAll)`n                            <div>`n                                <span>You have selected <strong>{{ $¿ valueS1 ¿s->count() }}</strong> ¿ valueS1 ¿s`, do you want to select all <strong>{{ $¿ valueS1 ¿s->total() }}</strong>?</span>`n                                <x-button.link wire`:click=""selectAll"" class=""ml-1 text-blue-600"">Select All</x-button.link>`n                            </div>`n                            @else`n                            <span>You are currently selecting all <strong>{{ $¿ valueS1 ¿s->total() }}</strong> ¿ valueS1 ¿s.</span>`n                            @endif`n                        </x-table.cell>`n                    </x-table.row>`n                    @endif`n`n                    @forelse ($¿ valueS1 ¿s as $¿ valueS1 ¿)`n                    <x-table.row wire`:loading.class.delay=""opacity-50"" wire`:key=""row-{{ $¿ valueS1 ¿->id }}"">`n                        <x-table.cell class=""pr-0"">`n                            <x-input.checkbox wire`:model=""selected"" value=""{{ $¿ valueS1 ¿->id }}"" />`n                        </x-table.cell>`n`n" table_rows "                        <x-table.cell>`n                            <a href=""{{ route('¿ valueSH1 ¿s.show'`, $¿ valueS1 ¿['id']) }}"">`n                                <x-button.link class=""bg-white text-secondary m-5 mb-0"">`n                                    <div class=""flex space-x-2 items-center""> `n                                        <x-icon.eye/>`n                                        <span></span>`n                                    </div>`n                                </x-button.link>`n                            </a>`n                            <x-button.link class=""bg-white text-secondary m-5 mb-0"" wire`:click=""edit({{ $¿ valueS1 ¿['id'] }})"" >`n                                <div class=""flex space-x-2 items-center""> `n                                    <x-icon.pencil/>`n                                    <span></span>`n                                </div>`n                            </x-button.link>`n                        </x-table.cell>`n                    </x-table.row>`n                    @empty`n                    <x-table.row>`n                        <x-table.cell colspan=""11"">`n                            <div class=""flex justify-center items-center space-x-2"">`n                                <x-icon.inbox class=""h-8 w-8 text-cool-gray-400"" />`n                                <span class=""font-medium py-8 text-cool-gray-400 text-xl"">No ¿ valueAT1 ¿s found...</span>`n                            </div>`n                        </x-table.cell>`n                    </x-table.row>`n                    @endforelse`n                </x-slot>`n            </x-table>`n`n            <div>`n                {{ $¿ valueS1 ¿s->links() }}`n            </div>`n        </div>`n    </div>`n`n    <!-- Delete ¿ valueAT1 ¿s Modal -->`n    <form wire`:submit.prevent=""deleteSelected"">`n        <x-modal.confirmation wire`:model.defer=""showDeleteModal"">`n            <x-slot name=""title"">Delete ¿ valueAT1 ¿</x-slot>`n`n            <x-slot name=""content"">`n                <div class=""py-8 text-cool-gray-700"">Are you sure you? This action is irreversible.</div>`n            </x-slot>`n`n            <x-slot name=""footer"">`n                <x-button.secondary wire`:click=""$set('showDeleteModal'`, false)"">Cancel</x-button.secondary>`n`n                <x-button.primary type=""submit"">Delete</x-button.primary>`n            </x-slot>`n        </x-modal.confirmation>`n    </form>`n`n    <!-- Save ¿ valueAT1 ¿ Modal -->`n    <form wire`:submit.prevent=""save"">`n        <x-modal.dialog wire`:model.defer=""showEditModal"" `:maxWidth=""'5xl'"">`n            <x-slot name=""title"">{{ $editing['id'] ? 'Edit' `: 'Create' }} ¿ valueAT1 ¿</x-slot>`n`n            <x-slot name=""content"">`n                <div class=""flex flex-wrap -mx-3 mb-6"">`n" form_fields "`n                </div>`n            </x-slot>`n`n            <x-slot name=""footer"">`n                <x-button.secondary wire`:click=""$set('showEditModal'`, false)"">Cancel</x-button.secondary>`n`n                <x-button.primary type=""submit"">Save</x-button.primary>`n            </x-slot>`n        </x-modal.dialog>`n    </form>`n</div>`n")
	}
	
	FileCreateDir, %project_path%\resources\views\livewire\%directory%
	
	
	FileDelete, %file%
	FileAppend, %content%, %file%
}

scaffold_LiveWireManageView_fields(){
	global oldClipList
	StringSplit, oldClipList, oldClipList, `n, `r
	output=
	
	Loop %oldClipList0%
	{
		field := oldClipList%A_Index%
		StringSplit, field, field, `t
		
		arr := ["created_by", "updated_by", "created_at", "updated_at", "deleted_at"]

		if( HasVal(arr, field1) )
			continue
		
		name := scaffoldModel("¿ valueS1 ¿")
		
		; check if "an" or "a" should be used
		aOrAn := "a"
		vowels := ["a", "e", "i", "o", "u"]
		firstCharacter := SubStr(field1, 1, 1)
		if( HasVal(vowels, firstCharacter) )
			aOrAn := "an"
		
		if(field4 != ""){
			t := "`                    <div class=""w-full md`:w-1/2 px-3 mb-6 md`:mb-0"">`n                        <x-input.group for=""¿ valueS1 ¿"" label=""¿ valueAT91 ¿"" `:error=""$errors->first('editing.¿ valueS1 ¿')"">`n                            <livewire`:¿ valueSH4 ¿.select-¿ valueSH4 ¿`n                              name=""¿ valueS4 ¿""`n                              placeholder=""Choose " aOrAn " ¿ valueL4 ¿""`n                              `:searchable=""true""`n                            />`n                        </x-input.group>`n                    </div>`n`n"
			without_id := StrReplace(field1, "_id", "")
			t := replaceMarker(without_id, t, 91)
		}else 
		if(field2 = "datetime" or field2 = "timestamp" or field2 = "date" )
			t := "`                    <div class=""w-full md`:w-1/2 px-3 mb-6 md`:mb-0"">`n                        <x-input.group for=""¿ valueS1 ¿_for_editing"" label=""¿ valueAT1 ¿"" `:error=""$errors->first('editing.¿ valueS1 ¿_for_editing')"">`n                            <x-input.date wire`:model=""editing.¿ valueS1 ¿_for_editing"" id=""¿ valueS1 ¿_for_editing"" />`n                        </x-input.group>`n                    </div>`n`n"
		else if(field2 = "int")
			t := "`                <x-input.group for=""¿ valueS1 ¿"" label=""¿ valueAT1 ¿"" `:error=""$errors->first('editing.¿ valueS1 ¿')"">`n                    <x-input.money wire`:model=""editing.¿ valueS1 ¿"" id=""¿ valueS1 ¿"" />`n                </x-input.group>`n`n"
		else
			t := "`                    <div class=""w-full md`:w-1/2 px-3 mb-6 md`:mb-0"">`n                        <x-input.group for=""¿ valueS1 ¿"" label=""¿ valueAT1 ¿"" `:error=""$errors->first('editing.¿ valueS1 ¿')"">`n                            <x-input.text wire`:model=""editing.¿ valueS1 ¿"" id=""¿ valueS1 ¿"" placeholder=""¿ valueAT1 ¿"" />`n                        </x-input.group>`n                    </div>`n`n"
		
		t := replaceMarker(field1, t, 1)
		t := replaceMarker(field4, t, 4)
		t := replaceMarker(field5, t, 5)
		output := output t
	}
	
	return output
}
	
createLiveWireManageView(){
	global clipList, scaffold_template, oldClipList, modelName, clipList_A_Index, project_path
		
	name := scaffoldModel("¿ valueS1 ¿")
	form_fields := scaffold_LiveWireManageView_fields()

	
	content := scaffoldModel("<x-slot name=""header"">`n    <h2 class=""font-semibold text-xl text-gray-800 leading-tight"">`n        {{ __('¿ valueAT2 ¿') }}`n    </h2>`n</x-slot>`n<div class=""max-w-7xl mx-auto px-4 sm`:px-6 lg`:px-8"">`n    @if (session()->has('message'))`n        <div id=""alert"" class=""text-white px-6 py-4 border-0 rounded relative mb-4 bg-green-500"">`n            <span class=""inline-block align-middle mr-8"">`n                {{ session('message') }}`n            </span>`n            <button class=""absolute bg-transparent text-2xl font-semibold leading-none right-0 top-0 mt-4 mr-6 outline-none focus`:outline-none"" onclick=""document.getElementById('alert').remove()`;"">`n                <span>�</span>`n            </button>`n        </div>`n    @endif`n`n`n    <div class=""w-full align-center"">`n        <div class=""float-left"">`n            <h1 class=""font-semibold leading-tight text-2xl mt-4 mb-2 text-gray-900"">`n                <a href=""{{ route('¿ valueSH2 ¿') }}"">`n                    ¿ valueAT1 ¿`n                </a>`n                -> {{ $editing['id'] ? 'Edit' `: 'Create' }}</h1>`n        </div>`n        <div class=""float-left"">`n            <a href=""{{ $editing['id'] ? route('¿ valueSH2 ¿.show'`, $editing['id']) `: route('¿ valueSH2 ¿') }}"">`n                <x-button.secondary class=""bg-white text-secondary m-4 mb-0"" >`n                    <div class=""flex space-x-2 items-center""> `n                        <x-icon.arrow-circle-left/>`n                        <span> Back </span>`n                    </div>`n                </x-button.secondary>`n            </a>`n        </div>`n    </div>`n`n    <div class=""py-10"">`n        <div class=""inline-block min-w-full shadow rounded-lg overflow-hidden"">`n            <form>`n                <div class=""px-4 pt-5 pb-4 sm`:p-6 sm`:pb-4"">`n                    <div class=""flex flex-wrap -mx-3 mb-6"">`n" form_fields "                    </div>`n                </div>`n                <div class=""px-4 py-3 sm`:px-6 sm`:flex sm`:flex-row-reverse"">`n                <span class=""flex w-full sm`:ml-3 sm`:w-auto"">`n                    <button wire`:click.prevent=""save()"" type=""button"" class=""inline-flex bg-blue-500 hover`:bg-blue-700 text-white font-bold py-2 px-4 rounded"">Save</button>`n                </span>`n                </div>`n            </form> `n        </div>`n    </div>`n</div>`n`n@push('styles')`n<link rel=""stylesheet"" href=""https`://cdn.jsdelivr.net/npm/sweetalert2@10/dist/sweetalert2.min.css"">`n@endpush`n`n@push('scripts')`n<script src=""https`://cdn.jsdelivr.net/npm/sweetalert2@10""></script>`n<script src=""https`://cdn.jsdelivr.net/npm/promise-polyfill@8/dist/polyfill.js""></script>`n<script type=""text/javascript"">`n    document.addEventListener('DOMContentLoaded'`, function () {`n`n    })`n</script>`n@endpush")
	
	name := scaffoldModel("¿ valueSH1 ¿\manage-¿ valueSH1 ¿")
	file =%project_path%\resources\views\livewire\%name%.blade.php
	
	FileDelete, %file%
	FileAppend, %content%, %file%
}

scaffold_ShowView_Fields(){
	global oldClipList
	
	clipList := "id`tbigint(20)`t`n" oldClipList
	StringSplit, clipList, clipList, `n, `r
	output=
	
	Loop %clipList0%
	{
		field := clipList%A_Index%
		StringSplit, field, field, `t
		
		arr := ["deleted_at"]

		if( HasVal(arr, field1) )
			continue
		
		name := scaffoldModel("¿ valueS1 ¿")
		plural := scaffoldModel("¿ valueSH2 ¿")
		
		if(field4 != "") ; if relation is there
		{
			t := "`                <div class=""md`:w-1/4 px-3 mb-6 md`:mb-0  border-b"">`n                    <label class=""block text-gray-700 text-sm mb-2"">`n                        Business Entity Id`:`n                    </label>`n                </div>`n                <div class=""md`:w-1/4 px-3 mb-6 md`:mb-0"">`n                    <a href=""{{ $" name "['¿ valueS1 ¿'] ? route('business-entities.show'`, $" name "['¿ valueS1 ¿']) `: '' }}"">`n                        <span class=""inline-flex space-x-2 truncate text-sm leading-5 font-bold"">`n                            {{ $" name "->¿ valueC91 ¿ ? $" name "->¿ valueC91 ¿->name `: """" }}`n                        </span>`n                    </a>`n                </div>`n`n"
			without_id := StrReplace(field1, "_id", "")
			t := replaceMarker(without_id, t, 91)
		}else if(field2 = "datetime" or field2 = "timestamp" )
			t := "`                <div class=""md`:w-1/4 px-3 mb-6 md`:mb-0 border-b "">`n                    <label class=""block text-gray-700 text-sm mb-2"">`n                        ¿ valueAT1 ¿`:`n                    </label>`n                </div>`n                <div class=""md`:w-1/4 px-3 mb-6 md`:mb-0 "">`n                    <span class=""inline-flex space-x-2 truncate text-sm leading-5 font-bold"">`n                        {{ getDateForHumans($" name "->¿ valueS1 ¿) }}`n                    </span>`n                </div>`n`n"
		else 
			t := "`                <div class=""md`:w-1/4 px-3 mb-6 md`:mb-0 border-b "">`n                    <label class=""block text-gray-700 text-sm mb-2"">`n                        ¿ valueAT1 ¿`:`n                    </label>`n                </div>`n                <div class=""md`:w-1/4 px-3 mb-6 md`:mb-0 inline-flex space-x-2 text-sm leading-5 font-bold"">`n                    {{ $" name "->¿ valueS1 ¿ }}`n                </div>`n`n"
		
		t := replaceMarker(field1, t, 1)
		t := replaceMarker(field4, t, 4)
		t := replaceMarker(field5, t, 5)
		output := output t
	}
	
	return output
}
	
createLiveWireShowView(){
	global clipList, scaffold_template, oldClipList, modelName, clipList_A_Index, project_path
	
	name := scaffoldModel("¿ valueS1 ¿")
	form_fields := scaffold_ShowView_Fields()

	
	content := scaffoldModel("<div class=""max-w-7xl mx-auto px-4 sm`:px-6 lg`:px-8"">`n    @if (session()->has('message'))`n        <div id=""alert"" class=""text-white px-6 py-4 border-0 rounded relative mb-4 bg-green-500"">`n            <span class=""inline-block align-middle mr-8"">`n                {{ session('message') }}`n            </span>`n            <button class=""absolute bg-transparent text-2xl font-semibold leading-none right-0 top-0 mt-4 mr-6 outline-none focus`:outline-none"" onclick=""document.getElementById('alert').remove()`;"">`n                <span>x</span>`n            </button>`n        </div>`n    @endif`n`n    <div class=""w-full align-center"">`n        <div class=""float-left"">`n            <h1 class=""font-semibold leading-tight text-2xl mt-4 mb-2 text-gray-900"">`n                <a href=""{{ route('¿ valueSH2 ¿') }}"">`n                    ¿ valueAT1 ¿`n                </a>`n                -> View</h1>`n        </div>`n        <div class=""float-left"">`n            <a href=""{{ route('¿ valueSH2 ¿'`, $¿ valueS1 ¿['id']) }}"">`n                <x-button.secondary class=""bg-white text-secondary m-4 mb-0"">`n                    <div class=""flex space-x-2 items-center""> `n                        <x-icon.arrow-circle-left/>`n                        <span> Back </span>`n                    </div>`n                </x-button.secondary>`n            </a>`n        </div>`n        <div class=""float-right"">`n            <a href=""{{ route('¿ valueSH2 ¿.edit'`, $¿ valueS1 ¿['id']) }}"">`n                <x-button.link class=""text-secondary m-5 mb-0"" >`n                    <div class=""flex space-x-2 items-center""> `n                        <x-icon.pencil/>`n                        <span></span>`n                    </div>`n                </x-button.link>`n            </a>`n            <x-button.link class=""text-secondary m-5 mb-0"" wire`:click=""$emit('triggerDelete'`,{{ $¿ valueS1 ¿['id'] }})"" >`n                <div class=""flex space-x-2 items-center""> `n                    <x-icon.trash/>`n                    <span></span>`n                </div>`n            </x-button.link>`n        </div>`n    </div>`n`n    <div class=""py-10 "">`n        <div class=""my-10 inline-block min-w-full shadow rounded-lg overflow-hidden bg-white p-10"">`n            <div class=""flex flex-wrap -mx-3 mb-10"">`n            </div>`n            <div class=""flex flex-wrap -mx-3 mb-6 "">`n" form_fields "            </div>`n        </div>`n    </div>`n</div>`n`n@push('styles')`n<link rel=""stylesheet"" href=""https`://cdn.jsdelivr.net/npm/sweetalert2@10/dist/sweetalert2.min.css"">`n@endpush`n`n@push('scripts')`n<script src=""https`://cdn.jsdelivr.net/npm/sweetalert2@10""></script>`n<script src=""https`://cdn.jsdelivr.net/npm/promise-polyfill@8/dist/polyfill.js""></script>`n<script type=""text/javascript"">`n    document.addEventListener('DOMContentLoaded'`, function () {`n`n        @this.on('triggerDelete'`, ¿ valueS1 ¿Id => {`n            Swal.fire({`n                title`: 'Are You Sure?'`,`n                text`: '¿ valueAT1 ¿ record will be deleted!'`,`n                type`: ""warning""`,`n                showCancelButton`: true`,`n                confirmButtonColor`: '#d33'`,`n                cancelButtonColor`: '#3085d6'`,`n                confirmButtonText`: 'Delete!'`n            }).then((result) => {`n                if (result.value) {`n                    @this.call('delete'`,¿ valueS1 ¿Id)`n                } else {`n                    console.log(""Canceled"")`;`n                }`n            })`;`n        })`;        `n    })`n</script>`n@endpush")
	
	name := scaffoldModel("¿ valueSH1 ¿\show-¿ valueSH1 ¿")
	file =%project_path%\resources\views\livewire\%name%.blade.php
	
	FileDelete, %file%
	FileAppend, %content%, %file%
}

scaffold_LiveWireImportView_form_fields(){
	global oldClipList
	StringSplit, oldClipList, oldClipList, `n, `r
	output=
	
	Loop %oldClipList0%
	{
		field := oldClipList%A_Index%
		StringSplit, field, field, `t
		
		name := scaffoldModel("¿ valueS1 ¿")
		
		if(field2 = "datetime" or field2 = "timestamp")
			t := "`                    <x-input.group for=""¿ valueS1 ¿"" label=""¿ valueAT1 ¿"">`n                        <x-input.select wire`:model=""fieldColumnMap.¿ valueS1 ¿_for_editing"" id=""¿ valueS1 ¿"">`n                            <option value="""" disabled>Select Column...</option>`n                            @foreach ($columns as $column)`n                                <option>{{ $column }}</option>`n                            @endforeach`n                        </x-input.select>`n                    </x-input.group>`n                    `n"
		else
			t := "`                    <x-input.group for=""¿ valueS1 ¿"" label=""¿ valueAT1 ¿"" `:error=""$errors->first('fieldColumnMap.¿ valueS1 ¿')"">`n                        <x-input.select wire`:model=""fieldColumnMap.¿ valueS1 ¿"" id=""¿ valueS1 ¿"">`n                            <option value="""" disabled>Select Column...</option>`n                            @foreach ($columns as $column)`n                                <option>{{ $column }}</option>`n                            @endforeach`n                        </x-input.select>`n                    </x-input.group>`n`n"
		
		t := replaceMarker(field1, t, 1)
		t := replaceMarker(field4, t, 3)
		output := output t
	}
	
	return output
}

createLiveWireImportView(reverse = 0){
	global clipList, scaffold_template, oldClipList, modelName, clipList_A_Index, project_path
	
	form_fields := scaffold_LiveWireImportView_form_fields()
	
	name := scaffoldModel("¿ valueSH1 ¿\import-¿ valueSH2 ¿")
	file =%project_path%\resources\views\livewire\%name%.blade.php
	
	if(reverse){
		FileRead, content, %file%
		StringReplace, content, content, `r, , All
		
		StringReplace, content, content, %form_fields%, " form_fields "
	}else{
		content := scaffoldModel("<div>`n    <x-button.secondary wire`:click=""$toggle('showModal')"" class=""flex items-center space-x-2""><x-icon.upload class=""text-cool-gray-500""/> <span>Import</span></x-button.secondary>`n`n    <form wire`:submit.prevent=""import"">`n        <x-modal.dialog wire`:model=""showModal"">`n            <x-slot name=""title"">Import ¿ valueAT2 ¿</x-slot>`n`n            <x-slot name=""content"">`n                @unless ($upload)`n                <div class=""py-12 flex flex-col items-center justify-center "">`n                    <div class=""flex items-center space-x-2 text-xl"">`n                        <x-icon.upload class=""text-cool-gray-400 h-8 w-8"" />`n                        <x-input.file-upload wire`:model=""upload"" id=""upload""><span class=""text-cool-gray-500 font-bold"">CSV or Excel File</span></x-input.file-upload>`n                    </div>`n                    @error('upload') <div class=""mt-3 text-red-500 text-sm"">{{ $message }}</div> @enderror`n                </div>`n                @else`n                <div>`n" form_fields "                </div>`n                @endif`n            </x-slot>`n`n            <x-slot name=""footer"">`n                <x-button.secondary wire`:click=""$set('showModal'`, false)"">Cancel</x-button.secondary>`n`n                <x-button.primary type=""submit"">Import</x-button.primary>`n            </x-slot>`n        </x-modal.dialog>`n    </form>`n</div>`n")
	}
	
	directory := scaffoldModel("¿ valueSH1 ¿")
	FileCreateDir, %project_path%\resources\views\livewire\%directory%

	FileDelete, %file%
	FileAppend, %content%, %file%
}

updateRoutesFile(){
	global clipList, scaffold_template, oldClipList, modelName, clipList_A_Index, project_path
	
	route := scaffoldModel("`    Route`:`:group(['prefix' => '¿ valueSH2 ¿']`, function () {`n        Route`:`:get('/'`, App\Http\Livewire\¿ valueCC1 ¿\List¿ valueCC2 ¿`:`:class)->name('¿ valueSH2 ¿')`;`n        Route`:`:get('/create'`, App\Http\Livewire\¿ valueCC1 ¿\Manage¿ valueCC1 ¿`:`:class)->name('¿ valueSH2 ¿.create')`;`n        Route`:`:get('/{businessEntityType}/edit'`, App\Http\Livewire\¿ valueCC1 ¿\Manage¿ valueCC1 ¿`:`:class)->name('¿ valueSH2 ¿.edit')`;`n        Route`:`:get('/{businessEntityType}'`, App\Http\Livewire\¿ valueCC1 ¿\Show¿ valueCC1 ¿`:`:class)->name('¿ valueSH2 ¿.show')`;`n    })`;`n`n")
	
	file =%project_path%\routes\web.php
	FileRead, content, %file%
	StringReplace, content, content, `}); // group end, %route%`}); // group end
	
	FileDelete, %file%
	FileAppend, %content%, %file%
}
	
updateSidebar(){
	global clipList, scaffold_template, oldClipList, modelName, clipList_A_Index, project_path
	
	item := scaffoldModel("`                    <a href=""{{ route('¿ valueSH2 ¿') }}"" class=""block px-4 py-2 mt-2 text-sm font-semibold bg-transparent rounded-lg dark-mode`:bg-transparent dark-mode`:hover`:bg-gray-600 dark-mode`:focus`:bg-gray-600 dark-mode`:focus`:text-white dark-mode`:hover`:text-white dark-mode`:text-gray-200 md`:mt-0 hover`:text-gray-900 focus`:text-gray-900 hover`:bg-gray-200 focus`:bg-gray-200 focus`:outline-none focus`:shadow-outline"">¿ valueAT2 ¿</a>`n`n")
	
	file := "%project_path%\resources\views\layouts\sidebar.blade.php"
	FileRead, content, %file%
	StringReplace, content, content, `r,
	StringReplace, content, content, `                    <!-- Insert new menu items here -->, %item%`                    <!-- Insert new menu items here -->, All
	
	FileDelete, %file%
	FileAppend, %content%, %file%
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
	
	name := scaffoldModel("¿ valueS2 ¿")
	
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
	
	name := scaffoldModel("¿ valueS2 ¿")
	
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
	singularToPlural["contact_information_type"] := "contact_information_types"
	singularToPlural["atoll"] := "atolls"
	singularToPlural["island"] := "islands"
	singularToPlural["country"] := "countries"
	singularToPlural["operation_type"] := "operation_types"
	singularToPlural["organisation_type"] := "organisation_types"
	singularToPlural["operation_log"] := "operation_logs"
	singularToPlural["user_organisation"] := "user_organisations"
	singularToPlural["business_entity_type"] := "business_entity_types"
	singularToPlural["business_entitie"] := "business_entities"
	singularToPlural["user"] := "users"
	singularToPlural["password_reset"] := "password_resets"
	singularToPlural["document_type"] := "document_types"
	singularToPlural["file"] := "files"
	singularToPlural["failed_job"] := "failed_jobs"
	singularToPlural["personal_access_token"] := "personal_access_tokens"
	singularToPlural["action"] := "actions"
	singularToPlural["location_type"] := "location_types"
	singularToPlural["location"] := "locations"
	singularToPlural["auditlogactiontype"] := "auditlogactiontypes"
	singularToPlural["auditlogdatatype"] := "auditlogdatatypes"
	singularToPlural["auditlog"] := "auditlogs"
	singularToPlural["business_entity_contact_information"] := "business_entity_contact_informations"
	singularToPlural["business_entity_document"] := "business_entity_documents"
	singularToPlural["business_entity_location_type"] := "business_entity_location_types"
	singularToPlural["business_entity_location"] := "business_entity_locations"
	singularToPlural["errorlog"] := "errorlog"
	singularToPlural["gender_type"] := "gender_types"
	singularToPlural["individual"] := "individuals"
	singularToPlural["link_type"] := "link_types"
	singularToPlural["role"] := "roles"
	singularToPlural["navigation_link"] := "navigation_links"
	singularToPlural["organisation"] := "organisations"
	singularToPlural["request_state"] := "request_states"
	singularToPlural["sequence_number_type"] := "sequence_number_types"
	singularToPlural["request_type"] := "request_types"
	singularToPlural["request"] := "requests"
	singularToPlural["request_document"] := "request_documents"
	singularToPlural["request_types_allowed_request_state_transition"] := "request_types_allowed_request_state_transitions"
	singularToPlural["request_type_specific_document_type"] := "request_type_specific_document_types"
	singularToPlural["role_action"] := "role_action"
	singularToPlural["sequence_number_next_number"] := "sequence_number_next_numbers"
	singularToPlural["sso_user_state"] := "sso_user_state"
	singularToPlural["user_group"] := "user_groups"
	singularToPlural["user_assigned_user_group"] := "user_assigned_user_groups"
	singularToPlural["user_group_role"] := "user_group_roles"
	singularToPlural["department"] := "departments"
	singularToPlural["ward"] := "wards"
	singularToPlural["case"] := "cases"
	singularToPlural["case_attachment"] := "case_attachments"
	singularToPlural["case_user"] := "case_users"
	singularToPlural["comment"] := "comments"
	singularToPlural["gems_mail"] := "gems_mails"
	singularToPlural["task"] := "tasks"
	
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
