package ghostcat.game.layer
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import ghostcat.community.sort.DepthSortUtil;
	import ghostcat.events.TickEvent;
	import ghostcat.game.layer.camera.ICamera;
	import ghostcat.game.layer.collision.ICollisionManager;
	import ghostcat.game.layer.position.IPositionManager;
	import ghostcat.game.layer.sort.ISortManager;
	import ghostcat.game.layer.sort.SortPriorityManager;
	import ghostcat.game.layer.sort.SortYManager;
	import ghostcat.util.Tick;
	import ghostcat.util.Util;
	
	public class GameLayerBase extends Sprite
	{
		public var isBitmapEngine:Boolean;
		
		public var children:Array = [];;
		public var childrenInScreen:Array = [];
		
		public var camera:ICamera;
		public var collision:ICollisionManager;
		public var position:IPositionManager;
		public var sort:ISortManager;
		public function GameLayerBase()
		{
			super();
			
			Tick.instance.addEventListener(TickEvent.TICK,tickHandler);
		}
		
		public function destory():void
		{
			Tick.instance.removeEventListener(TickEvent.TICK,tickHandler);
		}
		
		public function addObject(v:*):void
		{
			children.push(v);
			childrenInScreen.push(v);
		}
		
		public function removeObject(v:*):void
		{
			var index:int = children.indexOf(v);
			if (index != -1)
				children.splice(index, 1);
			
			index = childrenInScreen.indexOf(v);
			if (index != -1)
				childrenInScreen.splice(index, 1);
		}
		
		public function setObjectPosition(obj:DisplayObject,p:Point):void
		{
			if (position)
				p = position.transform(p);
			
			obj.x = p.x;
			obj.y = p.y;
		}
		
		public function getObjectPosition(obj:DisplayObject):Point
		{
			var p:Point = new Point(obj.x,obj.y);
			if (position)
				p = position.untransform(p);
			
			return p;
		}
		
		protected function tickHandler(event:TickEvent):void
		{
			if (camera)
				camera.render();
			
			if (sort)
				sort.sortAll();
			
			if (collision)
				collision.collideAll();
		}
	}
}