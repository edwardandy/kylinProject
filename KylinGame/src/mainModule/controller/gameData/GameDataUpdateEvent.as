package mainModule.controller.gameData
{
	import flash.events.Event;
		
	/**
	 * 游戏动态数据更新事件
	 * @author Edward
	 * 
	 */	
	public class GameDataUpdateEvent extends Event
	{
		/**
		 * 英雄数据更新 
		 */		
		public static const GameDataUpdate_HeroData:String = "gameDataUpdate_HeroData";
		/**
		 * 英雄技能数据更新 
		 */		
		public static const GameDataUpdate_HeroSkillData:String = "gameDataUpdate_HeroSkillData";
		/**
		 * 防御塔数据更新 
		 */		
		public static const GameDataUpdate_TowerData:String = "gameDataUpdate_TowerData";
		/**
		 * 魔法技能数据更新 
		 */		
		public static const GameDataUpdate_MagicSkillData:String = "gameDataUpdate_MagicSkillData";
		/**
		* 游戏动态数据更新事件
		* @author Edward
		* 
		*/	
		public function GameDataUpdateEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new GameDataUpdateEvent(type,bubbles,cancelable);
		}
	}
}