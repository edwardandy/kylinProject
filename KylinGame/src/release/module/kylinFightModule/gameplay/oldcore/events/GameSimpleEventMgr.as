package release.module.kylinFightModule.gameplay.oldcore.events
{
	import flash.events.EventDispatcher;
	
	public class GameSimpleEventMgr extends EventDispatcher
	{
		private static var _instance:GameSimpleEventMgr;
		
		public function GameSimpleEventMgr()
		{
			super();
		}
		
		public static function get instance():GameSimpleEventMgr
		{
			return _instance ||= new GameSimpleEventMgr();
		}
	}
}