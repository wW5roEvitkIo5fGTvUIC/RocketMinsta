#!/bin/bash 

cd "$(dirname "$0")"/../..

gimp -i --batch-interpreter=python-fu-eval -b - << EOF
import gimpfu, glob, os

flagfile = "extras/gfx/flags/flag-60x40.xcf"
template = pdb.gimp_file_load(flagfile, flagfile)

for srcfile in glob.glob("extras/gfx/flags/src/*.tga"):
    name = srcfile.split('/')[-1]
    print "Processing: ", name
    
    flag = template.duplicate()
    flaglayer = pdb.gimp_file_load_layer(flag, srcfile)
    flag.add_layer(flaglayer, len(flag.layers) - 1)
    
    if name.startswith("29-"):
        flag.layers[0].visible = False
        flag.layers[2].visible = False
        flag.layers[5].visible = False
        flag.layers[3].opacity = 30.0
        flag.layers[4].opacity = 15.0
    
    name = "flagicons.pk3dir/gfx/flagicons/" + name
    result = pdb.gimp_image_merge_visible_layers(flag, 1)
    pdb.gimp_file_save(flag, result, name, name)
    pdb.gimp_image_delete(flag)

pdb.gimp_image_delete(template)
pdb.gimp_quit(1)
EOF