package me.nerik.poly2trihx;

import nme.display.Sprite;
import nme.events.Event;
import nme.events.KeyboardEvent;
import nme.events.MouseEvent;
import nme.Lib;
import nme.text.TextField;
import nme.ui.Keyboard;
import org.poly2tri.VisiblePolygon;
import org.poly2tri.Point;

class Demo extends Sprite 
{

	public static function main () 
	{
        Lib.current.addChild (new Demo ());
    }


  	var isDrawing:Bool;
	var polygons:Array<Polygon>;
	var polygonsContainer:Sprite;
	var currentPolygon:Polygon;
	var messageTf:TextField;

	var tesselatePreview:Sprite;
	var tesselated:Bool;



	public function new() 
	{
		super();
		
		
		this.addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );

		build();
		haxeLogoDemo();


	}



	function build() 
	{
		polygons = new Array();

		polygonsContainer = new Sprite();
		addChild( polygonsContainer );

		messageTf = new TextField();
		messageTf.autoSize = nme.text.TextFieldAutoSize.LEFT;
		addChild(messageTf);
	}


	function haxeLogoDemo() 
	{

		var testPolygon = new Polygon();
		testPolygon.points = TestPoints.HAXE_LOGO;

		var testPolygonHole = new Polygon();


		testPolygonHole.points = TestPoints.HAXE_LOGO_HOLE;			

		testPolygon.holes = [testPolygonHole];

		polygons = [testPolygon];
		tesselate();
	}




	function onAddedToStage(e) 
	{
		

		stage.addEventListener( MouseEvent.MOUSE_DOWN, onStageMouseDown );
		stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
	}




	function onStageMouseDown(e:MouseEvent) 
	{
		if (tesselated)
		{
			if (tesselatePreview != null && tesselatePreview.stage != null) removeChild(tesselatePreview);
			tesselated = false;
			messageTf.text = "click anywhere to start drawing a polygon";
			graphics.clear();
		}
		else if (isDrawing)
		{
			var state = currentPolygon.addSegment(e.stageX, e.stageY);

			if (state == Polygon.PolygonState.Error) return;

			if (currentPolygon.points.length > 2 )			messageTf.text = "add more points, or click on the circle to close this polygon" ;

			if (state == Polygon.PolygonState.Closed)
			{
				endPolygon();
			}
		
		}
		else
		{
			startPolygon( e.stageX, e.stageY );
		}

	}

	function onStageMouseMove(e:MouseEvent) 
	{
		
		currentPolygon.drawTmpSegment(e.stageX, e.stageY);

	}


	function startPolygon(initX, initY) 
	{


		stage.addEventListener( MouseEvent.MOUSE_MOVE, onStageMouseMove );
		isDrawing = true;


		//check if the starting point is inside another polygon, in which case we'll consider it a hole, and attach it to its parent later
		var parentPolygon:Polygon = null;

		for (i in 0...polygons.length) 
		{
			if (polygons[i].pointInPolygon( initX, initY ))
			{
				parentPolygon = polygons[i];
				break;
			}
		}

		currentPolygon = new Polygon(initX, initY, parentPolygon);

		if (!currentPolygon.isHole) polygons.push(currentPolygon);//else attach it later to parent polygon
		

		polygonsContainer.addChild(currentPolygon);

		messageTf.text = "click to add a point to this polygon.";

	}

	function endPolygon() 
	{
		messageTf.text = "click inside this polygon to add a hole or outside to create a new polygon. Press \"t\" to tesselate";

		currentPolygon.close();

		if ( currentPolygon.isHole )
		{
			currentPolygon.parentPolygon.holes.push(currentPolygon);
		}

		stage.removeEventListener( MouseEvent.MOUSE_MOVE, onStageMouseMove );
		isDrawing = false;
	}

	
	function onKeyDown(e:KeyboardEvent) 
	{
		if (e.keyCode == 84)
		{
			tesselate();
		}
	}

	function tesselate() 
	{


		tesselated = true;

		tesselatePreview = new Sprite();
		tesselatePreview.y = polygonsContainer.y;
		addChild(tesselatePreview);

		var numTriangles = 0;
		var serialized:Array<String> = [];

		for (i in 0...polygons.length) 
		{
			var poly = polygons[i];
			var vp = new VisiblePolygon();
			vp.addPolyline( poly.points );

			//add holes
			for (j in 0...poly.holes.length) 
			{
				vp.addPolyline(poly.holes[j].points);
			}

			vp.drawShape(tesselatePreview.graphics);

			serialized.push( Std.string(vp.getVerticesAndTriangles() ) );
			numTriangles += vp.getNumTriangles();

		}

		messageTf.text = "shape(s) tesselated, total "+numTriangles+" triangles. Click to start again\n" + serialized.join(", ");

		//get rid of drawn polygons
		while (polygonsContainer.numChildren>0) polygonsContainer.removeChildAt(0);
		polygons = [];
	}


}
