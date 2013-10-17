package release.module.kylinFightModule.gameplay.oldcore.utils
{
	import com.shinezone.towerDefense.fight.constants.GameFightConstant;
	import release.module.kylinFightModule.gameplay.oldcore.events.GameCDPauseEvent;
	
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	
	import io.smash.time.TimeManager;

	public class SimpleCDTimer
	{
		private static var ms_PauseTick:EventDispatcher = new EventDispatcher;
		
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
			return _uCurTickPoint==0 || (TimeManager.instance.virtualTime - _uCurTickPoint) >= (_coolDownDurationTime - extraCd);
		}
		
		//让cd及时不可以用 
		public function resetCDTime():void
		{
			_uCurTickPoint = TimeManager.instance.virtualTime || 1;
			//ms_PauseTick.addEventListener(GameCDPauseEvent.Game_CD_Pause,onGamePause,false,0,true);
		}
		
		//让cd及时可用
		public function clearCDTime():void
		{
			/*_uCurTickPoint = getTimer() - _coolDownDurationTime;
			if(_uCurTickPoint<0)*/
			_uCurTickPoint = 0;
			//ms_PauseTick.removeEventListener(GameCDPauseEvent.Game_CD_Pause,onGamePause);
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
			return _coolDownDurationTime - TimeManager.instance.virtualTime + _uCurTickPoint;
		}
		
		public function getCDCoolDownPercent():Number
		{
			return getCDCoolDownLeftTime() / _coolDownDurationTime;
		}
		
		/*private function onGamePause(e:GameCDPauseEvent):void
		{
			_pauseTick = getTimer();
			ms_PauseTick.addEventListener(GameCDPauseEvent.Game_CD_Resume,onGameResume,false,0,true);
		}*/
		
		/*private function onGameResume(e:GameCDPauseEvent):void
		{
			ms_PauseTick.removeEventListener(GameCDPauseEvent.Game_CD_Resume,onGameResume);
			if(_uCurTickPoint>0)
				_uCurTickPoint += getTimer() - _pauseTick;
		}*/
		
		/*public static function GamePaused():void
		{
			ms_PauseTick.dispatchEvent(new GameCDPauseEvent(GameCDPauseEvent.Game_CD_Pause));
		}
		
		public static function GameResumed():void
		{
			ms_PauseTick.dispatchEvent(new GameCDPauseEvent(GameCDPauseEvent.Game_CD_Resume));
		}*/
	}
}