
:: This batch file checks input _tri.raw,
@echo on
:: OUTPUT
:: OUTPUT
@echo Run segmentation
Segmentation.exe -i hepta_tri.k -o hepta_initial_write.k -m hepta_manual.txt -l 0.1
@echo Done!
@echo -------------------------------------------------------------------
@pause
:: OUTPUT
@echo Create polycube structure
PolyCube.exe -i hepta_initial_read.k -o hepta_polycube_structure.k -c 1
@echo Done!
@echo -------------------------------------------------------------------
@pause
:: OUTPUT
@echo Generate hex mesh
ParametricMapping.exe -i hepta_initial_read.k -p hepta_polycube_structure_hex.k -o hepta_hex_initial.vtk -s 2
@echo Done!
@echo -------------------------------------------------------------------
@pause
@echo Fix interior points 
Quality.exe -I hepta_hex_initial.vtk   -m 0 -n 1 
@echo Done!
@echo -------------------------------------------------------------------
@pause

@echo Pillowing
Quality.exe -I hepta_hex_initial_lap.vtk   --method 1 --number 1
@echo Done!
@echo If needed, prepare sharp feature in sharp.txt before moving to next step
@echo -------------------------------------------------------------------
@pause

@echo Smooth  points
Quality.exe -I hepta_hex_initial_lap_pillow.vtk --method 2 --parameter 0.001 --number 1 --sharp 2 
@echo Done!
@echo -------------------------------------------------------------------
@pause

@echo Optimize element with minimum Jacobian
Quality.exe -I hepta_hex_initial_lap_pillow_smooth.vtk   --method 3 --parameter 0.001 --number 15
@echo Done!
@echo -------------------------------------------------------------------
@pause

@echo Spline construction of hepta model with no refinement and output LS-DYNA simulation file
Hex2Spline.exe -I hepta_hex.vtk -S -s 2 
@echo Done!
@echo -------------------------------------------------------------------
@pause

@echo Spline construction of hepta model with one global refinement and output LS-DYNA simulation file
Hex2Spline.exe -I hepta_hex.vtk -S -s 2 -g 1
@echo Done!
@echo -------------------------------------------------------------------
@pause

@echo Spline construction of hepta model with level-2 local refinement and output LS-DYNA simulation file
Hex2Spline.exe -I hepta_hex.vtk -S -s 2 -l 
@echo Done!
@echo -------------------------------------------------------------------
@pause

 
