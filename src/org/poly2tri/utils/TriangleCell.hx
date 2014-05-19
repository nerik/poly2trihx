package org.poly2tri.utils;

import org.poly2tri.Point;
import org.poly2tri.Triangle;
/**
 * ...
 * @author LunaFromTheMoon
 */
class TriangleCell
{

	public var triangle:Triangle;
	public var neighbours:Array<TriangleCell>;
	
	//for A-star
	public var distance:Float;
	public var marked:Bool;
	public var prevCell:TriangleCell;
	
	public function new(triangle:Triangle) 
	{
		this.triangle = triangle;
		neighbours = new Array<TriangleCell>();
	}
	
	public function getCenter():Point {
		var points:Array<Point> = triangle.points;
		var x = (points[0].x + points[1].x + points[2].x) / 3;
		var y = (points[0].y + points[1].y + points[2].y) / 3;
		return new Point(x, y);
	}
	
	public function getArea() {
		var points:Array<Point> = triangle.points;
		var ax:Float = points[1].x - points[0].x;
		var ay:Float = points[1].y - points[0].y;
		var bx:Float = points[2].x - points[0].x;
		var by:Float = points[2].y - points[0].y;
		return bx * ay - ax * by;
	}
	
	public function inTriangle(point:Point):Bool {
		// Compute vectors
		//C(2)-A(0)
		var v0 = [triangle.points[2].x - triangle.points[0].x, triangle.points[2].y - triangle.points[0].y];
		//B(1)-A(0)
		var v1 = [triangle.points[1].x - triangle.points[0].x, triangle.points[1].y - triangle.points[0].y];
		//the point - A(0)
		var v2 = [point.x - triangle.points[0].x, point.y - triangle.points[0].y];

		// Compute dot products = a1 * b1 + a2 * b2
		var dot00 = v0[0] * v0[0] + v0[1] * v0[1];
		var dot01 = v0[0] * v1[0] + v0[1] * v1[1];
		var dot02 = v0[0] * v2[0] + v0[1] * v2[1];
		var dot11 = v1[0] * v1[0] + v1[1] * v1[1];
		var dot12 = v1[0] * v2[0] + v1[1] * v2[1];

		// Compute barycentric coordinates
		var invDenom = 1 / (dot00 * dot11 - dot01 * dot01);
		var u = (dot11 * dot02 - dot01 * dot12) * invDenom;
		var v = (dot00 * dot12 - dot01 * dot02) * invDenom;

		// Check if point is in triangle
		return (u >= 0) && (v >= 0) && (u + v < 1) ;
	}
	
	//for A-star
	public function distanceTo(otherTriangle:TriangleCell):Float {
		// distance from center to center
		 return PointUtils.vdistsqr(this.getCenter(), otherTriangle.getCenter());
	}
	
	public function heuristicTo(otherTriangle:TriangleCell):Float {	 
		 return distanceTo(otherTriangle);
	}
	
	public function weightTo(otherCell:TriangleCell):Float {	 
		 return 1;
	}
	
	//seeks neighbours in a triangle map
	public function setNeighbours(trianglesGraph:Array<TriangleCell>) {
		var points:Array<Point> = triangle.points;
		for (tri in trianglesGraph) {
			var commonVertices:Int = 0;
			var triPoints:Array<Point> = tri.triangle.points;
			for (i in 0...3) {
				for (j in 0...3) {
					if (points[i].x == triPoints[j].x && points[i].y == triPoints[j].y) {
						commonVertices++;
						break;
					}
				}
			}
			if (commonVertices == 2) {
				//neighbours!
				neighbours.push(tri);
				tri.neighbours.push(this);
			}
		}
	}
}