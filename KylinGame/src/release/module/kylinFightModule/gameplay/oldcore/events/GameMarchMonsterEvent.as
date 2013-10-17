package release.module.kylinFightModule.gameplay.oldcore.events
{
	import flash.events.Event;

	public class GameMarchMonsterEvent extends Event
	{
		public static const WAIT_AND_READ_TO_MARCH_NEXT_WAVE:String = "waitAndReadyToMarchNextWave";
		public static const MARCH_NEXT_WAVE:String = "marchNextWave";
		
		public var nextWavepreactTime:uint = 0;
		
		public function GameMarchMonsterEvent(type:String)
		{
			super(type);
		}
	}
}