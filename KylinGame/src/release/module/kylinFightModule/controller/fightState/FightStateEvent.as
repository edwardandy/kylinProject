package release.module.kylinFightModule.controller.fightState
{
	import flash.events.Event;
	/**
	 * 战斗状态转换事件 
	 * @author Edward
	 * 
	 */	
	public class FightStateEvent extends Event
	{
		/**
		 * 战斗开始(包括重新开始)
		 */		
		public static const FightStart:String = "fightStart";
		/**
		 * 战斗暂停
		 */		
		public static const FightPause:String = "fightPause";
		/**
		 * 战斗继续
		 */		
		public static const FightResume:String = "fightResume";
		/**
		 * 战斗结束(可以重新开始)
		 */		
		public static const FightEnd:String = "fightEnd";
		/**
		 * 战斗完全结束，将退出战斗
		 */		
		public static const FightQuit:String = "fightQuit";
		
		private var _data:Object;
		
		public function FightStateEvent(type:String,body:Object=null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_data = body;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new FightStateEvent(type,_data,bubbles,cancelable) as Event;
		}
		
		/**
		 * 事件所带的数据
		 * @return 
		 * 
		 */		
		public function get data():Object
		{
			return _data;
		}
	}
}