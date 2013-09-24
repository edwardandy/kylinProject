package release.module.kylinFightModule.controller.fightInitSteps
{
	import flash.events.Event;
	
	
	public class FightInitStepsEvent extends Event
	{
		/**
		 * 单机时根据配置表填充虚拟的战斗数据 
		 */		
		public static const FightFillVirtualData:String = "fightFillVirtualData";
		/**
		 * 加载战斗背景地图资源
		 */		
		public static const FightLoadMapImg:String = "fightLoadMapImg";
		/**
		 * 加载战斗地图配置
		 */		
		public static const FightLoadMapCfg:String = "fightLoadMapCfg";
		/**
		 * 战斗前准备完毕，开始战斗
		 */		
		public static const FightStartup:String = "fightStartup";
		
		public function FightInitStepsEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new FightInitStepsEvent(type,bubbles,cancelable) as Event;
		}
	}
}