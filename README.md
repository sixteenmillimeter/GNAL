# GNAL


Want to buy one?

# [Email me](mailto:gnal@sixteenmillimeter.com)

---

## What's GNAL? Gnal's Not A Lomo!

GNAL stands for Gnal's Not A Lomo because it isn't. While inspired by a certain motion picture development tank the goal of this project is to create an open source, modification-friendly processing system for small format movie film with the added constraint that it be 3D printable or otherwise able to be fabricated on a small scale. All source code and STL files for printing will be made available in this repository.

GNAL is built using [OpenSCAD](https://www.openscad.org/). OpenSCAD is a free, open source CAD program that uses scripts to generate objects. Building this project in OpenSCAD serves two purposes: it uses only free and open source software to create the GNAL processing spirals and it future-proofs the design by preserving its dimensions in human readable text format. Even if OpenSCAD were to disappear tomorrow (sincerely hope it doesn't) it would still be possible to recreate the GNAL models in another CAD program just by reading the code and reproducing the measurements.

## Where's the tank?

Good question!

----

## V2 STL Files For 3D Printing

**50ft/15m**

**100ft/30m**

* [Top]()
* [Top Spacer]()
* [Bottom Spiral Insert]()
* [Bottom Spiral Spacer]()
* [Spiral]()


## V1 STL Files

**50ft/15m**

* [Top](dist/50ft_v1/gnal_50ft_top.scad)
* [Spacer](dist/50ft_v1/gnal_50ft_top)
* [Top Spiral](dist/50ft_v1/gnal_50ft_top)
* [Top Spiral](dist/50ft_v1/gnal_50ft_top)

**100ft/30m**

* [Top](dist/100ft_v1/gnal_100ft_top.scad)
* [Spacer](dist/100ft_v1/gnal_100ft_top)
* [Top Spiral](dist/100ft_v1/gnal_100ft_top)
* [Top Spiral](dist/100ft_v1/gnal_100ft_top)

-----

## Printers

The diameter of these spiral reels limit the number of printers that are capable of printing this design. The 50ft/15m model is 225.71mm (8.88in) wide at the base and the 100ft/30m model is 299mm (11.77in) wide. 

**50ft/15m Capable**

[Printers with print bed > 225mm x 225mm](https://www.aniwaa.com/comparison/3d-printers/?sort=price&order=asc&filter_search&filter_price_minimum&filter_price_maximum&filter_build_size_width=225&filter_build_size_height=225&filter_build_size_depth)

**100ft/30m Capable**

* [Creality Ender 5 Plus](https://www.creality3d.shop/collections/3d-printer/products/creality3d-ender-5-plus-3d-printer) ***Tested***
*

[Printers with print bed > 300mm x 300mm](https://www.aniwaa.com/comparison/3d-printers/?filter_search&filter_price_minimum&filter_price_maximum&filter_build_size_width=300&filter_build_size_height=300&filter_build_size_depth)

There are people printing spirals in sections on smaller printers, but that is not a recommended use of these files as it requires extreme precision to reconstruct the parts into a reel that will load smoothly. Another thing to consider is the longevity of the bond made by the adhesive you choose. Don't let that stop you, though. A multi-part printed reel is just not a priority for *this* particular project.

-----

## Material

PETG is the recommended plastic for printing the GNAL. Since this is a piece of darkroom equipment its exposure to water and photochemistry is inevetable and should be considered first. PETG (Polyethylene terephthalate glycol) is a copolymer of PET, which is a plastic that's typically encountered in plastic bottles and food containers. By prioritizing the material

ABS is a viable option but has more tendency to warp on larger prints without proper temperature control around the print bed. Since this model needs to be consistently flat across the bottom of the reel, 

PLA is not recommended but this doesn't mean you can't get an acceptable results with it. The lack of endorsement comes from mostly anecdotal experience witnessing the wear and tear of water on PLA. Biodegradable and pourous, PLA prints will wear down in the weakest parts first and on this model that would be the spiral. If you do not need your processing equipment to last a long time

-----

## Development

### Dependencies

* Bash
* [OpenSCAD](https://www.openscad.org/downloads.html) + [cli](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Using_OpenSCAD_in_a_command_line_environment) ([Mac](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Using_OpenSCAD_in_a_command_line_environment#MacOS_notes)) ([Windows](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Using_OpenSCAD_in_a_command_line_environment#Windows_notes))
* [ADMesh](https://github.com/admesh/admesh)

### Build Scripts

Running either of the two scripts, either `scripts/v1.sh` or `scripts/v2.sh`, will start an OpenSCAD build process of all components and will log stats about the resulting files and render times to `notes/v1.csv` or `notes/v2.csv`.

Keep in mind that V1 compile times are extremely long and will use an entire CPU core at 100% utilization while rendering. It's best to run these scripts in the background on a powerful machine or better yet, not at all. See the `dist` folder for pre-compiled STL files for 3D printing.

-----

## Version notes

### V1

Intended to be mostly compatable with existing processing spirals with some caveats. The spacer that is typically threaded has been replaced by a friction fit spacer so they are not interchangable.

This version is designed to fit in existing tanks and use the same spindle screws.

In the process of building this first version several approaches were evaluated to generate the spiral shape. The first is what's best described as a brute force approach laying out an excessive amount of rectangular facets and unioning them together in such a way that the result would be a single continuous spiral. This took hours to days to render depending on the machine used.

Besides the exhausting render times this approach bugged me for one reason: all facets of the spiral were the same size, meaning that the small diameter inner parts of the spiral were packing in millions of unnecessary polygons to allow for the large diameter parts of the spiral to be smooth. This didn't sit well. How many CPU hours are being burned by adding detail to a place that doesn't matter. Answer: a lot.

Finally an external library called [`path_extrude.scad`](https://github.com/gringer/bioinfscripts/blob/master/path_extrude.scad) by [@gringer](https://github.com/gringer) was brought in to handle the complicated spiral extrusion step. A simple function that plots a spiral in Cartesian coordinates is used to draw the path and a 2D triangle is extruded along it by the library.

Reduced to a single line in order to generate an array of coordinates.

```
spiralPath = [ for(t = [0 : $fn + 1]) [((d / 2) + (t * increment)) * cos(t * angle_i), ((d / 2) + (t * increment)) * sin(t * angle_i), 0] ];
```

The experimentation in this version predate this particular git repo and so will not be found in the git history, but you can find the vestigial functions in the code with such helpful module names as `spiral()` and `spiral2()` and so on.

#### Render Stats

Rendered using OpenSCAD version 2019.05 on a 2.2 GHz Core i7 (I7-4770HQ) chip running macOS 10.14.

-----

### V2

This version aims to improve printability over the V1 model and reducing render time of the spiral. The biggest change to the physical structure of the design is the removal of overhangs from beneath the spiral film guide.

When printing a model with [FFF printing](https://en.wikipedia.org/wiki/Fused_filament_fabrication), any piece that overhangs empty space (usually) needs to be supported by a temporary removable structure beneath it otherwise you risk the piece drooping. In the case of V1 model, the spiral was completely suspended by the spokes of the reel with large gaps of empty space. This means there were 90 degree overhangs under the most critical part of this model; the grooves for holding the film in position. Printing and removing support structures from beneath the fragile spiral made post-production dangerous for the piece and time consuming.

The solution to this was to extend the spiral to the bottom of the reel and remove triangular sections from them to allow for a lighter print and better chemistry movement. Most printers should be able to print these structures without any support material or any resulting deformations in the model.

One other change in this version is that it reduces the spiral models to a single one to be duplicated, rather than two distinct top and a bottom pieces that differ in only minor ways. This decision was motivated by an interest in making this design better (cheaper) for injection molding.

A secondary benefit of reducing the spiral to a single model was to immediately cut render times for the entire project nearly in half before any other optimizations were made. The first meaningful code optimization toward this goal was provided by a helpful comment made on a long-forgotten design shared on a 3D printing forum. 

[@sousvide59](https://www.thingiverse.com/sousvide59/designs) (Les Smith) writes 

> It may be more efficient to approximate the spiral as a series of arc segments, like this <[Github gist](https://gist.github.com/sixteenmillimeter/839c16d39d26d04154f52b3f3ee6ee78)>.

Les was right. This reduced the several hours render time to 1-2 hours, which worked for this version. Ideally this will be improved further in future versions. Beyond some explorations into OpenSCAD hacks (rendering each complete rotation of the spiral and stitching all resulting STLs) the next version will incorporate other languages and platforms to find the fastest render time for a GNAL spiral. All previous approaches are being compiled into a suite of tests to benchmark render times.

#### Build Stats

Rendered using OpenSCAD version 2019.05 on a 2.2 GHz Core i7 (I7-4770HQ) chip running macOS 10.14.

### V3

The goals of V3 are to **greatly** optimize the spiral generation code for speed and to restore the feature of the V1 spiral which maintains a consistent size of individual facets throughout the spiral as the diameter changes.

## License

MIT License

Copyright (c) 2020 Matt McWilliams

Permission is hereby granted, free of charge, to any person obtaining a copy of this hardware, software, and associated documentation files (the "Product"), to deal in the Product without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Product, and to permit persons to whom the Product is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Product.

THE PRODUCT IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE PRODUCT OR THE USE OR OTHER DEALINGS IN THE PRODUCT.

