poly2trihx
==========


poly2trihx is an Haxe port of the [poly2tri][1] library, an excellent Delaunay triangulation library, which supports constrained edges and holes.

[Html5 interactive demo][2]

[![Image](example.png?raw=true)][2]

The library works with Haxe 2 and 3, and has been tested on OpenFl's flash, html5 and CPP targets (tested on iOs), and on the neko target.

**How to compile the demo :**

    cd demo

    # flash
    openfl test flash

    # html5
    openfl test html5 -minify

    # neko
    haxe -cp ../src -main me.nerik.poly2trihx.NekoDemo -neko build/nekoDemo.n
    neko build/nekoDemo.n

**How to use it :**

```haxe
//Imports
import org.poly2tri.VisiblePolygon;
import org.poly2tri.Point;
import org.poly2tri.utils.TriangleCell;
import org.poly2tri.utils.AStar;
import org.poly2tri.utils.Funnel;

//...
//Triangulation
var vp:VisiblePolygon = new VisiblePolygon();
vp.addPolyline( poly ); //poly and hole = Array<org.poly2tri.Point>
vp.addPolyline( hole );

vp.performTriangulationOnce();
var graph:Array<TriangleCell> = vp.getGraph();

//...
//Pathfinding and string pulling
var channel:Array<TriangleCell> = AStar.find(startTriangle,endTriangle,graph); //startTriangle and endTriangle = org.poly2tri.TriangleCell
var path:Array<Point> = Funnel.stringPull(startPoint,endPoint, channel); //startPoint and endPoint = org.poly2tri.Point
```

## License

BSD 3-Clause License

Poly2Tri Copyright (c) 2009-2010, Poly2Tri Contributors
http://code.google.com/p/poly2tri/

All rights reserved.
Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice,
  this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.
* Neither the name of Poly2Tri nor the names of its contributors may be
  used to endorse or promote products derived from this software without specific
  prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



Some code from the example files borrowed from :
[Keith Hair](http://keith-hair.net/blog/2008/08/04/find-intersection-point-of-two-lines-in-as3/)
[Darel Rex Finley](http://alienryderflex.com/polygon/)


[1]: https://code.google.com/p/poly2tri/
[2]: http://nerik.github.io/poly2trihx/
