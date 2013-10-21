package release.module.kylinFightModule.model.interfaces
{	
	import kylin.echo.edward.gameplay.IKylinGameManager;
	
	import release.module.kylinFightModule.gameplay.oldcore.core.IFightLifecycle;
	import release.module.kylinFightModule.model.marchWave.MonsterWaveVO;
	
	/**
	 * 出怪波次数据 
	 * @author Edward
	 * 
	 */	
	public interface IMonsterWaveModel extends IKylinGameManager,IFightLifecycle
	{
		/**
		 * 获得某一波的出怪数据 
		 * @param idx 波次序号
		 * @return 出怪数据
		 * 
		 */		
		function getMonsterWave(idx:int):MonsterWaveVO;
		/**
		 * 当前关卡出怪总波次数量 
		 * @return 
		 * 
		 */		
		function get totalWaveCount():int;
		/**
		 * 当前出怪的波次 
		 * @return 
		 * 
		 */		
		function get curWaveCount():int;
		function set curWaveCount(value:int):void;
		/**
		 * 是否所有波次出怪完毕 
		 * @return 
		 * 
		 */		
		function get isCompleteWave():Boolean;
		function set isCompleteWave(value:Boolean):void;
		/**
		 * 更新波次数据 
		 * @param waves 波次数据数组 
		 * [{offsetStartTick=>int,subWaves=>[{startTime,interval,times,monsterCount,monsterTypeId,roadIndex,bRandomLine},...]},...]
		 * 
		 */		
		function updateData(waves:Array):void;
		/**
		 * 增加当前已出波次 
		 * 
		 */		
		function increaseSceneWave():void;
	}
}