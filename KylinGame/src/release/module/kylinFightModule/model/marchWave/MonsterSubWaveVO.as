package release.module.kylinFightModule.model.marchWave
{
	public class MonsterSubWaveVO
	{
		/**
		 * 该小波次在所在的大波次开始后的出怪时间 
		 */		
		public var startTime:int;
		/**
		 * 该小波次每轮出怪的间隔 
		 */		
		public var interval:int;
		/**
		 * 该小波次出几轮怪物
		 */		
		public var times:int;
		/**
		 * 该小波次出怪的总数量 
		 */		
		public var monsterCount:int;
		/**
		 * 该小波次出的怪物id 
		 */		
		public var monsterTypeId:int;
		/**
		 * 该小波次出怪所走的道路索引 
		 */		
		public var roadIndex:int;
		/**
		 * 当只出一个怪物的时候，怪物所走的道路类型:true为随机，false为只走中间 
		 */		
		public var bRandomLine:Boolean;
	}
}