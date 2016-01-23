Halenia CoreXY printer
pre-project for a micro sized coreXY printer with a 100x100x100 usable volume (1l)
Copyright Pierre ROUZEAU AKA PRZ  - Jan 2016
Program license GPL 2.0
documentation licence cc BY-SA and GFDL 1.2
Machine and components design licence CERN OHL V1.2

Yet this is an 'on hold' project but I think the CoreXY simulation is of interest. 
I am not sure that coreXY mechanism offer any advantage over a delta for such a small
printer. However, it could be an inspiration for a larger size printer, but as 
a pre-project, parts are not finished, the modules for parts are not separated in the
program, so there is a lot of work to go to realization.

The fundamental ideas for the mechanical design is to have multi-functional parts.
Also, for a small printer, the sliding mechanisms could be constitutive of the structure,
which simplify the ensemble, as is done on some deltas (Rostock type). 
It is not a derivative of any other project, however I had a close look at the SmartCore, 
which was inspirational even if Halenia details are quite different.

For the CoreXY demonstration, I have used a characteristic of OpenScad, which is the
transparency of parts is only calculated against parts which have already been
calculated. This often give very odd viewings, but here it was used to improve
the visualization of the coreXY system.

The direct drive extruder, also of own design, is effectively used in one of my printers,
the 'D-Box'. The fixation have been modified to be installed on the Halenia.
I hope to publish this extruder with multiples attach variations soon. 

The hotend does not exists, but I will realize it one day for a delta.
The nozzle will be the 'Fisher delta' all metal nozzle, which is well performing, 
but it will be screwed in a cubic finned cooling block, in the style of the 'Chimera'
hotend, but with top attach.  The nozzle is threaded in M4, but instead of former nozzles
from RepRaPPro, it does have a real heat break, which allow it to go up to 300°C, with
a relatively limited cooling flow, hence a silent hotend. I am printing with it mainly
PETG, with a sustained temperature of 285°C. 5m3/h cooling airflow is ok with a 
super-silent Sunon 25x25x10 fan.  

The OpenScad library, which is an own development, is used in all my projects, and while
not officially released, is available on this project and others, and could be considered
now as relatively stable.

See on the OpenScad Delta simulator how to manage simulation and make films.
There is a VirtualDub file configuration in the package.
