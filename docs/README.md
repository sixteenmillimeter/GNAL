# Development Notes

This project can be edited with only [OpenSCAD]() and the source files in the `scad/*_v1`, `scad/*_v2` or `scad/*_v3` directories which make reference to files from `scad/libraries`. 
If you wish to run the development scripts you should install the following dependencies.

With just OpenSCAD, you can use scripts such as `scad/50ft_v3/gnal_50ft.scad` and export the different modules in [OFF](https://en.wikipedia.org/wiki/OFF_(file_format)), [AMF](https://en.wikipedia.org/wiki/Additive_manufacturing_file_format), [3MF](https://en.wikipedia.org/wiki/3D_Manufacturing_Format), [DXF](https://en.wikipedia.org/wiki/AutoCAD_DXF) or SVG (drawing) format. 
The CSG models can be [imported](https://wiki.freecadweb.org/OpenSCAD_CSG) into [FreeCAD](https://www.freecadweb.org/) and DXF models should be readable by AutoCAD and [QCAD](https://www.qcad.org/en/).

1. Dependencies
2. Build Scripts
3. Version Notes - V1
4. Version Notes - V2
5. Version Notes - V3
6. Benchmarks

### Dependencies

* [Bash](https://www.gnu.org/software/bash/) - Available by default on Mac and Linux
* [OpenSCAD](https://www.openscad.org/downloads.html) + [cli](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Using_OpenSCAD_in_a_command_line_environment) ([Mac](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Using_OpenSCAD_in_a_command_line_environment#MacOS_notes)) ([Windows](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Using_OpenSCAD_in_a_command_line_environment#Windows_notes))
* [ADMesh](https://github.com/admesh/admesh)
* (optional) [POV-Ray](http://www.povray.org/download/)

### Build Scripts

Running any of the build scripts scripts--`scripts/v1.sh`, `scripts/v2.sh` or `scripts/v3.sh`--will start an OpenSCAD build process of all components and will log stats about the resulting files and render times to `notes/v1.csv`,  `notes/v2.csv` or `notes/v3.csv`.

Keep in mind that V1 and V2 compile times are extremely long and all scripts will use an entire CPU core at 100% utilization while rendering. 
It's best to run these scripts in the background on a powerful machine or better yet, not at all. See the `stl` folder for pre-compiled STL files for 3D printing or the [releases page](/releases/latest) for .zip and .tar.gz archives of all versions.

These scripts will render STL files, PNG images of the files and capture metadata about the render process while doing so.

-----

## Version Notes

<a name="v1"></a>

### V1

Intended to be mostly compatible with existing processing spirals with some caveats. 
A spacer that is typically threaded has been replaced by a friction fit part so they are not interchangeable. 
This version is designed to fit in existing tanks and use the same spindle screws.

In the process of building this first version several approaches were evaluated to generate the spiral shape. 
The first is what's best described as a brute force approach laying out an excessive amount of rectangular facets and unioning them together in such a way that the result would be a single continuous spiral. 
This took hours to days to render depending on the machine used.

Besides the exhausting render times this approach bugged me for one reason: all facets of the spiral were the same size, meaning that the small diameter inner parts of the spiral were packing in millions of unnecessary polygons to allow for the large diameter parts of the spiral to be smooth. 
This didn't sit well with me. 
How many CPU hours are being burned by adding detail to a place that doesn't matter? 
Answer: a lot.

Finally, an external library called [`path_extrude.scad`](https://github.com/gringer/bioinfscripts/blob/master/path_extrude.scad) by [@gringer](https://github.com/gringer) was brought in to handle the complicated spiral extrusion step. 
A simple function that plots a spiral in Cartesian coordinates is used to draw the path and a 2D triangle is extruded along it by the library. 
This allowed for the path to be drawn at a consistent "resolution" throughout the entire spiral, so the facets of the outermost and innermost parts were the same or extremely similar.

Here is that function reduced to a single line in order to generate an array of coordinates.

```
spiralPath = [ for(t = [0 : $fn + 1]) [((d / 2) + (t * increment)) * cos(t * angle_i), ((d / 2) + (t * increment)) * sin(t * angle_i), 0] ];
```

The experimentation in this version predate this particular git repo and so will not be found in the git history, but you can find the vestigial functions in the `spiral` directory used for benchmarking different approaches.

#### Beware

This version of the spiral must be printed with supports. 
The spirals themselves are suspended over voids and this particular feature is addressed in the later versions. 

#### Rendering

Rendered using OpenSCAD version 2019.05 on a 2.2 GHz Core i7 (I7-4770HQ) chip running macOS 10.14.

| Model | Size (bytes) | Facets | Volume (mm<sup>3</sup>) | Render Time (sec) |
|-------|--------------|--------|-------------------------|-------------------|
|gnal_50ft_spacer.stl|991452|5736|2888.155029|68|
|gnal_50ft_top.stl|2132181|12624|57936.746094|233|
| **gnal_50ft_spiral_top.stl** |36509561|214404|120299.773438| **12249** |
| **gnal_50ft_spiral_bottom.stl** |36606204|214970|121519.937500| **13698** |
|gnal_100ft_spacer.stl|991452|5736|2888.149658|74|
|gnal_100ft_top.stl|3302563|19552|102590.546875|477|
|gnal_100ft_spiral_top.stl|92423369|542836|223602.078125|89137|
|gnal_100ft_spiral_bottom.stl|N/A|N/A|N/A|N/A|

-----

<a name="v2"></a>

### V2

This version aims to improve printability over the V1 model and reducing render time of the spiral. 
The biggest change to the physical structure of the design is the removal of overhangs from beneath the spiral film guide.

When printing a model with [FFF printing](https://en.wikipedia.org/wiki/Fused_filament_fabrication), any piece that overhangs empty space (usually) needs to be supported by a temporary removable structure beneath it otherwise you risk the piece drooping. 
In the case of V1 model, the spiral was completely suspended by the spokes of the reel with large gaps of empty space. 
This means there were 90 degree overhangs under the most critical part of this model; the grooves for holding the film in position. 
Printing and removing support structures from beneath the fragile spiral made post-production dangerous for the piece and time consuming.

The solution to this was to extend the spiral to the bottom of the reel and remove triangular sections from them to allow for a lighter print and better chemistry movement. 
Most printers should be able to print these structures without any support material or any resulting deformations in the model.

One other change in this version is that it reduces the spiral models to a single one to be duplicated, rather than two distinct top and a bottom pieces that differ in only minor ways. 
This decision was motivated by an interest in making this design better (cheaper) for injection molding.

A secondary benefit of reducing the spiral to a single model was to immediately cut render times for the entire project nearly in half before any other optimizations were made. 
The first meaningful code optimization toward this goal was provided by a helpful comment made on a long-forgotten design shared on a 3D printing forum. 

[@sousvide59](https://www.thingiverse.com/sousvide59/designs) (Les Smith) writes 

> It may be more efficient to approximate the spiral as a series of arc segments, like this <[Github gist](https://gist.github.com/sixteenmillimeter/839c16d39d26d04154f52b3f3ee6ee78)>.

Les was right. 
This reduced the several hours render time to 1-2 hours, which worked for this version. Ideally this will be improved further in future versions. 
Beyond some explorations into OpenSCAD hacks (rendering each complete rotation of the spiral and stitching all resulting STLs) the next version will incorporate other languages and platforms to find the fastest render time for a GNAL spiral. 
All previous approaches are being compiled into a suite of tests to benchmark render times.

#### Rendering

Rendered using OpenSCAD version 2020.01.17 on a 3.2 GHz Core i5 (I5-4460) chip running Ubuntu 18.04.

| Model | Size (bytes) | Facets | Volume (mm<sup>3</sup>) | Render Time (sec) |
|-------|--------------|--------|-------------------------|-------------------|
|gnal_50ft_spacer.stl|991452|5736|2888.150879|22|
|gnal_50ft_top.stl|2132181|12624|57937.210938|73|
| **gnal_50ft_spiral.stl** |34628449|193450|178181.250000| **2341** |
|gnal_50ft_insert_s8.stl|5228272|27230|3493.560303|97|
|gnal_50ft_insert_16.stl|7922994|41426|4664.952637|155|
|gnal_50ft_spacer_16.stl|561267|3272|4015.912109|19|
|gnal_100ft_spacer.stl|991452|5736|2888.152100|23|
|gnal_100ft_top.stl|3302563|19552|102590.812500|118|
| **gnal_100ft_spiral.stl** |59279238|330000|345431.531250| **4542** |
|gnal_100ft_insert_s8.stl|5228272|27230|3493.559326|99|
|gnal_100ft_insert_16.stl|7922994|41426|4664.937500|160|
|gnal_100ft_spacer_16.stl|535264|3112|3964.118164|17|

-----

<a name="v3"></a>
### V3

The goals of V3 are to **greatly** optimize the spiral generation code for speed and to restore the feature of the V1 spiral which maintains a consistent size of individual facets throughout the spiral even as the diameter changes. 
This will be considered a stable release candidate for publishing the project.

Since the benchmarking process ([see below](#benchmarks)) was developed between V2 and V3, render times are optimized in this iteration of the project. 
The success of the [`spiral_3.scad`](scad/spiral/spiral_3.scad) approach stood out from the rest as fastest, so it was reworked into what exists in V3.

The spiral itself is plotted in 2D with a relatively simple formula that is expressed in this OpenSCAD script through a number of in-line helper functions. 
It draws the position of various points along the spiral path and then uses the `path_extrude.scad` library to extrude a shape along those coordinates. 
This proves to be fast and efficient while not sacrificing any detail in the geometry.

Prior to release a serious flaw was found while printing the V3 design. 
The attempt to remove the need for supports in V2, actually printing the spiral was creating curious side effects during fabrication. 
Not having material in the voids below the spiral, it seems, allowed air to cool the part and would consistently cause prints to fail when it reached the actual spiral at the top of the reel. 
Since this is the most important element of the reel, the triangles have been removed and the design is more similar to V1. 
Testing continues on this version.

In a compromise to make the process of removing the support material less dangerous to the detail on the top, the spiral itself extends lower than V1 into the space between the spokes of the reel. 
The spiral is also made thicker and is a multiple of my nozzle diameter (0.4mm). 
This uses slightly more material but is less fragile than V1 and test prints proved that the supports were less difficult to remove than in the earliest model.

This version will also contain a 4x reel stacking feature so that all models can be stacked with 3 spiral reels and a top piece. 
That will give 200ft capacity to the 50ft model and 400ft capacity to the 100ft model. 
A stretch goal for this version is to make a 35mm spacer and spindle set so that movie film in the format can be processed in 100ft lengths.

#### Beware

This version *also* requires the use of support material while printing.

#### Rendering

Rendered using OpenSCAD version 2020.08.18 on a 2.2 GHz Core i7 (I7-4770HQ) chip running macOS 10.14.

| Model | Size (bytes) | Facets | Volume (mm<sup>3</sup>) | Render Time (sec) |
|-------|--------------|--------|-------------------------|-------------------|
|gnal_50ft_spindle_bottom.stl|3760384|75206|4134.077637|1291|
|gnal_50ft_spindle_top.stl|6915384|138306|22229.814453|1128|
|gnal_50ft_spacer.stl|286884|5736|2888.150635|62|
|gnal_50ft_top.stl|1104884|22096|57933.800781|585|
| **gnal_50ft_spiral.stl** |9500384|190006|171712.140625| **1111** |
|gnal_50ft_insert_s8.stl|1361584|27230|3493.544922|276|
|gnal_50ft_insert_16.stl|2071384|41426|4665.019531|439|
|gnal_50ft_spacer_16.stl|602084|12040|4019.470703|281|
|gnal_100ft_spindle_bottom.stl|3760384|75206|4134.064941|1275|
|gnal_100ft_spindle_top.stl|6979184|139582|22229.773438|1139|
|gnal_100ft_spacer.stl|286884|5736|2888.143555|63|
|gnal_100ft_top.stl|1620084|32400|102557.437500|998|
| **gnal_100ft_spiral.stl** |18364384|367286|326573.812500| **3746** |
|gnal_100ft_insert_s8.stl|1361584|27230|3493.548340|272|
|gnal_100ft_insert_16.stl|2071384|41426|4664.790527|450|
|gnal_100ft_spacer_16.stl|755684|15112|4019.479248|368|


<a name="benchmarks"></a>
## Benchmarks

In the process of publishing this repository I started questioning claims I was making in this README. 
Throughout the development of this processing reel I've been plagued by long render times. 
As a sanity check, I went through my personal development history on this project and produced 6 distinct spiral generation scripts that I ran through a series of tests to benchmark the render performance, total volume generated and number of facets produced. 
Render time was the primary metric that concerned me, but I considered the others important in comparing these different approaches. 

This work led to the creation of the approach in `spiral_7.scad` and was ultimately used in V3.

An example of a single test pulled from the `notes/benchmark.csv` results. 
These example results are rendered using OpenSCAD 2020.05.23 on a 2.3 GHz Xeon Gold 6140 chip running Ubuntu 18.04.

|Spiral Test|Diameter (mm)|Rotations| [$fn](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Other_Language_Features#$fa,_$fs_and_$fn) |Size (bytes)|Facets|Volume (mm<sup>3</sup>)|Time (sec)|
|---|---|---|---|---|---|---|---|
|[spiral_1.scad](scad/spiral/spiral_1.scad)|47|10|100|7409653|41064|5391.819336|209|
|spiral_2.scad|47|10|100|15349620|86646|3639.441162|855|
|spiral_3.scad|47|10|100|1336635|8004|3589.485596|0|
|spiral_4.scad|47|10|100|1607691|9624|3830.134521|23|
|spiral_5.scad|47|10|100|4711486|28188|3602.101562|8|
|spiral_6.scad|47|10|100|4265376|25396|14337.455078|120|
|spiral_7.scad|47|10|100|990006|5924|3581.499756|0|

As you can see, the different approaches lead to wildly different render times for the same test. 
If you look at the complete results you will see many tests did not even finish due to exhausting memory on the machine or the process being killed by the cloud host (using too much CPU for too long, most likely). 
In the case of `spiral_3.scad` and `spiral_7.scad` measuring "0" seconds, this just means that the process finished rendering in less than 1 second.

In the `scad/spiral` directory you will find each individual script in a `scad/spiral/spiral_#.scad` file. 
The `scripts/benchmark.sh` script will render spirals at various resolutions and rotation counts and record the results in `notes/benchmark.csv`.

Insights gleaned from these benchmarks was incorporated into the latest versions of design. 
Consider this comparison of just the 50ft spirals (top spiral from V1).

| # | Model | Size (bytes) | Facets | Volume (mm<sup>3</sup>) | Render Time (sec) |
|---|-------|--------------|--------|-------------------------|-------------------|
| V1 | gnal_50ft_spiral_top.stl |36509561 | 214404 | 120299.773438 | 12249 |
| V2 | gnal_50ft_spiral.stl     |34628449 | 193450 | 178181.250000 |  2341 |
| V3 | gnal_50ft_spiral.stl     | 9500384 | 190006 | 171712.140625 |  1111 |

Render times have gone down dramatically between V1 and V2.
Times halved again between V2 and V3.
The volume has stayed consistent with major changes in geometry (between V1 and V2).
The file size of the V3 spiral has reduced to about 30% of the V1 and V2 spirals and the facet count remains roughly the same throughout (which was a surprise).

Faster render times mean more iteration and less time between tests.
The next part of the process to examine is slicing which has primarily been done with Cura, but other engines will be looked at for their speed, efficiency and print quality.

