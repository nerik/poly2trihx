package me.nerik.poly2trihx;

import nme.display.Sprite;
import org.poly2tri.Point;

enum PolygonState 
{
    Open;
 	Closed;
 	Error;
}

class Polygon extends Sprite 
{


	var startingPoint:Point;
	var currentPoint:Point;
	public var points:Array<Point>;

	var tmpCanvas:Sprite;
	var startMark:Sprite;
	var segmentsContainer:Sprite;

	public var holes:Array<Polygon>;
	public var isHole:Bool;
	public var parentPolygon:Polygon;


	public function new(initX:Float = 0, initY:Float = 0, parentPolygon = null) 
	{

		super();

		if (parentPolygon != null)
		{
			this.isHole = true;
			this.parentPolygon = parentPolygon;
		}

		

		tmpCanvas = new Sprite();
		addChild(tmpCanvas);

		currentPoint = new Point(initX, initY);
		startingPoint = new Point(initX, initY);
		points = [currentPoint];

		holes = new Array();

		startMark = new Sprite();
		startMark.graphics.beginFill(0x0);
		startMark.graphics.drawCircle(0, 0, 10);
		startMark.graphics.endFill();
		startMark.alpha = .2;
		startMark.x = initX;
		startMark.y = initY;
		addChild(startMark);

		
	}

	public function drawTmpSegment(sx:Float, sy:Float) 
	{

		

		tmpCanvas.graphics.clear();
		tmpCanvas.graphics.moveTo(currentPoint.x, currentPoint.y);

		if ( points.length>2 && isClosing(sx, sy ) )
		{
			startMark.scaleX = startMark.scaleY = 1.5;
			startMark.alpha = .6;
			tmpCanvas.graphics.lineStyle(3, 0x5B7AFF);
			tmpCanvas.graphics.lineTo( startingPoint.x, startingPoint.y );

		}
		else
		{
			startMark.scaleX = startMark.scaleY = 1;

			var color = (isCrossingSegment( currentPoint, new Point(sx, sy) ) ) ? 0xFF0000: 0x5B7AFF;
			
			tmpCanvas.graphics.lineStyle(1, color);

			tmpCanvas.graphics.lineTo( sx, sy );
		}

		
	}

	public function addSegment(sx:Float, sy:Float) 
	{

		var isClosing = isClosing(sx, sy);

		var nx = (isClosing) ? startingPoint.x: sx;
		var ny = (isClosing) ? startingPoint.y: sy;

		if ( !isClosing && isCrossingSegment( currentPoint, new Point(sx, sy) ) )
		{
			return PolygonState.Error;
		}


		var s = new Sprite();
		addChild(s);
		s.graphics.moveTo(currentPoint.x, currentPoint.y);
		s.graphics.lineStyle( (isHole) ? 1 : 2, 0x0);
		s.graphics.lineTo(nx, ny);		


		currentPoint = new Point(nx, ny);
	

		if (isClosing)
		{

			tmpCanvas.graphics.clear();
			return PolygonState.Closed;
		}

		points.push(currentPoint);

		return PolygonState.Open;
	}


	public function close() 
	{
		while (numChildren > 0) removeChildAt(0);


		this.graphics.beginFill((isHole)? 0xFFFFFF : 0x0, (isHole)?1:.1);
		this.graphics.lineStyle(0x0, .3);
		this.graphics.moveTo(points[0].x, points[0].y);

		for (i in 1...points.length) 
		{
			this.graphics.lineTo(points[i].x, points[i].y);
		}
	}



	function isClosing(sx:Float, sy:Float) 
	{
		var startingDx = Math.abs(sx - startingPoint.x);
		var startingDy = Math.abs(sy - startingPoint.y);

		return (startingDx < 10 && startingDy < 10);
	}









	//http://alienryderflex.com/polygon/
	public function pointInPolygon(tx:Float, ty:Float)
	{
		//a simple boundaries check should be done first

		var i = 0;
		var j = points.length-1;
		var oddNodes=false;

		for (i in 0...points.length) 
		{
			var pi = points[i];
			var pj = points[j];
			if (pi.y<ty && pj.y>=ty || pj.y<ty && pi.y>=ty)
			{
				if (pi.x+(ty-pi.y)/(pj.y-pi.y)*(pj.x-pi.x)<tx)
				{
					oddNodes=!oddNodes; 
				}
			}

			j=i;
		}

		return oddNodes;
	}


	function isCrossingSegment(pt1:Point, pt2:Point, complete = false) 
	{
		var start = (complete) ? 0 : 1;
		var i = start;
		var j = (complete) ? points.length-1 : 0;

		var numEdges = (complete) ? points.length : points.length-1;

		for (i in start...numEdges) 
		{
			if ( lineIntersectLine(pt1,pt2,points[i],points[j]  ) != null ) return true;

			j = i;
		}

		if (parentPolygon != null)
		{
			return parentPolygon.isCrossingSegment(pt1,pt2,true);
		}

		return false;
	}


	//http://keith-hair.net/blog/2008/08/04/find-intersection-point-of-two-lines-in-as3/
	//---------------------------------------------------------------
	//Checks for intersection of Segment if as_seg is true.
	//Checks for intersection of Line if as_seg is false.
	//Return intersection of Segment AB and Segment EF as a Point
	//Return null if there is no intersection
	//---------------------------------------------------------------
	static function lineIntersectLine(A:Point,B:Point,E:Point,F:Point,as_seg:Bool=true):Point {


	    var ip:Point;
	    var a1:Float;
	    var a2:Float;
	    var b1:Float;
	    var b2:Float;
	    var c1:Float;
	    var c2:Float;
	 
	    a1= B.y-A.y;
	    b1= A.x-B.x;
	    c1= B.x*A.y - A.x*B.y;
	    a2= F.y-E.y;
	    b2= E.x-F.x;
	    c2= F.x*E.y - E.x*F.y;
	 
	    var denom:Float=a1*b2 - a2*b1;
	    if (denom == 0) {
	        return null;
	    }
	    ip=new Point(0,0);
	    ip.x=(b1*c2 - b2*c1)/denom;
	    ip.y=(a2*c1 - a1*c2)/denom;
	 
	    //---------------------------------------------------
	    //Do checks to see if intersection to endpoints
	    //distance is longer than actual Segments.
	    //Return null if it is with any.
	    //---------------------------------------------------
	    if(as_seg){
	        if(Math.pow(ip.x - B.x, 2) + Math.pow(ip.y - B.y, 2) > Math.pow(A.x - B.x, 2) + Math.pow(A.y - B.y, 2))
	        {
	           return null;
	        }
	        if(Math.pow(ip.x - A.x, 2) + Math.pow(ip.y - A.y, 2) > Math.pow(A.x - B.x, 2) + Math.pow(A.y - B.y, 2))
	        {
	           return null;
	        }
	 
	        if(Math.pow(ip.x - F.x, 2) + Math.pow(ip.y - F.y, 2) > Math.pow(E.x - F.x, 2) + Math.pow(E.y - F.y, 2))
	        {
	           return null;
	        }
	        if(Math.pow(ip.x - E.x, 2) + Math.pow(ip.y - E.y, 2) > Math.pow(E.x - F.x, 2) + Math.pow(E.y - F.y, 2))
	        {
	           return null;
	        }
	    }
	    return ip;
	}

}
