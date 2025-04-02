# GNAL

A free and open-source processing system for 16mm and Super8 film

![GNAL 50ft V3 all pieces](/img/gnal_50ft_v3.jpg)

1. [What's GNAL?](#what)
2. [STL Files](#stls)
3. [Printers](#printers)
4. [Material](#material)
5. [Troubleshooting](#troubleshooting)
6. [Contact](#contact)

---
<a name="what"></a>
## What's GNAL? Gnal's Not A Lomo!

GNAL stands for Gnal's Not A Lomo because it isn't. 
While inspired by a certain motion picture development tank the goal of this project is to create a free, open-source, modification-friendly processing system for small format movie film with the added constraint that it be 3D printable or otherwise able to be fabricated on a small scale. 
All source code and STL files for printing will be made available in this repository.

GNAL is built using [OpenSCAD](https://www.openscad.org/): a free, open-source CAD program that uses scripts to generate objects. 
Building this project in a scripting language serves two purposes: it uses only free and open-source software to generate the GNAL processing spirals and it future-proofs the design by preserving its dimensions in human-readable text format. 
Even if OpenSCAD were to disappear tomorrow (and we sincerely hope it doesn't) it would still be possible to recreate the GNAL models in another CAD program just by reading the code and reproducing the measurements.

While the files are all free, open-source and readily available to download; actually printing them can be a challenge. 
Please read through this README for information about materials, printers and troubleshooting your prints. Check out the [development notes](docs/) if you want to modify this project. 

Happy processing!

## Other Spirals

There has been a lot of development around 3D printed processing spirals and any projects will be linked here.
If you find any, please share with the email address at the bottom of this README.

* [Movie Film Spiral Developing Tank by mb_maker on Thingiverse](https://www.thingiverse.com/thing:4715086)
* [New 16mm developing tank](https://cinematography.com/index.php?/forums/topic/83456-new-16mm-developing-tank/)

## Where's the tank?

Good question!

----
<a name="stls"></a>
## V3 STL Files

![V3 50ft spiral top and bottom](/img/gnal_50ft_v3_spiral_render.jpg)

**50ft/15m**

#### [All 50ft v3 STL files in a .zip](https://links.sixteenmillimeter.com/mE4nkSm4)

* [Spiral](stl/50ft_v3/gnal_50ft_spiral.stl)
* [Top](stl/50ft_v3/gnal_50ft_top.stl)
* [Top Spacer](stl/50ft_v3/gnal_50ft_spacer.stl)
* [Bottom Spiral Insert S8](stl/50ft_v3/gnal_50ft_insert_s8.stl)
* [Bottom Spiral Insert 16mm](stl/50ft_v3/gnal_50ft_insert_16.stl)
* [Bottom Spacer 16mm](stl/50ft_v3/gnal_50ft_spacer_16.stl)
* [Spindle Top](stl/50ft_v3/gnal_50ft_spindle_top.stl)
* [Spindle Bottom](stl/50ft_v3/gnal_50ft_spindle_bottom.stl)

**100ft/30m**

#### [All 100ft v3 STL files in a .zip](https://links.sixteenmillimeter.com/fbdwf3C8)

* [Spiral](stl/100ft_v3/gnal_100ft_spiral.stl)
* [Top](stl/100ft_v3/gnal_100ft_top.stl)
* [Top Spacer](stl/100ft_v3/gnal_100ft_spacer.stl)
* [Bottom Spiral Insert S8](stl/100ft_v3/gnal_100ft_insert_s8.stl)
* [Bottom Spiral Insert 16mm](stl/100ft_v3/gnal_100ft_insert_16.stl)
* [Bottom Spacer 16mm](stl/100ft_v3/gnal_100ft_spiral.stl)
* [Spindle Top](stl/100ft_v3/gnal_100ft_spindle_top.stl)
* [Spindle Bottom](stl/100ft_v3/gnal_100ft_spindle_bottom.stl)

## V2 STL Files

![V2 50ft spiral top and bottom](/img/gnal_50ft_v2_spiral_render.jpg)

**50ft/15m**

#### [All 50ft v2 STL files in a .zip](https://links.sixteenmillimeter.com/vRPj4yTC)

* [Spiral](stl/50ft_v2/gnal_50ft_spiral.stl)
* [Top](stl/50ft_v2/gnal_50ft_top.stl)
* [Top Spacer](stl/50ft_v2/gnal_50ft_spacer.stl)
* [Bottom Spiral Insert S8](stl/50ft_v2/gnal_50ft_insert_s8.stl)
* [Bottom Spiral Insert 16mm](stl/50ft_v2/gnal_50ft_insert_16.stl)
* [Bottom Spacer 16mm](stl/50ft_v2/gnal_50ft_spacer_16.stl)

**100ft/30m**

#### [All 100ft v2 STL files in a .zip](https://links.sixteenmillimeter.com/XRlnssjz)

* [Spiral](stl/100ft_v2/gnal_100ft_spiral.stl)
* [Top](stl/100ft_v2/gnal_100ft_top.stl)
* [Top Spacer](stl/100ft_v2/gnal_100ft_spacer.stl)
* [Bottom Spiral Insert S8](stl/100ft_v2/gnal_100ft_spiral.stl)
* [Bottom Spiral Insert 16mm](stl/100ft_v2/gnal_100ft_insert_16.stl)
* [Bottom Spacer 16mm](stl/100ft_v2/gnal_100ft_insert_s8.stl)

## V1 STL Files

![V1 50ft spiral top and bottom](/img/gnal_50ft_v1_spiral_render.jpg)

**50ft/15m**

#### [All 50ft v1 STL files in a .zip](https://links.sixteenmillimeter.com/f67lQo2n)

* [Bottom Spiral](stl/50ft_v1/gnal_50ft_spiral_bottom.stl)
* [Top Spiral](stl/50ft_v1/gnal_50ft_spiral_top.stl)
* [Top](stl/50ft_v1/gnal_50ft_top.stl)
* [Spacer](stl/50ft_v1/gnal_50ft_spacer.stl)

**100ft/30m**

#### [All 100ft v1 STL files in a .zip](https://links.sixteenmillimeter.com/CVihrAr5)

* [Bottom Spiral](stl/100ft_v1/gnal_100ft_spiral_bottom.stl)
* [Top Spiral](stl/100ft_v1/gnal_100ft_spiral_top.stl)
* [Top](stl/100ft_v1/gnal_100ft_top.stl)
* [Spacer](stl/100ft_v1/gnal_100ft_spacer.stl)

-----
<a name="printers"></a>
## Printers

The diameter of these spiral reels limit the printers that are capable of making this design. 
The 50ft/15m model is 225.71mm (8.88in) wide at the base and the 100ft/30m model is 299mm (11.77in) wide. 

**50ft/15m Capable Printers**

* [PrintrBot Metal Plus](https://www.adafruit.com/product/2302)  **Tested** **[Discontinued]**
* [LulzBot TAZ 6](https://www.lulzbot.com/store/printers/lulzbot-taz-6) Untested
* [aniwaa.com Search: Printers with print bed > 225mm x 225mm](https://www.aniwaa.com/comparison/3d-printers/?sort=price&order=asc&filter_search&filter_price_minimum&filter_price_maximum&filter_build_size_width=225&filter_build_size_height=225&filter_build_size_depth)

**100ft/30m Capable Printers**

* [Creality Ender 5 Plus](https://www.creality3d.shop/collections/3d-printer/products/creality3d-ender-5-plus-3d-printer) ***Tested***
* [aniwaa.com Search: Printers with print bed > 300mm x 300mm](https://www.aniwaa.com/comparison/3d-printers/?filter_search&filter_price_minimum&filter_price_maximum&filter_build_size_width=300&filter_build_size_height=300&filter_build_size_depth)

There are people printing spirals in sections on smaller printers, but that is not a *recommended* use of these files as it requires extreme precision to reconstruct the parts into a reel that will load without problems. 
Another thing to consider is the longevity of the bond made by the adhesive you choose. 
Don't let that stop you, though. A multi-part printed reel is just not a priority for *this* particular project. 
An enterprising spirit might notice the `gnal_50ft_spiral_quarter()` and `gnal_100ft_spiral_quarter()` modules in the V3 OpenSCAD scripts and begin to wonder what is possible.

-----
<a name="material"></a>
## Material

[PETG](https://en.wikipedia.org/wiki/Polyethylene_terephthalate#Copolymers) is currently the recommended plastic for printing the GNAL. 
Since this is a piece of darkroom processing equipment its exposure to water and photochemistry is inevitable and should be considered primarily. 
PETG (Polyethylene terephthalate glycol) is PET--which is a plastic that's typically encountered in plastic bottles and food containers--in a copolymer with glycol. 

Various manufacturers have published [safety data sheets](http://www.ilpi.com/msds/) for PETG filament. 
The only warning about reactivity I have discovered states that a condition to avoid is "strong oxidizing agents" which may include reversal bleaches that are comprised of strong acids. 
This is not a scientific evaluation and may stand to be corrected.

[ABS](https://en.wikipedia.org/wiki/Acrylonitrile_butadiene_styrene) is a viable option but has a greater tendency to warp on larger prints without proper temperature control around the print bed. 
Since this model needs to be perfectly flat across the bottom of the reel, this is not ideal and will make for a challenging print. 
ABS is a plastic commonly used in injection molding and is also generally non-reactive with photochemistry.

[PLA](https://en.wikipedia.org/wiki/Polylactic_acid) is not recommended but this doesn't mean you can't get an acceptable result with it. 
The lack of endorsement comes from mostly anecdotal experience witnessing the wear and tear caused by exposure to water on PLA prints. 
Biodegradable and porous, PLA will wear down in the weakest parts first and on this model that would be the spiral. 
If you do not need your processing equipment to last a long time, you may find it acceptable. 
PLA stands for polylactic acid and is likely the most reactive material to use with photochemistry where it is vital to maintain pH for consistent results.

-----
<a name="troubleshooting"></a>
## Troubleshooting

Many, many issues were encountered during the development of this tool. 
Prints came out warped, failed midway during multi-day prints and had other mysterious ailments. 
I am by no means an expert but have built up months of experience trying to print these models on a variety of machines.

#### Warping

Fused filament fabrication relies on the behavior of plastics at high heat to create a physical object. 
If your prints are warping, there are a few things to look at:

1. Material
2. Temperature
3. Slicer settings

The first thing to consider when your prints are coming out warped off the print bed is whether or not your **material** is appropriate for this model. 
Check the [material](#material) section of this README for more information, but theres a chance if you are using PLA or ABS that large flat prints of this size are warping due to limitations with the material you are using. PETG has proven to warp far less in my own anecdotal experience and is the recommended material for this project.

The thermal properties of the material you're printing with are what causes warping, so check if your printer is being set to the recommended **temperatures** on both the bed and extruder for the material and printer you are using. 
Warping occurs consistently when a section of a part cools too quickly and contracts while the rest of it is still being printed. 
Mitigate this by using an enclosure on your open-frame printer or by printing in a space with low air movement but still with appropriate ventilation for the material you use.

The **slicer** you use and the **settings** in its configuration will make a lot of difference in how your print comes out. 
During the development of this project [Cura](https://ultimaker.com/software/ultimaker-cura) is the slicer used most for test prints, however you might find that different software works best with your machine. 
The settings are important to test before you commit to a complete print of the spiral part. 

Here is an example of the important settings used during development while printing with PETG.

|Setting|Value|
|---|---|
|Extruder Temperature|240<sup>o</sup> C|
|Bed Temperature|80<sup>o</sup> C|
|Generate Supports|Yes|
|Infill|20%|
|Print Speed|40 mm/s|

This is a fraction of the overall settings that Cura has, but they note some of the key features that were changed from the default profile for PETG and my printer.

-----

To read more about developing and modifying the GNAL, check out the [development notes](docs/).

-----

<a name="contact"></a>

Had issues or success printing this? Interested in getting in contact?

# [Email me](mailto:gnal@sixteenmillimeter.com)

-----

## License

MIT License

Copyright (c) 2020 Matt McWilliams

Permission is hereby granted, free of charge, to any person obtaining a copy of this hardware, software, and associated documentation files (the "Product"), to deal in the Product without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Product, and to permit persons to whom the Product is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Product.

THE PRODUCT IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE PRODUCT OR THE USE OR OTHER DEALINGS IN THE PRODUCT.

