package org.poly2tri.utils;

import org.poly2tri.utils.TriangleCell;


/**
 * ...
 * @author LunaFromTheMoon
 */

 
class AStar
{

	private function new() 
	{
		
	}
	
	private static function getPath(last:TriangleCell):Array<TriangleCell>	{
		//trace the path by going backwards from goal node to start node
		var path:Array<TriangleCell> = [last];
		var node:TriangleCell = last.prevCell;
		while (node != null)
		{
			path.unshift(node);
			node = node.prevCell;
		}
		return path;
	}
	
	private static function cleanGraph(map:Array<TriangleCell>) {
		for (node in map) {
			node.prevCell = null;
			node.marked = false;
			node.distance = 0;
		}
	}
	
	private static function sortByHeuristic(nodes:Array<TriangleCell>, last:TriangleCell):Array<TriangleCell> {
		nodes.sort( function(a:TriangleCell, b:TriangleCell):Int {
				var aF:Float = a.distance + a.heuristicTo(last);
				var bF:Float = b.distance + b.heuristicTo(last);
				if (aF < bF) return -1;
				if (aF > bF) return 1;
				return 0;
			} );
		return nodes;
	}
	
	/**
	 *      This function does very little.
	 *      @param map The graph
	 *      @param startNode The first node in the path
	 *      @param goalNode The last node in the path
	 *      @return The path if found, else null
	 **/
	public static function find(startNode:TriangleCell, goalNode:TriangleCell,map:Array<TriangleCell>):Array<TriangleCell> {
		cleanGraph(map);
		var queue:Array<TriangleCell> = new Array<TriangleCell>();
		queue.push(startNode);
		while (!(queue.length == 0)) {
			//obtain the first node (with smallest aproximate distance to goal)
			var currentNode:TriangleCell = queue[0];
			queue.splice(0, 1);
			if (!currentNode.marked) {
				currentNode.marked = true;
				//check if we're in goal
				if (currentNode == goalNode) {
					return getPath(goalNode);
				}
				//try to get there through the neighbours
				for (next in currentNode.neighbours) {
					//process only new nodes
					if (!next.marked) {
						var distance = currentNode.distance + (currentNode.distanceTo(next) * currentNode.weightTo(next));
						if (next.prevCell == null || distance < next.distance) {
							//node not in queue, or in queue but with longer distance							
							next.prevCell = currentNode;
							next.distance = distance;							
						}
						//if not in queue, add
						if (queue.indexOf(next) == -1) {
							queue.push(next);
						}
					}
				}
				//sort queue by aproximate shortest distance to goal node
				queue = sortByHeuristic(queue, goalNode);
			}
		}
		return null;
	}
}