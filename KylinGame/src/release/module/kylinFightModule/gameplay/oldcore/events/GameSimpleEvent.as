package release.module.kylinFightModule.gameplay.oldcore.events
{
	import flash.events.Event;
	
	public class GameSimpleEvent extends Event
	{
		private var _data:Array;
		
		public function GameSimpleEvent(type:String, datas:Array=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_data = datas;
			super(type, bubbles, cancelable);
		}
		
		
		public function get data():Array
		{
			return _data;
		}

	}
}