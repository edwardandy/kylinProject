package release.module.kylinFightModule.gameplay.oldcore.events
{
	import flash.events.Event;

	public class SceneElementEvent extends Event
	{
		public static const LEAVE_OFF_SCREEN_SEARCH_RANGE:String = "leaveOffScreenSearchRange";
		public static const ON_FOCUS:String = "onFocus";
		public static const ON_DISFOCUS:String = "onDisFocus";
		public static const ON_LIFE_CHANGED:String = "onLifeChanged";

		public function SceneElementEvent(type:String)
		{
			super(type, false, false);
		}
	}
}