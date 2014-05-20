package org.poly2tri;

import org.poly2tri.Point;
import org.poly2tri.utils.TriangleCell;

class VisiblePolygon
{

	var sweepContext:SweepContext;
	var sweep:Sweep;
	var triangulated:Bool;

	public function new() 
	{
		reset();
	}


	public function addPolyline(polyline:Array<Point>) 
	{
		sweepContext.addPolyline(polyline);
	}

	public function addPolylineFromFloats(pos:Array<Float>) 
	{
		var a = new Array();
		for (i in 0...pos.length) 
		{
			if (i%2==1) continue;
			a.push( new Point( pos[i], pos[i+1]) );
		}
		addPolyline(a);
	}

	public function reset() 
	{
		sweepContext = new SweepContext();
		sweep = new Sweep(sweepContext);
		triangulated = false;
	}

	public function performTriangulationOnce()
	{
		if (this.triangulated) return;
		triangulated = true;
		sweep.triangulate();
	}

	//get graph of triangles with neighbours and all
	public function getGraph():Array<TriangleCell> {
		var graph:Array<TriangleCell> = new Array<TriangleCell>();
		for (t in sweepContext.triangles){
			var triangle:TriangleCell = new TriangleCell(t);
			triangle.setNeighbours(graph);
			graph.push(triangle);
		}
		return graph;
	}
	
	//returns vertices in a 3D engine-friendly, XYZ format
	public function getVerticesAndTriangles() 
	{
		if (!this.triangulated) return null;

		var vertices = new Array();
		var ids = new Array();

		for (i in 0...sweepContext.points.length) 
		{
			var p = sweepContext.points[i];
			vertices.push(p.x);
			vertices.push(p.y);
			vertices.push(0);
			ids[p.id] = i;
		}

		var tris = new Array();
		for (t in sweepContext.triangles)
		{

			for (i in 0...3) 
			{
				tris.push( ids[ t.points[i].id ] );
			}
		}
	
		return { vertices: vertices, triangles:tris };
	}

	public function getNumTriangles() 
	{
		return sweepContext.triangles.length;
	}


	#if (nme || flash)
	public function drawShape(g:flash.display.Graphics) 
	{
		var t:Triangle;
		var pl:Array<Point>;
		
		performTriangulationOnce();

		for (t in sweepContext.triangles) 
		{
			pl = t.points;

			g.beginFill( 0xefb83d, .9 );
			g.moveTo(pl[0].x, pl[0].y);
			g.lineTo(pl[1].x, pl[1].y);
			g.lineTo(pl[2].x, pl[2].y);
			g.lineTo(pl[0].x, pl[0].y);
			g.endFill();
		}

		g.lineStyle(1, 0xd31205, 1);

		for (t in sweepContext.triangles) 
		{
			pl = t.points;

			g.moveTo(pl[0].x, pl[0].y);
			g.lineTo(pl[1].x, pl[1].y);
			g.lineTo(pl[2].x, pl[2].y);
			g.lineTo(pl[0].x, pl[0].y);
		}

		g.lineStyle(2, 0x945922, 2);

		for (e in sweepContext.edge_list)
		{
			g.moveTo(e.p.x, e.p.y);
			g.lineTo(e.q.x, e.q.y);
		}
	}
	#end
}
