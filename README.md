# Scaffolder

- Create templates from existing files using unscaffolding feature
- Inject conditional or repetitive elements into the main template
- Use database structure and scaffold based on field names, data types, nullability and relationships

## Runtime Environment:

1. AutoHotkey v1.1
2. phpMyAdmin
3. Windows operating system


## Commands

- Scaffold: Press Accent key, it is below Escape key on the keyboard
- Unscaffold: Select text and press Ctrl + Shift + Accent
- Output marker: Shift + Accent
- Output marker for nested scaffold: Copy varible name and press Ctrl + Accent
- Exit: Ctrl + Alt + X
- Comment/uncomment in Scite: Ctrl + Q
- Save and reload script: F5 in Scite
- Go to function: Click a function name, Press Ctrl + F, Press F3

## Setup

- Download AutoHotkey.zip
- Extract and open AutoHotkey\SciTE\SciTE.exe
- Open scaffolder.ahk in SciTE
- Update phpMyAdmin URLs and project path (eg:- php project)
![image](https://user-images.githubusercontent.com/16064343/170838135-dd51c052-a5c6-457e-9cc5-225d77a8eb2c.png)
![image](https://user-images.githubusercontent.com/16064343/170838118-a684e53e-d41c-44ca-90c3-147529a15fe1.png)

## Usage

### Repetitive injection
1. create a main scaffolding function and sub scaffolding function(s) (you can place at the end of the script or anywhere you prefer, sample given in sample_scaffolding_function_template.ahk)
2. Update table_or_field_name in Scite (put field name) ![image](https://user-images.githubusercontent.com/16064343/170840769-da2763cf-3840-4db0-bc70-deb99d87c544.png)
3. Press F5 in Scite (to save and reload script)
4. Select exisiting text (for one field only) ![image](https://user-images.githubusercontent.com/16064343/170840800-eb47bf4d-34b7-4da0-9439-9f7f56e36b45.png)
5. Press Ctrl + Shift + Accent to unscaffold
6. Paste in repetitive injection ![image](https://user-images.githubusercontent.com/16064343/170842051-7a1edb02-7323-4b6a-9c8d-56cecbeda93f.png)
7. Copy resulting variable name ![image](https://user-images.githubusercontent.com/16064343/170842385-718cd3bc-10a9-42c2-bc6d-6096839c4394.png)
8. Select the repetitive lines (for all fields) and press Ctrl + Accent to output marker for repetitive injection
9. Repeat steps 2-8 if your existing file has more sections that need repetitive injection 

### Main template
1. Update table_or_field_name in Scite (put table name)
2. Press F5 in Scite (to save and reload script)
3. Select all the text in the exising file
4. Press Ctrl + Shift + Accent to unscaffold
5. Paste in main template placeholder ![image](https://user-images.githubusercontent.com/16064343/170842691-9ed02bf1-14d5-450b-8ddf-fa3ffc3a6402.png)
6. Add a call to sample_main_function() inside scaffoldFiles() function

### Run Scaffolder
1. Press Accent key
