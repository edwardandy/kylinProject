package release.module.kylinFightModule.controller.fightInitSteps
{
	import flash.events.Event;
	
	/**
	 * 战斗前初始化步骤事件 
	 * @author Edward
	 * 
	 */	
	public class FightInitStepsEvent extends Event
	{
		/**
		 * 进入战斗前请求战斗数据
		 */		
		public static const FightRequestData:String = "fightRequestData";
		/**
		 * 加载战斗背景地图资源
		 */		
		public static const FightLoadMapImg:String = "fightLoadMapImg";
		/**
		 * 加载战斗地图配置
		 */		
		public static const FightLoadMapCfg:String = "fightLoadMapCfg";
		/**
		 * 预加载战斗动画资源
		 */		
		public static const FightPreLoadRes:String = "fightPreLoadRes";
		/**
		 * 战斗前准备完毕，开始战斗
		 */		
		public static const FightStartup:String = "fightStartup";
		/**
		 * 战斗结束，需要传递参数，true:胜利，false:失败
		 */		
		public static const FightGameOver:String = "fightGameOver";
		/**
		 * 重新开始战斗 
		 */		
		public static const FightRestart:String = "fightRestart";
		
		private var _data:Object;
		
		public function FightInitStepsEvent(type:String,body:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_data = body;
			super(type, bubbles, cancelable);
		}
		/**
		 * 事件的数据 
		 * @return 
		 * 
		 */		
		public function get data():Object
		{
			return _data;
		}

		override public function clone():Event
		{
			return new FightInitStepsEvent(type,_data,bubbles,cancelable) as Event;
		}
	}
}