# GNAL

Free and open source processing system for 16mm and Super8 film

IMAGE_PLACEHOLDER

Would you like to buy one?

# [Email me](mailto:gnal@sixteenmillimeter.com)

---

## What's GNAL? Gnal's Not A Lomo!

GNAL stands for Gnal's Not A Lomo because it isn't. While inspired by a certain motion picture development tank the goal of this project is to create an open source, modification-friendly processing system for small format movie film with the added constraint that it be 3D printable or otherwise able to be fabricated on a small scale. All source code and STL files for printing will be made available in this repository.

GNAL is built using [OpenSCAD](https://www.openscad.org/). OpenSCAD is a free, open source CAD program that uses scripts to generate objects. Building this project in OpenSCAD serves two purposes: it uses only free and open source software to create the GNAL processing spirals and it future-proofs the design by preserving its dimensions in human-readable text format. Even if OpenSCAD were to disappear tomorrow (sincerely hope it doesn't) it would still be possible to recreate the GNAL models in another CAD program just by reading the code and reproducing the measurements.

## Where's the tank?

Good question!

----

## V3 STL Files

**50ft/15m**

IMAGE_PLACEHOLDER

[All 50ft v3 STL files in a .zip]()

* [Spiral](stl/50ft_v3/gnal_50ft_spiral.stl)
* [Top](stl/50ft_v3/gnal_50ft_top.stl)
* [Top Spacer](stl/50ft_v3/gnal_50ft_spacer.stl)
* [Bottom Spiral Insert S8](stl/50ft_v3/gnal_50ft_insert_s8.stl)
* [Bottom Spiral Insert 16mm](stl/50ft_v3/gnal_50ft_insert_16.stl)
* [Bottom Spacer 16mm](stl/50ft_v3/gnal_50ft_spacer_16.stl)
* [Spindle Top](stl/50ft_v3/gnal_50ft_spindle_top.stl)
* [Spindle Bottom](stl/50ft_v3/gnal_50ft_spindle_bottom.stl)

**100ft/30m**

IMAGE_PLACEHOLDER

[All 100ft v3 STL files in a .zip]()

* [Spiral](stl/100ft_v3/gnal_100ft_spiral.stl)
* [Top](stl/100ft_v3/gnal_100ft_top.stl)
* [Top Spacer](stl/100ft_v3/gnal_100ft_spacer.stl)
* [Bottom Spiral Insert S8](stl/100ft_v3/gnal_100ft_insert_s8.stl)
* [Bottom Spiral Insert 16mm](stl/100ft_v3/gnal_100ft_insert_16.stl)
* [Bottom Spacer 16mm](stl/100ft_v3/gnal_100ft_spiral.stl)
* [Spindle Top](stl/100ft_v3/gnal_100ft_spindle_top.stl)
* [Spindle Bottom](stl/100ft_v3/gnal_100ft_spindle_bottom.stl)

## V2 STL Files

**50ft/15m**

IMAGE_PLACEHOLDER

[All 50ft v2 STL files in a .zip]()

* [Spiral](stl/50ft_v2/gnal_50ft_spiral.stl)
* [Top](stl/50ft_v2/gnal_50ft_top.stl)
* [Top Spacer](stl/50ft_v2/gnal_50ft_spacer.stl)
* [Bottom Spiral Insert S8](stl/50ft_v2/gnal_50ft_insert_s8.stl)
* [Bottom Spiral Insert 16mm](stl/50ft_v2/gnal_50ft_insert_16.stl)
* [Bottom Spacer 16mm](stl/50ft_v2/gnal_50ft_spacer_16.stl)

**100ft/30m**

IMAGE_PLACEHOLDER

[All 100ft v2 STL files in a .zip]()

* [Spiral](stl/100ft_v2/gnal_100ft_spiral.stl)
* [Top](stl/100ft_v2/gnal_100ft_top.stl)
* [Top Spacer](stl/100ft_v2/gnal_100ft_spacer.stl)
* [Bottom Spiral Insert S8](stl/100ft_v2/gnal_100ft_spiral.stl)
* [Bottom Spiral Insert 16mm]()
* [Bottom Spacer 16mm]()


## V1 STL Files

**50ft/15m**


IMAGE_PLACEHOLDER

[All 50ft v1 STL files in a .zip]()

* [Bottom Spiral](stl/50ft_v1/gnal_50ft_bottom_spiral.stl)
* [Top Spiral](stl/50ft_v1/gnal_50ft_top_spiral.stl)
* [Top](stl/50ft_v1/gnal_50ft_top.stl)
* [Spacer](stl/50ft_v1/gnal_50ft_spacer.stl)

**100ft/30m**

[All 100ft v1 STL files in a .zip]()

* [Bottom Spiral](stl/100ft_v1/gnal_100ft_bottom_spiral.stl)
* [Top Spiral](stl/100ft_v1/gnal_100ft_top_spiral.stl)
* [Top](stl/100ft_v1/gnal_100ft_top.stl)
* [Spacer](stl/100ft_v1/gnal_100ft_spacer.stl)

-----

## Printers

The diameter of these spiral reels limit the number of printers that are capable of printing this design. The 50ft/15m model is 225.71mm (8.88in) wide at the base and the 100ft/30m model is 299mm (11.77in) wide. 

**50ft/15m Capable Printers**

* [aniwaa.com Search: Printers with print bed > 225mm x 225mm](https://www.aniwaa.com/comparison/3d-printers/?sort=price&order=asc&filter_search&filter_price_minimum&filter_price_maximum&filter_build_size_width=225&filter_build_size_height=225&filter_build_size_depth)

**100ft/30m Capable Printers**

* [Creality Ender 5 Plus](https://www.creality3d.shop/collections/3d-printer/products/creality3d-ender-5-plus-3d-printer) ***Tested***
* [aniwaa.com Search: Printers with print bed > 300mm x 300mm](https://www.aniwaa.com/comparison/3d-printers/?filter_search&filter_price_minimum&filter_price_maximum&filter_build_size_width=300&filter_build_size_height=300&filter_build_size_depth)

There are people printing spirals in sections on smaller printers, but that is not a *recommended* use of these files as it requires extreme precision to reconstruct the parts into a reel that will load smoothly. Another thing to consider is the longevity of the bond made by the adhesive you choose. Don't let that stop you, though. A multi-part printed reel is just not a priority for *this* particular project. An enterprising spirit might notice the `gnal_50ft_spiral_quarter()` and `gnal_100ft_spiral_quarter()` modules in the v3 OpenSCAD script and begin to wonder what is possible.

-----

## Material

PETG is the recommended plastic for printing the GNAL. Since this is a piece of darkroom processing equipment its exposure to water and photochemistry is inevitable and should be considered primarily. PETG (Polyethylene terephthalate glycol) is a copolymer of PET, which is a plastic that's typically encountered in plastic bottles and food containers. This is not a scientific evalution and may stand to be corrected.

ABS is a viable option but has more tendency to warp on larger prints without proper temperature control around the print bed. Since this model needs to be consistently flat across the bottom of the reel, 

PLA is not recommended but this doesn't mean you can't get an acceptable results with it. The lack of endorsement comes from mostly anecdotal experience witnessing the wear and tear of water on PLA. Biodegradable and porous, PLA prints will wear down in the weakest parts first and on this model that would be the spiral. If you do not need your processing equipment to last a long time, you may find it acceptable. PLA stands for polylactic acid

-----

## Development

This project can be edited with only OpenSCAD and the source files in the `*_v1`, `*_v2` or `*_v3` directories which make reference to files from `libraries`. If you wish to run the development scripts you should install the following dependencies.

With just OpenSCAD, you can use scripts such as `50ft_v3/gnal_50ft.scad` and export the different modules in [OFF](https://en.wikipedia.org/wiki/OFF_(file_format)), [AMF](https://en.wikipedia.org/wiki/Additive_manufacturing_file_format), [3MF](https://en.wikipedia.org/wiki/3D_Manufacturing_Format), [DXF](https://en.wikipedia.org/wiki/AutoCAD_DXF) or SVG (drawing) format. The CSG models can be [imported](https://wiki.freecadweb.org/OpenSCAD_CSG) into [FreeCAD](https://www.freecadweb.org/) and DXF models should be readable by AutoCAD and [QCAD](https://www.qcad.org/en/).

### Dependencies

* Bash
* [OpenSCAD](https://www.openscad.org/downloads.html) + [cli](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Using_OpenSCAD_in_a_command_line_environment) ([Mac](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Using_OpenSCAD_in_a_command_line_environment#MacOS_notes)) ([Windows](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Using_OpenSCAD_in_a_command_line_environment#Windows_notes))
* [ADMesh](https://github.com/admesh/admesh)

### Build Scripts

Running any of the build scripts scripts--`scripts/v1.sh`, `scripts/v2.sh` or `scripts/v3.sh`--will start an OpenSCAD build process of all components and will log stats about the resulting files and render times to `notes/v1.csv`,  `notes/v2.csv` or `notes/v3.csv`.

Keep in mind that V1 and V2 compile times are extremely long and all scripts will use an entire CPU core at 100% utilization while rendering. It's best to run these scripts in the background on a powerful machine or better yet, not at all. See the `stl` folder for pre-compiled STL files for 3D printing or the [releases page](/releases/latest) for .zip archives of all versions.

These scripts will render STL files, PNG images of the files and then

### Benchmarks

The `scripts/benchmark.sh` script will run various tests on the different approaches to generating spirals in the `spiral` directory. See notes on the actual results of this script [below](#benchmarks)

-----

## Version notes
<a name="v1"></a>
### V1

Intended to be mostly compatible with existing processing spirals with some caveats. A spacer that is typically threaded has been replaced by a friction fit part so they are not interchangeable.

This version is designed to fit in existing tanks and use the same spindle screws.

In the process of building this first version several approaches were evaluated to generate the spiral shape. The first is what's best described as a brute force approach laying out an excessive amount of rectangular facets and unioning them together in such a way that the result would be a single continuous spiral. This took hours to days to render depending on the machine used.

Besides the exhausting render times this approach bugged me for one reason: all facets of the spiral were the same size, meaning that the small diameter inner parts of the spiral were packing in millions of unnecessary polygons to allow for the large diameter parts of the spiral to be smooth. This didn't sit well with me. How many CPU hours are being burned by adding detail to a place that doesn't matter? Answer: a lot.

Finally an external library called [`path_extrude.scad`](https://github.com/gringer/bioinfscripts/blob/master/path_extrude.scad) by [@gringer](https://github.com/gringer) was brought in to handle the complicated spiral extrusion step. A simple function that plots a spiral in Cartesian coordinates is used to draw the path and a 2D triangle is extruded along it by the library. This allowed for the path to be drawn at a consistent "resolution" throughout the entire spiral, so the facets of the outermost and innermost parts were the same or extremely similar.

Here is that function reduced to a single line in order to generate an array of coordinates.

```
spiralPath = [ for(t = [0 : $fn + 1]) [((d / 2) + (t * increment)) * cos(t * angle_i), ((d / 2) + (t * increment)) * sin(t * angle_i), 0] ];
```

The experimentation in this version predate this particular git repo and so will not be found in the git history, but you can find the vestigial functions in the `spiral` directory used for benchmarking different approaches.

#### Beware

This version of the spiral must be printed with supports. The spirals themselves are suspended over voids and this particular feature is addressed in the later versions. 

#### Benchmarks

Rendered using OpenSCAD version 2019.05 on a 2.2 GHz Core i7 (I7-4770HQ) chip running macOS 10.14.

| Model | Size (bytes) | Facets | Volume (mm<sup>3</sup>) | Render Time (sec) |
|-------|--------------|--------|-------------------------|-------------------|
|gnal_50ft_spacer.stl|991452|5736|2888.155029|68|
|gnal_50ft_top.stl|2132181|12624|57936.746094|233|
|gnal_50ft_spiral_top.stl|36509561|214404|120299.773438|12249|
|gnal_50ft_spiral_bottom.stl|36606204|214970|121519.937500|13698|
|gnal_100ft_spacer.stl|991452|5736|2888.149658|74|
|gnal_100ft_top.stl|3302563|19552|102590.546875|477|
|gnal_100ft_spiral_top.stl|92423369|542836|223602.078125|89137|


-----
<a name="v2"></a>
### V2

This version aims to improve printability over the V1 model and reducing render time of the spiral. The biggest change to the physical structure of the design is the removal of overhangs from beneath the spiral film guide.

When printing a model with [FFF printing](https://en.wikipedia.org/wiki/Fused_filament_fabrication), any piece that overhangs empty space (usually) needs to be supported by a temporary removable structure beneath it otherwise you risk the piece drooping. In the case of V1 model, the spiral was completely suspended by the spokes of the reel with large gaps of empty space. This means there were 90 degree overhangs under the most critical part of this model; the grooves for holding the film in position. Printing and removing support structures from beneath the fragile spiral made post-production dangerous for the piece and time consuming.

The solution to this was to extend the spiral to the bottom of the reel and remove triangular sections from them to allow for a lighter print and better chemistry movement. Most printers should be able to print these structures without any support material or any resulting deformations in the model.

One other change in this version is that it reduces the spiral models to a single one to be duplicated, rather than two distinct top and a bottom pieces that differ in only minor ways. This decision was motivated by an interest in making this design better (cheaper) for injection molding.

A secondary benefit of reducing the spiral to a single model was to immediately cut render times for the entire project nearly in half before any other optimizations were made. The first meaningful code optimization toward this goal was provided by a helpful comment made on a long-forgotten design shared on a 3D printing forum. 

[@sousvide59](https://www.thingiverse.com/sousvide59/designs) (Les Smith) writes 

> It may be more efficient to approximate the spiral as a series of arc segments, like this <[Github gist](https://gist.github.com/sixteenmillimeter/839c16d39d26d04154f52b3f3ee6ee78)>.

Les was right. This reduced the several hours render time to 1-2 hours, which worked for this version. Ideally this will be improved further in future versions. Beyond some explorations into OpenSCAD hacks (rendering each complete rotation of the spiral and stitching all resulting STLs) the next version will incorporate other languages and platforms to find the fastest render time for a GNAL spiral. All previous approaches are being compiled into a suite of tests to benchmark render times.

#### Benchmarks

Rendered using OpenSCAD version 2020.01.17 on a 3.2 GHz Core i5 (I5-4460) chip running Ubuntu 18.04.

| Model | Size (bytes) | Facets | Volume (mm<sup>3</sup>) | Render Time (sec) |
|-------|--------------|--------|-------------------------|-------------------|
|gnal_50ft_spacer.stl|991452|5736|2888.150879|22|
|gnal_50ft_top.stl|2132181|12624|57937.210938|73|
| *gnal_50ft_spiral.stl* |34628449|193450|178181.250000| **2341** |
|gnal_50ft_insert_s8.stl|5228272|27230|3493.560303|97|
|gnal_50ft_insert_16.stl|7922994|41426|4664.952637|155|
|gnal_50ft_spacer_16.stl|561267|3272|4015.912109|19|
|gnal_100ft_spacer.stl|991452|5736|2888.152100|23|
|gnal_100ft_top.stl|3302563|19552|102590.812500|118|
| *gnal_100ft_spiral.stl* |59279238|330000|345431.531250| **4542** |
|gnal_100ft_insert_s8.stl|5228272|27230|3493.559326|99|
|gnal_100ft_insert_16.stl|7922994|41426|4664.937500|160|
|gnal_100ft_spacer_16.stl|535264|3112|3964.118164|17|

-----

<a name="v3"></a>
### V3

The goals of V3 are to **greatly** optimize the spiral generation code for speed and to restore the feature of the V1 spiral which maintains a consistent size of individual facets throughout the spiral even as the diameter changes. This will be considered a stable release.

This version will also contain a 4x reel stacking feature so that all models can be stacked with 3 spiral reels and a top piece. That will give 200ft capacity to the 50ft model and 400ft capacity to the 100ft model.


#### Benchmarks

Rendered using OpenSCAD version 2019.05 on a 2.2 GHz Core i7 (I7-4770HQ) chip running macOS 10.14.

| Model | Size (bytes) | Facets | Volume (mm<sup>3</sup>) | Render Time (sec) |
|-------|--------------|--------|-------------------------|-------------------|
|gnal_50ft_spindle_bottom.stl|3760384|75206|4134.075684|1257|
|gnal_50ft_spindle_top.stl|6915384|138306|22229.804688|1278|
|gnal_50ft_spacer.stl|286884|5736|2888.143311|64|
|gnal_50ft_top.stl|1104884|22096|57933.828125|577|
| *gnal_50ft_spiral.stl* |10841384|216826|172470.609375| **5** |
|gnal_50ft_insert_s8.stl|1361584|27230|3493.514893|279|
|gnal_50ft_insert_16.stl|2071384|41426|4664.784180|413|
|gnal_50ft_spacer_16.stl|602084|12040|4019.471191|258|
|gnal_100ft_spindle_bottom.stl|3760384|75206|4134.063965|1253|
|gnal_100ft_spindle_top.stl|6979184|139582|22229.984375|15013|
|gnal_100ft_spacer.stl|286884|5736|2888.145996|92|
|gnal_100ft_top.stl|1620084|32400|102557.906250|1068|
| *gnal_100ft_spiral.stl* |21469784|429394|332991.468750|**10**|
|gnal_100ft_insert_s8.stl|1361584|27230|3493.547852|301|
|gnal_100ft_insert_16.stl|2071384|41426|4665.019531|462|
|gnal_100ft_spacer_16.stl|755684|15112|4019.489746|379|


<a name="benchmarks"></a>
## Benchmarks

In the process of publishing this repository I started questioning claims I was making in this readme. Throughout the development of this processing reel I've been plagued by long render times. As a sanity check, I went through my personal development history on this project and produced 7 distinct spiral generation scripts that I ran through a series of tests to benchmark the render performance, total volume generated and number of facets produced. Render time was the primary metric that concerned me, but I considered the other important in comparing these different approaches.

In the `spiral` directory you will find each individual script in a `spiral_#.scad` format. The `scripts/benchmark.sh` script will render spirals at various resolutions and rotation counts and records the results in `notes/benchmark.csv`.

Consider this comparison of just the 50ft spirals (top spiral from V1).

| # | Model | Size (bytes) | Facets | Volume (mm<sup>3</sup>) | Render Time (sec) |
|---|-------|--------------|--------|-------------------------|-------------------|
| V1 | gnal_50ft_spiral_top.stl |36509561 | 214404 | 120299.773438 | 12249 |
| V2 | gnal_50ft_spiral.stl     |34628449 | 193450 | 178181.250000 |  2341 |
| V3 | gnal_50ft_spiral.stl     |10841384 | 216826 | 172470.609375 |     5 |

Render times have gone down dramatically.
The volume has stayed consistent with major changes in geometry (between V1 and V2).
The file size of the V3 spiral has reduced to about 30% of the V1 and V2 spirals and the facet count remains roughly the same.


## License

MIT License

Copyright (c) 2020 Matt McWilliams

Permission is hereby granted, free of charge, to any person obtaining a copy of this hardware, software, and associated documentation files (the "Product"), to deal in the Product without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Product, and to permit persons to whom the Product is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Product.

THE PRODUCT IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE PRODUCT OR THE USE OR OTHER DEALINGS IN THE PRODUCT.

