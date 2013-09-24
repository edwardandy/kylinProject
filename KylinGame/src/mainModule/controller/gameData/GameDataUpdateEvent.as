package mainModule.controller.gameData
{
	import flash.events.Event;
	
	import kylin.echo.edward.framwork.KylinEvent;
	
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