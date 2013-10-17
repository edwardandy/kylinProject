package release.module.kylinFightModule.gameplay.oldcore.events
{
	import flash.events.Event;

	public class GameDataInfoEvent extends Event
	{
		public static const INITIALIZE_DATA_INFO:String = "initializeDataInfo";
		
		public static const UPDATE_SCENE_LIFE:String = "updateSceneLife";
		public static const UPDATE_SCENE_GOLD:String = "updateSceneGold";
		public static const UPDATE_SCENE_WAVE:String = "updateSceneWave";
		public static const UPDATE_SCENE_SCORE:String = "updateSceneScore";
		
		public function GameDataInfoEvent(type:String)
		{
			super(type);
		}
	}
}