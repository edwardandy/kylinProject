package release.module.kylinFightModule.utili.tween
{
	import com.greensock.TweenLite;
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import release.module.kylinFightModule.utili.tween.bezier.Bezier;

	public class BezierTween
	{
		private var _bezier:Bezier;
		private var _tween:TweenLite;
		private var _startTime:uint;
		private var _duration:Number;
		
		public static function getMidPoint(sp:Point,ep:Point,offSet:Number):Point{
			var cp :Point = new Point((sp.x + ep.x) / 2,(sp.y + ep.y) / 2);
			var signX:int = ep.x > sp.x ? 1 : -1;
			var signY:int = ep.y > sp.y ? -1 : 1;
			cp.x += signX * offSet * Math.random();
			cp.y += signY * offSet * Math.random();
			return cp;
		}
		
		public function BezierTween(target:*,duration:Number,sp:Point,cp:Point,ep:Point,props:Object)
		{
			_bezier = new Bezier(sp,cp,ep);
			props['onUpdate'] = onUpdate;
			props['overwrite'] = 0;
			_tween = TweenLite.to(target,duration,props);
			_duration = duration;
			_startTime = getTimer();
		}
		
		private function onUpdate():void
		{
			var duration:Number = _duration * 1000;
			var timeRate:Number = (getTimer() - _startTime) / duration;
			var p:Point = _bezier.getPoint(timeRate);
			_tween.target.x = p.x;
			_tween.target.y = p.y;
		}
	}
}