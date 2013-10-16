package mainModule.model.gameData.sheetData.tollgate
{	
	import mainModule.model.gameData.sheetData.interfaces.IBaseDescSheetItem;

	/**
	 * 关卡数值表项 
	 * @author Edward
	 * 
	 */
	public interface ITollgateSheetItem extends IBaseDescSheetItem
	{
		/**
		 * 推荐打此关卡的平均等级 
		 */
		function get recommandTowerLvl():Number;
		/**
		 * 关卡是否有飞行怪 
		 */
		function get flyMonster():Boolean;
		/**
		 * 收税消耗能量 
		 */
		function get hangNeedEnergy():int;
		/**
		 * 解锁需要的星数 
		 */
		function get needStar():int;
		/**
		 * 解锁需要的荣誉值 
		 */
		function get needHornor():int;
		/**
		 *总波次 
		 */
		function get waveTimes():int;
		/**
		 *区分地图场景类型 如1草原 2雪地 3熔岩 4 沙漠 5沼泽 
		 */
		function get sceneType():int;
		/**
		 * 挂机时间
		 */
		function get hangTime():uint;
		/**
		 * 主线下一关卡
		 */
		function get nextTollId():uint;
		/**
		 * 影藏关卡id
		 */
		function get hideTollId():uint;
		/**
		 * 挂机经验
		 */
		function get hangExp():int;
		/**
		 * 关卡类型
		 */
		function get tollType():uint;
		/**
		 * 关卡相关限定配置
		 */
		function get tollLimitId():uint;
		/**
		 * 经验奖励 
		 */
		function get expReward():uint;
		/**
		 * 通关道具奖励
		 */
		function get succReward():uint;
		/**
		 * 通关金币奖励
		 */
		function get passReward():uint;
		/**
		 * 解锁关卡
		 */
		function get unlockTolls():String;
		/**
		 * 前置关卡
		 */
		function get preTollId():uint;
		/**
		 * 归属地图
		 */
		function get mapId():uint;
		/**
		 * 关卡分配物资
		 */
		function get goods():int;
		/**
		 * 关卡生命
		 */
		function get life():uint;
		/**
		 * 掉落信息
		 */
		function get dropInfo():String;
		/**
		 * 消耗能量
		 */
		function get needEnergy():int;
		/**
		 * 解锁关卡需要的城堡等级 
		 */
		function get needLevel():int;
		/**
		 * 关卡基础积分
		 */
		function get baseScore():uint;
		/**
		 * 难度
		 */
		function get hard():int;
		/**
		 * 关卡Id
		 */
		function get tollId():int;
		/**
		 * 关卡怪物波配置Id数组
		 */
		function get arrWaves():Array;
		/**
		 * 某类型的塔可升级到的最高等级 
		 * @param iType 塔类型
		 * @return 
		 * 
		 */		
		function getTowerMaxLvlByType(iType:int):int;
	}
}