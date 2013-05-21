package me.nerik.poly2trihx;

import org.poly2tri.VisiblePolygon;
import org.poly2tri.Point;

class NekoDemo
{
	public static function main () 
	{

		var vp = new VisiblePolygon();
		vp.addPolyline( TestPoints.HAXE_LOGO );
		vp.addPolyline( TestPoints.HAXE_LOGO_HOLE );

		vp.performTriangulationOnce();

		neko.Lib.println(vp.getVerticesAndTriangles());
	}
}