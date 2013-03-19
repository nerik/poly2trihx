package org.poly2tri.tests;

#if flash
import flash.display.Sprite;
class Test extends Sprite
#else
class Test
#end
{

	public static function main() 
	{
		new Test();
	}

	function new() 
	{
		#if flash
		super();
		#end




		var points = [ 
							new Point(0,-100), 
							new Point(0,100),
							new Point(200,110),
							new Point(200,0)
							];
				// var points = [ 
				// 			new Point(0,0), 
				// 			new Point(100,0),
				// 			new Point(0,10)
				// 			];

		var vp = new VisiblePolygon();
		vp.addPolyline( points );



		var points2 = [ 
							new Point(40,40), 
							new Point(150,00),
							new Point(50,50),
							new Point(40,50)
							];

		vp.addPolyline(points2);




		#if flash
		var test = new Sprite();
		test.x = test.y = 100;
		flash.Lib.current.addChild(test);

		vp.drawShape( test.graphics );
		#else
		vp.performTriangulationOnce();

		#end
	
		trace(vp.getVerticesAndTriangles());

	}

}