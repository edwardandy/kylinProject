package
{
	import flash.display.Sprite;

	public class IntPositionSprite extends Sprite
	{
		public function IntPositionSprite()
		{
			super();
		}
		
		override public function set x(value:Number):void
		{
			super.x = Math.round(value);
		}
		
		override public function set y(value:Number):void
		{
			super.y = Math.round(value);
		}
	}
}