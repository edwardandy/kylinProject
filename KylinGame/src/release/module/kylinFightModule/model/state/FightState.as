package release.module.kylinFightModule.model.state
{
	/**
	 * 战斗状态 
	 * @author Edward
	 * 
	 */	
	public class FightState
	{
		/**
		 * 尚未初始化 
		 */		
		public static const UnInitialized:int = 0;
		/**
		 * 初始化完成 
		 */		
		public static const Initialized:int = 1;
		/**
		 * 战斗开始 
		 */		
		public static const StartFight:int = 2;
		/**
		 * 战斗暂停 
		 */		
		public static const PauseFight:int = 3;
		/**
		 * 战斗继续 
		 */		
		public static const ResumeFight:int = 4;
		/**
		 * 战斗结束 
		 */		
		public static const EndFight:int = 5;
		private var _state:int;
		
		public function FightState()
		{
		}
		
		/**
		 * 战斗当前状态 
		 */
		public function get state():int
		{
			return _state;
		}

		/**
		 * @private
		 */
		public function set state(value:int):void
		{
			_state = value;
		}
	}
}