package kylin.echo.edward.ui
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.Rectangle;

	public class AutoAlign
	{
		public static const LEFT:String = "left";
		public static const CENTER:String = "center";
		public static const RIGHT:String = "right";
		
		public static function alignXTo(activeTargets:Array,fixTarget:DisplayObject,type:String = "center"):void
		{
			if(fixTarget.stage == null)return;
			var st:Stage = fixTarget.stage;
			var bound:Rectangle;
			var fixBound:Rectangle = fixTarget.getBounds(st);
			for each(var target:DisplayObject in activeTargets){
				bound = target.getBounds(st);
				switch(type){
					case LEFT:
						target.x += fixBound.x - bound.x;
						break;
					case CENTER:
						target.x += (fixBound.x + fixBound.width / 2) - (bound.x + bound.width / 2);
						break;
					case RIGHT:
						target.x += fixBound.right - bound.right;
						break;
				}
			}
		}
		
		public static function alignYTo(activeTargets:Array,fixTarget:DisplayObject,type:String = "center"):void
		{
			if(fixTarget.stage == null)return;
			var st:Stage = fixTarget.stage;
			var bound:Rectangle;
			var fixBound:Rectangle = fixTarget.getBounds(st);
			for each(var target:DisplayObject in activeTargets){
				bound = target.getBounds(st);
				switch(type){
					case LEFT:
						target.y += fixBound.y - bound.y;
						break;
					case CENTER:
						target.y += (fixBound.y + fixBound.height / 2) - (bound.y + bound.height / 2);
						break;
					case RIGHT:
						target.y += fixBound.bottom - bound.bottom;
						break;
				}
			}
			
		}
		
		
		public static function alignXToRect(activeTargets:Array,rect:Rectangle,type:String = "center"):void
		{
			var bound:Rectangle;
			for each(var target:DisplayObject in activeTargets){
				bound = target.getBounds(target.parent);
				switch(type){
					case LEFT:
						target.x += rect.x - bound.x;
						break;
					case CENTER:
						target.x += (rect.x + rect.width / 2) - (bound.x + bound.width / 2);
						break;
					case RIGHT:
						target.x += rect.right - bound.right;
						break;
				}
			}
		}
		
		public static function alignYToRect(activeTargets:Array,rect:Rectangle,type:String = "center"):void
		{
			var bound:Rectangle;
			for each(var target:DisplayObject in activeTargets){
				bound = target.getBounds(target.parent);
				switch(type){
					case LEFT:
						target.y += rect.y - bound.y;
						break;
					case CENTER:
						target.y += (rect.y + rect.height / 2) - (bound.y + bound.height / 2);
						break;
					case RIGHT:
						target.y += rect.bottom - bound.bottom;
						break;
				}
			}
		}
		
	}
}