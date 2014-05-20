package org.poly2tri.utils;

import org.poly2tri.Point;

/**
 * ...
 * @author LunaFromTheMoon
 */
class PointUtils
{

	private function new() 
	{
		
	}
		
	static public function vdistsqr(a:Point, b:Point):Float {
		var x:Float = b.x - a.x;
		var y:Float = b.y - a.y;
		return Math.sqrt(x * x + y * y);
	}
	
	static public function vequal(a:Point, b:Point):Bool {
		return vdistsqr(a, b) < (0.001 * 0.001);
	}
	
	static public function triarea2(a:Point, b:Point, c:Point):Float {
		var ax:Float = b.x - a.x;
		var ay:Float = b.y - a.y;
		var bx:Float = c.x - a.x;
		var by:Float = c.y - a.y;
		return bx * ay - ax * by;
	}
	
}