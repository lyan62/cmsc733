1.Run code for part1:
1)launch into ./Code/Part1 as current directory(i.e. make sure the path ends with"\Code\Part1" when type pwd in MATLAB)
2)then run PinIt.m

Output:
All the output images will be saved in the current directory,including:
colored_pins.png              ->which displayed all the colored pins(except white and transparent)
Pins_in_Different_Color.png   ->which displayed clustered results.
IndividualColoredObjects.png  ->which displayed pins and the number of pins in each cluster
whitepin.png                  ->which displayed the results of detecting the white pin

2. Run code for part2:
1)launch into ./Code/Part2 as current directory(i.e. make sure the path ends with"\Code\Part2" when type pwd in MATLAB)
2)then run shakeboundary.m will generate all the output

note: all the functions defined and used in the shakeboundary.m are saved in the stencil folder of Benchmark;
texton maps generated with LM and MR filters are also saved in the required TextonMap directory for reference with names as TextonMapLM_ImageName.png and TextonMapMR_ImageName.png;
filters can be easily changed if wanted by uncommenting the correspounding lines indicated in the tmap section of shakeboundary.m and the output images will be saved in the required directory



Output:
1)The images required by the homework description are all saved into coorespounding Image folders
2)Images of Filterbanks(including gaussian(gausssianFB.png), LM(LMFB.png), S(SFB.png) and MR filterbanks(MRFB.png)), image of PR_Curve(PR_Curve.png), 
and image of half-disc masks(HDMasks) are all saved in the current directory (./Code/Part2)
3)evaluation results(F score values) using different filterbanks are save in evaluationvalues.m and the evaluation result generated with current use filterbank-first derivative 
Gaussian filterbank is saved in valuesgaussianfb.m
  
