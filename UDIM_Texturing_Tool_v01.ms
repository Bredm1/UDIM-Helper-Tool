-- ////////////////////////////////////////////////////////////////////////////////
--		SCRIPT: UDIM texturing helper tool
--		VERSION: 1.0.0a
--
--		AUTHOR: Tamás Nagy
--		DATE: 26 10 2017
--
--		USAGE: Help tools for working older 3ds max with big uv space object
--
--	      BUGS:
--
--		NOTES: For work with Mari
--
--		UPDATE LOG:
--						- 17.11.06 --> import selfilum script bug fixed
-- ////////////////////////////////////////////////////////////////////////////////



-- /// DESTROY PREVIOUSLY CREATED GUI \\\
try(DestroyDialog UV_ID_GENERATOR)catch()


-- /// GUI CREATION \\\
rollout UV_ID_GENERATOR "UV_Space to Mat_ID" width:540 height:150
(
	
	groupBox USER_CTRL_UV_GUI_GBOX "Generate Material ID's:" width:200 height:140 pos:[5,2]
	
	spinner TileNumber "Number of tiles:" range:[1,40,10] type:#integer pos:[10,20] fieldwidth: 50
	
	button Start "Start" pos:[10, 40]
	
	label lab1 "From UV tile coordinates set material ID's to the modell for easier and faster material editing." style_sunkenedge:true width:190 height:65 pos:[10,70]

	
	groupBox USER_CTRL_MAT_GUI_GBOX "Generate Multi Material:" width:200 height:140 pos:[210,2]
	
	spinner MATERIAL_NUMBER "Material Slot:" range:[1,24,1] type:#integer pos:[220,20] fieldwidth: 35
	
	radioButtons IMG_EXTENSION "Extension:" tooltip:"Test Tooltip 1" labels:#("JPG", "PNG", "TIFF", "PSD") columns:1 pos:[220,50]
	
	button Start2 "Start" pos:[360, 15]
	
	label lab2 "After select MatSlot, Extension and Folder path, creates a MultiMaterial with vray material inside, loaded picurates from the choosed path." style_sunkenedge:true width:115 height:95 pos:[290,40]

	
	
	groupBox USER_SELF_ILLUM_GUI_GBOX "Set self-illum:" width:120 height:140 pos:[415,2]
	
	spinner MATERIAL_NUMBER_ILL "Material Slot:" range:[1,24,1] type:#integer pos:[420,20] fieldwidth: 35
	
	spinner SELF_ILLUM_AMOUNT "Self-illum:" range:[1,500,100] type:#integer pos:[437,45] fieldwidth: 35
	
	label lab3 "Changes the Self-illum of the all materials inside a MultiMaterial. Only works on MultiMaterial's." style_sunkenedge:true width:110 height:70 pos:[420,65]

	

	-- ///FUNCTIONS\\\
	
	fn UV_ID_GENERATOR idCount = ( -- SETS THE MATERIAL ID'S OF THE MODELL BY UV COORDINATES FOR EASYER TEXTURING AND WORKING WITH MARI
		
		-- 'idCount' <-- CIRCA NUMBER OF UV ID'S GIBEN BY USER

		modPanel.setCurrentObject $.modifiers[#Unwrap_UVW] -- SWITCH THE CURRENT SELECTED MODIFIER TO UNWRAP

		$.modifiers[#unwrap_uvw].unwrap.edit() -- OPEN UV EDITOR WINDOW

		actionMan.executeAction 0 "40021" -- SELECT ALL VERTEX

		allVertex = $.modifiers[#unwrap_uvw].unwrap.getSelectedVertices() -- GET ALL SELECTED VERTEX NIMBER IN AN ARRAY

		actionMan.executeAction 0 "40043" -- DESELECT ALL VERTEX

		vertexForSelection = #{} --MAKE EMPTY ARRAY FOR SELECTABLE VERTEX

		idSelectionCoordinates = # (
			-- FIRTS HORISONTAL LINE UP TO TEN
			#(0, 1, 0, 1),
			#(1, 2, 0, 1),
			#(2, 3, 0, 1),
			#(3, 4, 0, 1),
			#(4, 5, 0, 1),
			#(5, 6, 0, 1),
			#(6, 7, 0, 1),
			#(7, 8, 0, 1),
			#(8, 9, 0, 1),
			#(9, 10, 0, 1),
			
			-- SECOND HORISONTAL LINE UP TO TEN
			#(0, 1, 1, 2),
			#(1, 2, 1, 2),
			#(2, 3, 1, 2),
			#(3, 4, 1, 2),
			#(4, 5, 1, 2),
			#(5, 6, 1, 2),
			#(6, 7, 1, 2),
			#(7, 8, 1, 2),
			#(8, 9, 1, 2),
			#(9, 10, 1, 2),
			
			-- THIRD HORISONTAL LINE UP TO TEN
			#(0, 1, 2, 3),
			#(1, 2, 2, 3),
			#(2, 3, 2, 3),
			#(3, 4, 2, 3),
			#(4, 5, 2, 3),
			#(5, 6, 2, 3),
			#(6, 7, 2, 3),
			#(7, 8, 2, 3),
			#(8, 9, 2, 3),
			#(9, 10, 2, 3),
			
			#(0, 1, 3, 4),
			#(1, 2, 3, 4),
			#(2, 3, 3, 4),
			#(3, 4, 3, 4),
			#(4, 5, 3, 4),
			#(5, 6, 3, 4),
			#(6, 7, 3, 4),
			#(7, 8, 3, 4),
			#(8, 9, 3, 4),
			#(9, 10, 3, 4)
			
			) -- UV SPACE COORDINATES FOR SELECTION (U, V)

		idSelectionCoordinates.count = idCount -- SETS THE ARRAY LENGHT TO DEFINED BY USER
					
		idToSet = 1 --  A GROWNIG VARIABLE FOR ID-ING

		for coord in idSelectionCoordinates do( -- TEST ALL TE ELEMENST OF THE UV COORDINATE ARRAY
			
			for i in allVertex do ( -- TEST EVERY VERTEX IN LIST FOR POSITION
				
				vertPosition = $.modifiers[#unwrap_uvw].unwrap.getVertexPosition 0 i -- GET THE VERTEX POSITION IN A VARIABLE
				
				if vertPosition[1] >= coord[1] and vertPosition[1] <= coord[2] and vertPosition[2] >= coord[3] and vertPosition[2] <= coord[4] then (
					
					append vertexForSelection i -- IF THE VERTEX POSITION IN RANGE, SAVES THE NAME IN THE SELECTABLE VERTEX ARRAY
				
				) -- TEST'S THE SELECTED VERTEX POSITION IN UV SPACE
			
			)
			
			$.modifiers[#unwrap_uvw].unwrap6.selectVerticesByNode vertexForSelection $ -- SELECT VERTICLES FROM LIST 

			$.modifiers[#unwrap_uvw].unwrap2.vertToFaceSelect() -- CONVERT VERTEX SELECTION TO FACE SELECTION 

			$.modifiers[#unwrap_uvw].unwrap2.setTVSubObjectMode 3 -- SWITCH SELECTION MODE TO FACES

			facesForSelection = $.modifiers[#unwrap_uvw].unwrap2.getSelectedFaces() -- STORE THE FACES IN A VARIABLE

			polyop.setFaceMatID $ facesForSelection idToSet -- SETS THE SLECTED FACES TO THE RIGHT ID
					
			vertexForSelection = #{} -- RESET THE VERTEX SELECTION RANGE
			
			facesForSelection = 0 -- RESET THE FACE SELECTION RANGE
					
			idToSet = idToSet + 1 -- INCREASE THE ID NUMBER BY ONE

		)

	)
	
	fn MULTIMAT_SELFILUM_SETTER mat_num precent = (
		
		-- // INPUT VARIABLE EXPLANATION \\ --
		-- !mat_num! = number of the target slot by the mat browser //////   !precent! = the wanted selfilum value --
		
		mat_ID = meditMaterials[mat_num] -- put the selected multimat in a variable
		
		sub_mat_num = mat_ID.count -- get te number of contained material inside the multimaterial
		
		for i in 1 to sub_mat_num do (
			
			meditMaterials[mat_num].materialList[i].texmap_self_illumination_multiplier = precent
			-- sets the selfilum in all contained material
		)
		-- DONE
	)
	
	
	fn MULTI_MATERIAL_MAKER mat_slot kiterjesztes_NUM  = (

		--  "mat_slot"  MATERIAL SLOT CHOOSABLE BY USER

		kiterjesztes_lista = #(".jpg", ".png", ".tif", ".psd") -- image existensions choosable by the user

		image_folder_path = getSavePath caption:"Path To Mari Picurates"  -- OPEN PATH SEARCH WINDOW FOR USER

		image_names_and_path = getFiles (image_folder_path + "\*" + kiterjesztes_lista[kiterjesztes_NUM]) -- GET FILES FROM TARGET FOLDER WITH .JPG EXISTENSION

		number_of_images = image_names_and_path.count -- get the number of images in the folder

		for f in image_names_and_path do (print objects) -- PRINT FILE NAMES FROM FOLDER

		meditMaterials[mat_slot] = Multimaterial () -- CREATE MULTI MATERIAL TO EDITOR SLOT ONE

		for i in 1 to number_of_images do (
			
			meditMaterials[mat_slot].materialList[i] = VRayMtl () -- PUT VRAY MATERIAL TO MULTI MATERIAL ID ONE
			
			current_bitmap_Texture = Bitmaptexture fileName: image_names_and_path[i] -- stores the current image in a bitmap variable
			
			current_bitmap_Texture.coords.blur = 0.01 -- Sets the current bitamp blur to the lowest
			
			meditMaterials[mat_slot].materialList[i] .texmap_diffuse = current_bitmap_Texture -- SELECT PICURATE TO DIFFUSE IN VRAY
			
			meditMaterials[mat_slot].materialList[i] .texmap_self_illumination = current_bitmap_Texture -- SELECT PICURATE TO SELF-ILLUM IN VRAY
			
			meditMaterials[mat_slot].materialList[i] .texmap_bump = current_bitmap_Texture -- SELECT PICURATE TO SELF-ILLUM IN VRAY
			
		)

)

	

	-- /// EXECUTION \\\
	
	on Start pressed do
	(
		UV_ID_GENERATOR TileNumber.value
	)
			
	
	on Start2 pressed do
	(
		MULTI_MATERIAL_MAKER MATERIAL_NUMBER.value IMG_EXTENSION.state
	)
	
	on SELF_ILLUM_AMOUNT changed spinVal do
	(
		MULTIMAT_SELFILUM_SETTER MATERIAL_NUMBER_ILL.value spinVal
	)
	
)

createDialog UV_ID_GENERATOR