poly2trihx
==========


poly2trihx is an Haxe port of the [poly2tri][1] library, an excellent Delaunay triangulation library, which supports constrained edges and holes. 

[Html5 interactive demo][2]

![Image](example.png?raw=true)

The library works with Haxe 2 and 3, and has been tested on NME's flash, html5 and CPP targets, and on the neko target.

**How to compile the demos :**


    # flash
    nme test "build.nmml" flash

    # html5
    nme test "build.nmml" html5 -minify

    # neko
    haxe -cp src -main me.nerik.poly2trihx.NekoDemo -neko bin/nekoDemo.n
    neko bin/nekoDemo.n 

   


[1]: https://code.google.com/p/poly2tri/
[2]: http://nerik.me/project/poly2trihx