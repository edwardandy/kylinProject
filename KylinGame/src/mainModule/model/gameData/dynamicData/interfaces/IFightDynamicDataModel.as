package mainModule.model.gameData.dynamicData.interfaces
{
	import kylin.echo.edward.utilities.datastructures.HashMap;

	/**
	 * 进战斗之前获得的战斗所需动态数据 
	 * @author Edward
	 * 
	 */	
	public interface IFightDynamicDataModel
	{
		/**
		 * 本次战斗的id,后台发送的 
		 */
		function get fightId():String;
		/**
		 * 进入的关卡id(每个关卡的各难度的id不同)
		 */
		function get tollgateId():uint;
		/**
		 * 关卡主id(每个关卡的各个难度的主id相同) 
		 * @return 
		 * 
		 */		
		function get tollgateMainId():uint;
		/**
		 * 通关后奖励道具及数量 [id=>count]
		 */	
		function get hashDropItems():HashMap;
		/**
		 * 关卡初始物资数 
		 */
		function get initGoods():int;
		/**
		 * 关卡怪物的生命值缩放系数 
		 */
		function get monLifeScale():Number;
		/**
		 * 关卡怪物的攻击力缩放系数 
		 */
		function get monAtkScale():Number;
		/**
		 * 本关卡新出现的怪物id数组 
		 */
		function get newMonsterIds():Array;
		/**
		 * 本关卡新出现的道具id数组 
		 */
		function get newItems():Array;
		/**
		 * 波次信息数组
		 * [{offsetStartTick=>int,subWaves=>[{startTime,interval,times,monsterCount,monsterTypeId,roadIndex,bRandomLine},...]},...] 
		 */
		function get waveInfo():Array;
	}
}