#!/Applications/FreeCAD.app/Contents/Resources/bin/python

# FROM https://forum.freecadweb.org/viewtopic.php?p=341824&sid=58456759bd632dffcf09baeeb397dcb6#p341824

import sys
import os

if not len(sys.argv) == 3:
    print("Usage: %s file.csg file.step" % sys.argv[0])
    sys.exit(1)

file_input = sys.argv[1]
file_output = sys.argv[2]

print("Converting %s to %s" % (file_input, file_output))

sys.path.append("/Applications/FreeCAD.app/Contents/Resources/lib")
import FreeCAD
import importCSG
import Part

d = importCSG.open(file_input)

o = []

# Select parent node
for i in d.Objects:
    if not i.InList:
        o.append(i)
print(len(o))
quit()
# Perform the Fusion
App.activeDocument().addObject("Part::MultiFuse", "Fusion")
App.activeDocument().Fusion.Shapes = o
App.ActiveDocument.recompute()

# Then the Refine
#App.ActiveDocument.addObject('Part::Feature','Refine').Shape=App.ActiveDocument.Fusion.Shape.removeSplitter()
#App.ActiveDocument.recompute()

# Export as STEP
#Part.export([App.ActiveDocument.Refine], file_output)
Part.export([App.ActiveDocument.Fusion.Shape], file_output)