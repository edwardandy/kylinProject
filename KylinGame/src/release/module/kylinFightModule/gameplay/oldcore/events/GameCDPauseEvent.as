package release.module.kylinFightModule.gameplay.oldcore.events
{
	import flash.events.Event;
	
	public class GameCDPauseEvent extends Event
	{
		public static const Game_CD_Pause:String = "gameCdPause";
		public static const Game_CD_Resume:String = "gameCdResume";
		
		public function GameCDPauseEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}