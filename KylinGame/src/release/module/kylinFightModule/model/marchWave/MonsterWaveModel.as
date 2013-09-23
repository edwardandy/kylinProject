package release.module.kylinFightModule.model.marchWave
{
	import kylin.echo.edward.framwork.model.KylinModel;
	
	import release.module.kylinFightModule.model.interfaces.IMonsterWaveModel;
	
	import utili.structure.FillObjectUtil;

	/**
	 * 出怪波次数据 
	 * @author Edward
	 * 
	 */
	public class MonsterWaveModel extends KylinModel implements IMonsterWaveModel
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
					FillObjectUtil.fillObj(subWaveVo,subWave);
					
					var arr:Array;
					(null != (arr = waveVo.waveMonsterSumInfos.get(subWaveVo.roadIndex))) || (arr = waveVo.waveMonsterSumInfos.put(subWaveVo.roadIndex,[]));
					arr.hasOwnProperty(subWaveVo.monsterTypeId) || (arr[subWaveVo.monsterTypeId] = 0);
					arr[subWaveVo.monsterTypeId] += subWaveVo.monsterCount;
					subWaveMaxEndTime = Math.max(subWaveMaxEndTime,subWaveVo.startTime + (subWaveVo.times - 1) * subWaveVo.interval);
				}
				waveVo.duration = subWaveMaxEndTime;
				
				_vecMonsterWaves.push(waveVo);
			}
		}
	}
}