package release.module.kylinFightModule.gameplay.oldcore.utils
{	
	import io.smash.time.TimeManager;

	public class SimpleCDTimer
	{		
		[Inject]
		public var timeMgr:TimeManager;
		
		private var _coolDownDurationTime:int = 0;
		private var _uCurTickPoint:int = 0;
		private var _pauseTick:int = 0;
		
		public function SimpleCDTimer(durationTime:int = 0)
		{
			_coolDownDurationTime = durationTime;
		}
		
		public function setDurationTime(durationTime:int,bClear:Boolean = true):void
		{
			_coolDownDurationTime = durationTime;
			if(bClear)
				_uCurTickPoint = 0;
		}
		
		public function get duration():int
		{
			return _coolDownDurationTime;
		}
		
		public function getIsCDEnd(extraCd:int = 0):Boolean
		{
			return _uCurTickPoint==0 || (timeMgr.virtualTime - _uCurTickPoint) >= (_coolDownDurationTime - extraCd);
		}
		
		//让cd及时不可以用 
		public function resetCDTime():void
		{
			_uCurTickPoint = timeMgr.virtualTime || 1;
		}
		
		//让cd及时可用
		public function clearCDTime():void
		{
			_uCurTickPoint = 0;
		}
		
		public function decreaseCDCoolDownRunTime(value:uint):void
		{
			_uCurTickPoint -= value;
			if(_uCurTickPoint<0)
				_uCurTickPoint = 0;
		}
		
		public function increaseCDCoolDownRunTime(value:uint):void
		{
			if(_uCurTickPoint>0)
				_uCurTickPoint += value;
		}

		public function getCDCoolDownLeftTime():int
		{
			if(getIsCDEnd()) 
				return 0;
			return _coolDownDurationTime - timeMgr.virtualTime + _uCurTickPoint;
		}
		
		public function getCDCoolDownPercent():Number
		{
			return getCDCoolDownLeftTime() / _coolDownDurationTime;
		}
	}
}