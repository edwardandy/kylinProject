package release.module.kylinFightModule.utili.structure
{
	public class PointVO
	{
		public var x:Number = 0;
		public var y:Number = 0;
		
		public function PointVO(x:Number = 0, y:Number = 0)
		{
			this.x = x;
			this.y = y;
		}
		
		public function clone():PointVO
		{
			var p:PointVO = new PointVO(this.x, this.y);
			return p;
		}
		
		public function toString():String
		{
			return "[x: " + x + " y: " + y + "]";
		}
	}
}