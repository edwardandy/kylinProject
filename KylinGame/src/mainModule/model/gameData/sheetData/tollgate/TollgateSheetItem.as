package mainModule.model.gameData.sheetData.tollgate
{
	import flash.utils.Dictionary;
	
	import mainModule.model.gameData.sheetData.BaseDescSheetItem;

	/**
	 * 关卡数值表项 
	 * @author Edward
	 * 
	 */
	public class TollgateSheetItem extends BaseDescSheetItem
	{
		/**
		 * 简单模式
		 */
		public static const SIMPLE:String = "1";
		/**
		 * 中等模式
		 */
		public static const MEDIUM:String = "2";
		/**
		 * 高级模式
		 */
		public static const SENIOR:String = "3";
		/**
		 * 关卡Id
		 */
		public var tollId:int;
		/**
		 * 难度
		 */
		public var hard:int;
		/**
		 * 关卡基础积分
		 */
		public var baseScore:uint;
		/**
		 * 解锁关卡需要的城堡等级 
		 */
		public var needLevel:int;
		/**
		 * 消耗能量
		 */
		public var needEnergy:int;
		/**
		 * 掉落信息
		 */
		public var dropInfo:String;
		/**
		 * 关卡生命
		 */
		public var life:uint;
		/**
		 * 关卡分配物资
		 */
		public var goods:int;
		/**
		 * 归属地图
		 */
		public var mapId:uint;
		/**
		 * 前置关卡
		 */
		public var preTollId:uint;
		/**
		 * 解锁关卡
		 */
		public var unlockTolls:String;
		/**
		 * 通关金币奖励
		 */
		public var passReward:uint;
		/**
		 * 通关道具奖励
		 */
		public var succReward:uint;
		/**
		 * 经验奖励 
		 */
		public var expReward:uint;
		/**
		 * 关卡相关限定配置
		 */
		public var tollLimitId:uint;
		/**
		 * 关卡类型
		 */
		public var tollType:uint;
		
		private var _arrLockTowerTypes:Array = [];
		public function set towerLocked(value:String):void
		{
			_arrLockTowerTypes.length = 0;
			if(!value)
				return;
			_arrLockTowerTypes = value.split(",").map(function(type:String,...args):int{return int(type);});
		}
		/**
		 * 该类型的塔是否不能在本关卡建造 
		 * @param type 塔类型
		 * @return 
		 * 
		 */		
		public function isTowerTypeLocked(type:int):Boolean
		{
			return _arrLockTowerTypes && (-1 != _arrLockTowerTypes.indexOf(type));
		}
		/**
		 * 可以建造的塔最高等级 
		 */		
		private var _dicMaxTowerLvls:Dictionary = new Dictionary;
		/**
		 * 设置本关卡可以建造的塔最高等级 
		 * @param value towerType1:maxLvl1;towerType2:maxLvl2;...
		 * 
		 */		
		public function set maxTowerLvl(value:String):void
		{
			_dicMaxTowerLvls = new Dictionary;
			if(!value)
				return;
			var arrLimits:Array = value.split(";");
			for each(var limit:String in arrLimits)
			{
				var arrSub:Array = limit.split(":");
				_dicMaxTowerLvls[int(arrSub[0])] = int(arrSub[1]);
			}
		}
		/**
		 * 某类型的塔可升级到的最高等级 
		 * @param iType 塔类型
		 * @return 
		 * 
		 */		
		public function getTowerMaxLvlByType(iType:int):int
		{
			if(!_dicMaxTowerLvls[iType])
				return 0;
			return _dicMaxTowerLvls[iType];
		}
		
		private var _arrWaves:Array;
		
		public function set wave(s:String):void
		{
			if(!s)
				return;
			_arrWaves = s.split(",");
		}
		/**
		 * 关卡怪物波配置Id数组
		 */
		public function get arrWaves():Array
		{
			return _arrWaves;
		}
		/**
		 * 挂机经验
		 */
		public var hangExp:int;
		/**
		 * 影藏关卡id
		 */
		public var hideTollId:uint;
		/**
		 * 主线下一关卡
		 */
		public var nextTollId:uint;
		/**
		 * 挂机时间
		 */
		public var hangTime:uint;
		
		/**
		 *区分地图场景类型 如1草原 2雪地 3熔岩 4 沙漠 5沼泽 
		 */		
		public var sceneType:int;
		/**
		 *总波次 
		 */
		public var waveTimes:int;
		/**
		 * 解锁需要的荣誉值 
		 */
		public var needHornor:int;
		/**
		 * 解锁需要的星数 
		 */
		public var needStar:int;
		/**
		 * 收税消耗能量 
		 */
		public var hangNeedEnergy:int;
		/**
		 * 关卡是否有飞行怪 
		 */
		public var flyMonster:Boolean;
		/**
		 * 推荐打此关卡的平均等级 
		 */
		public var recommandTowerLvl:Number;
		
		public function TollgateSheetItem()
		{
			super();
		}
	}
}