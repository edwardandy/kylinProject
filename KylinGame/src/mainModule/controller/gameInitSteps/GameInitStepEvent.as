package mainModule.controller.gameInitSteps
{
	import flash.events.Event;
	
	import kylin.echo.edward.framwork.KylinEvent;
	
	public class GameInitStepEvent extends KylinEvent
	{
		/**
		 * 开始加载资源配置文件，游戏开始最优先加载 
		 */		
		public static const GameInitLoadResCfg:String = "LoadResCfg";
		/**
		 * 加载游戏配置文件 
		 */		
		public static const GameInitLoadGameCfg:String = "LoadGameCfg";
		/**
		 * 设置游戏配置 
		 */		
		public static const GameInitSetupGameCfg:String = "SetupGameCfg";
		/**
		 * 加载游戏预加载资源配置文
		 */		
		public static const GameInitLoadPreloadCfg:String = "LoadPreloadCfg";
		/**
		 * 加载游戏字体库 
		 */		
		public static const GameInitLoadFonts:String = "LoadFonts";
		/**
		 * 设置游戏显示层级
		 */		
		public static const GameInitSetViewLayers:String = "SetViewLayers";
		/**
		 * 预加载资源 
		 */		
		public static const GameInitPreLoadRes:String = "PreLoadRes";
		
		public function GameInitStepEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new GameInitStepEvent(type,bubbles,cancelable);
		}
	}
}