package org.poly2tri.utils;

import org.poly2tri.Point;
import org.poly2tri.utils.PointUtils;
import org.poly2tri.utils.TriangleCell;

/**
 * ...
 * @author LunaFromTheMoon
 */
class Funnel
{

	private function new() 
	{
		
	}
	
	public static function channelToPortals(startPoint:Point, endPoint:Point, channel:Array<TriangleCell>):Array<Portal> {
		var portals:Array<Portal> = new Array<Portal>();
		portals.push(new Portal(startPoint, startPoint));
		if (channel.length >= 2) {
			var firstTriangle:Triangle = channel[0].triangle;
			var secondTriangle:Triangle = channel[1].triangle;
			var lastTriangle:Triangle  = channel[channel.length - 1].triangle;
			var startVertex:Point = Triangle.getNotCommonVertex(firstTriangle, secondTriangle);
			var vertexCW0:Point = startVertex;
			var vertexCCW0:Point = startVertex;
			for (n in 0...(channel.length-1)) {
				var triangleCurrent:Triangle = channel[n + 0].triangle;
				var triangleNext:Triangle    = channel[n + 1].triangle;
				var commonEdge:Edge  = Triangle.getCommonEdge(triangleCurrent, triangleNext);
				var vertexCW1:Point  = triangleCurrent.pointCW (vertexCW0 );
				var vertexCCW1:Point = triangleCurrent.pointCCW(vertexCCW0);
				if (!commonEdge.hasPoint(vertexCW0)) {
						vertexCW0 = vertexCW1;
				}
				if (!commonEdge.hasPoint(vertexCCW0)) {
						vertexCCW0 = vertexCCW1;
				}
				portals.push(new Portal(vertexCW0, vertexCCW0));
			}
		}	   
		portals.push(new Portal(endPoint, endPoint));
		return portals;
	}
	
	public static function stringPull(startPoint:Point, endPoint:Point, channel:Array<TriangleCell>):Array<Point> {
		var pts:Array<Point> = new Array<Point>();
		// Init scan state			
		var portals:Array<Portal> = channelToPortals(startPoint, endPoint, channel);
		var portalApex:Point = portals[0].left;
		var portalLeft:Point  = portals[0].left;
		var portalRight:Point = portals[0].right;
		var apexIndex:Int = 0, leftIndex:Int = 0, rightIndex:Int = 0;

		// Add start point.
		pts.push(portalApex);
		var i:Int = 1;
		while (i < portals.length) {
			var left:Point  = portals[i].left;
			var right:Point = portals[i].right;
			// Update right vertex.
			if (PointUtils.triarea2(portalApex, portalRight, right) <= 0.0) {				
				if (PointUtils.vequal(portalApex, portalRight) || PointUtils.triarea2(portalApex, portalLeft, right) > 0.0) {
					// Tighten the funnel.
					portalRight = right;
					rightIndex = i;
				} else {
					// Right over left, insert left to path and restart scan from portal left point.
					pts.push(portalLeft);
					// Make current left the new apex.
					portalApex = portalLeft;
					apexIndex = getNextPortalIndex(portals,leftIndex,portalApex);
					// Reset portal
					portalLeft = portalApex;
					portalRight = portalApex;
					leftIndex = apexIndex;
					rightIndex = apexIndex;
					// Restart scan
					i = apexIndex;
					continue;
				}
			}

			// Update left vertex.
			if (PointUtils.triarea2(portalApex, portalLeft, left) >= 0.0) {
				if (PointUtils.vequal(portalApex, portalLeft) || PointUtils.triarea2(portalApex, portalRight, left) < 0.0) {
					// Tighten the funnel.
					portalLeft = left;
					leftIndex = i;
				} else {
					// Left over right, insert right to path and restart scan from portal right point.
					pts.push(portalRight);
					// Make current right the new apex.
					portalApex = portalRight;
					apexIndex = getNextPortalIndex(portals,rightIndex,portalApex);
					// Reset portal
					portalLeft = portalApex;
					portalRight = portalApex;
					leftIndex = apexIndex;
					rightIndex = apexIndex;
					// Restart scan
					i = apexIndex;
					continue;
				}
			}	
			i++;
		}
		if ((pts.length == 0) || (!PointUtils.vequal(pts[pts.length - 1], portals[portals.length - 1].left))) {
			// Append last point to path.
			pts.push(portals[portals.length - 1].left);
		}
		return pts;
	}
	
	//search next portal that doesn't contain the apex
	private static function getNextPortalIndex(portals:Array<Portal>, apexIndex:Int, portalApex:Point):Int {
		var i:Int = apexIndex;
		while (i < portals.length && portals[i].contains(portalApex)) {
			i++;
		}
		return i;
	}
}



private class Portal {
	public var left:Point;
	public var right:Point;
	
	public function new(left:Point, right:Point) 
	{
		this.left = left;
		this.right = right;
	}
	
	public function toString() {
		return this.left.toString() + ".." + this.right.toString();
	}
	
	public function contains(point:Point) {
		return this.left.equals(point) || this.right.equals(point);
	}
}