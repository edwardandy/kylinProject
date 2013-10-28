package release.module.kylinFightModule.model.marchWave
{
	import kylin.echo.edward.framwork.model.KylinActor;
	import kylin.echo.edward.utilities.datastructures.FillObjectUtil;
	
	import release.module.kylinFightModule.gameplay.oldcore.events.GameDataInfoEvent;
	import release.module.kylinFightModule.model.interfaces.IMonsterWaveModel;
	

	/**
	 * 出怪波次数据 
	 * @author Edward
	 * 
	 */
	public class MonsterWaveModel extends KylinActor implements IMonsterWaveModel
	{
		private var _vecMonsterWaves:Vector.<MonsterWaveVO>;
		private var _curWaveCount:int;
		private var _isCompleteWave:Boolean;
		
		public function MonsterWaveModel()
		{
			super();
			_vecMonsterWaves = new Vector.<MonsterWaveVO>;
		}
		
		public function get isCompleteWave():Boolean
		{
			return _isCompleteWave;
		}

		public function set isCompleteWave(value:Boolean):void
		{
			_isCompleteWave = value;
		}

		public function get curWaveCount():int
		{
			return _curWaveCount;
		}

		public function set curWaveCount(value:int):void
		{
			_curWaveCount = value;
		}

		public function getMonsterWave(idx:int):MonsterWaveVO
		{
			if(idx<0 || idx>_vecMonsterWaves.length)
				return null;
			return _vecMonsterWaves[idx];
		}
		
		public function get totalWaveCount():int
		{
			return _vecMonsterWaves.length;
		}
		
		public function increaseSceneWave():void
		{
			if(_isCompleteWave) 
				return;
			
			if(_curWaveCount < totalWaveCount)
			{
				_curWaveCount++;
				var event:GameDataInfoEvent = new GameDataInfoEvent(GameDataInfoEvent.UPDATE_SCENE_WAVE);
				dispatch(event);
			}
		}
		
		public function initialize():void
		{
			
		}
			
		public function destroy():void
		{
			for each(var wave:MonsterWaveVO in _vecMonsterWaves)
			{
				wave.dispose();
			}
			_vecMonsterWaves.length = 0;
			_vecMonsterWaves = null;
		}
		
		public function updateData(waves:Array):void
		{
			if(!waves || 0 == waves.length)
				return;
			
			destroy();
			_vecMonsterWaves = new Vector.<MonsterWaveVO>;
			
			for each(var wave:Object in waves)
			{
				var waveVo:MonsterWaveVO = new MonsterWaveVO;
				waveVo.offsetStartTick = wave.offsetStartTick;
				var subWaveMaxEndTime:int = -1;
				for each(var subWave:Object in wave.subWaves)
				{
					var subWaveVo:MonsterSubWaveVO = new MonsterSubWaveVO;
					waveVo.vecSubWaves.push(subWaveVo);
					FillObjectUtil.fillObj(subWaveVo,subWave);
					
					var arr:Array;
					arr = waveVo.waveMonsterSumInfos.get(subWaveVo.roadIndex);
					if(null == arr)
					{
						waveVo.waveMonsterSumInfos.put(subWaveVo.roadIndex,[]);
						arr = waveVo.waveMonsterSumInfos.get(subWaveVo.roadIndex);
					}
					arr.hasOwnProperty(subWaveVo.monsterTypeId) || (arr[subWaveVo.monsterTypeId] = 0);
					arr[subWaveVo.monsterTypeId] += subWaveVo.monsterCount;
					subWaveMaxEndTime = Math.max(subWaveMaxEndTime,subWaveVo.startTime + (subWaveVo.times - 1) * subWaveVo.interval);
				}
				waveVo.duration = subWaveMaxEndTime;
				
				_vecMonsterWaves.push(waveVo);
			}
		}
		
		/**
		 * @inheritDoc 
		 */		
		public function onFightStart():void
		{
			_curWaveCount = 0;
			_isCompleteWave = false;
		}
		/**
		 * 战斗结束 
		 * 
		 */		
		public function onFightEnd():void
		{
			
		}
		/**
		 * @inheritDoc 
		 */		
		public function onFightPause():void
		{
			
		}
		/**
		 * @inheritDoc 
		 */		
		public function onFightResume():void
		{
			
		}
		/**
		 * @inheritDoc 
		 */	
		public function dispose():void
		{
			destroy();
		}
	}
}