package release.module.kylinFightModule.model.marchWave
{
	import kylin.echo.edward.utilities.datastructures.HashMap;
	
	import utili.behavior.interfaces.IDispose;

	/**
	 * 每一个大波次出怪数据 
	 * @author Edward
	 * 
	 */	
	public class MonsterWaveVO implements IDispose
	{
		private var _offsetStartTick:int;
		private var _duration:int;
		private var _vecSubWaves:Vector.<MonsterSubWaveVO>;
			
		private var _waveMonsterSumInfos:HashMap;
		
		private var _totalMonsters:int = -1;
		
		public function MonsterWaveVO()
		{
			_vecSubWaves = new Vector.<MonsterSubWaveVO>;
			_waveMonsterSumInfos = new HashMap;
		}
		/**
		 *  路径序号对应的数组,该数组的索引为怪物id，值为怪物数量:[roadIndex->[monsterTypeId=>count, ...], ...]
		 */	
		public function get waveMonsterSumInfos():HashMap
		{
			return _waveMonsterSumInfos;
		}

		/**
		 * 该大波次包含的小波次列表 
		 */
		public function get vecSubWaves():Vector.<MonsterSubWaveVO>
		{
			return _vecSubWaves;
		}

		/**
		 * 该大波次出怪的总持续时间
		 */
		public function get duration():int
		{
			return _duration;
		}

		/**
		 * @private
		 */
		public function set duration(value:int):void
		{
			_duration = value;
		}

		/**
		 * 每个大波次在上一个大波次结束后等待多久开始出怪 
		 */
		public function get offsetStartTick():int
		{
			return _offsetStartTick;
		}

		/**
		 * @private
		 */
		public function set offsetStartTick(value:int):void
		{
			_offsetStartTick = value;
		}

		/**
		 * 该大波次出怪的总数量 
		 * @return 
		 * 
		 */		
		public function get totalMonsters():int
		{
			if(_totalMonsters > 0)
				return _totalMonsters;
			_totalMonsters = 0;
			
			var arrPairs:Array = _waveMonsterSumInfos.values();
			
			for each(var cnt:int in arrPairs)
			{
				_totalMonsters += cnt;
			}
			return _totalMonsters;
		}
		
		public function dispose():void
		{
			_totalMonsters = -1;
			_vecSubWaves.length = 0;
			_vecSubWaves = null;
			_waveMonsterSumInfos.clear();
			_waveMonsterSumInfos = null;
		}
	}
}