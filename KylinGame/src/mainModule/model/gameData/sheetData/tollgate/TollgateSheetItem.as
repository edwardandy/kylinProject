package mainModule.model.gameData.sheetData.tollgate
{
	import flash.utils.Dictionary;
	
	import kylin.echo.edward.utilities.string.KylinStringUtil;
	
	import mainModule.model.gameData.sheetData.BaseDescSheetItem;

	/**
	 * 关卡数值表项 
	 * @author Edward
	 * 
	 */
	public class TollgateSheetItem extends BaseDescSheetItem implements ITollgateSheetItem
	{
		private var _tollId:int;
		private var _hard:int;
		private var _baseScore:uint;
		private var _needLevel:int;
		private var _needEnergy:int;
		private var _dropInfo:String;
		private var _life:uint;
		private var _goods:int;
		private var _mapId:uint;
		private var _preTollId:uint;
		private var _unlockTolls:String;
		private var _passReward:uint;
		private var _succReward:uint;
		private var _expReward:uint;
		private var _tollLimitId:uint;
		private var _tollType:uint;
		private var _hangExp:int;
		private var _hideTollId:uint;
		private var _nextTollId:uint;
		private var _hangTime:uint;
		private var _sceneType:int;
		private var _waveTimes:int;
		private var _needHornor:int;
		private var _needStar:int;
		private var _hangNeedEnergy:int;
		private var _flyMonster:Boolean;
		private var _recommandTowerLvl:Number;
		
		
		private var _arrLockTowerTypes:Array = [];
		/**
		 * 可以建造的塔最高等级 
		 */		
		private var _dicMaxTowerLvls:Dictionary = new Dictionary;
		private var _arrWaves:Array;
		
		public function TollgateSheetItem()
		{
			super();
		}
		
		/**
		 * 推荐打此关卡的平均等级 
		 */
		public function get recommandTowerLvl():Number
		{
			return _recommandTowerLvl;
		}

		/**
		 * @private
		 */
		public function set recommandTowerLvl(value:Number):void
		{
			_recommandTowerLvl = value;
		}

		/**
		 * 关卡是否有飞行怪 
		 */
		public function get flyMonster():Boolean
		{
			return _flyMonster;
		}

		/**
		 * @private
		 */
		public function set flyMonster(value:Boolean):void
		{
			_flyMonster = value;
		}

		/**
		 * 收税消耗能量 
		 */
		public function get hangNeedEnergy():int
		{
			return _hangNeedEnergy;
		}

		/**
		 * @private
		 */
		public function set hangNeedEnergy(value:int):void
		{
			_hangNeedEnergy = value;
		}

		/**
		 * 解锁需要的星数 
		 */
		public function get needStar():int
		{
			return _needStar;
		}

		/**
		 * @private
		 */
		public function set needStar(value:int):void
		{
			_needStar = value;
		}

		/**
		 * 解锁需要的荣誉值 
		 */
		public function get needHornor():int
		{
			return _needHornor;
		}

		/**
		 * @private
		 */
		public function set needHornor(value:int):void
		{
			_needHornor = value;
		}

		/**
		 *总波次 
		 */
		public function get waveTimes():int
		{
			return _waveTimes;
		}

		/**
		 * @private
		 */
		public function set waveTimes(value:int):void
		{
			_waveTimes = value;
		}

		/**
		 *区分地图场景类型 如1草原 2雪地 3熔岩 4 沙漠 5沼泽 
		 */
		public function get sceneType():int
		{
			return _sceneType;
		}

		/**
		 * @private
		 */
		public function set sceneType(value:int):void
		{
			_sceneType = value;
		}

		/**
		 * 挂机时间
		 */
		public function get hangTime():uint
		{
			return _hangTime;
		}

		/**
		 * @private
		 */
		public function set hangTime(value:uint):void
		{
			_hangTime = value;
		}

		/**
		 * 主线下一关卡
		 */
		public function get nextTollId():uint
		{
			return _nextTollId;
		}

		/**
		 * @private
		 */
		public function set nextTollId(value:uint):void
		{
			_nextTollId = value;
		}

		/**
		 * 影藏关卡id
		 */
		public function get hideTollId():uint
		{
			return _hideTollId;
		}

		/**
		 * @private
		 */
		public function set hideTollId(value:uint):void
		{
			_hideTollId = value;
		}

		/**
		 * 挂机经验
		 */
		public function get hangExp():int
		{
			return _hangExp;
		}

		/**
		 * @private
		 */
		public function set hangExp(value:int):void
		{
			_hangExp = value;
		}

		/**
		 * 关卡类型
		 */
		public function get tollType():uint
		{
			return _tollType;
		}

		/**
		 * @private
		 */
		public function set tollType(value:uint):void
		{
			_tollType = value;
		}

		/**
		 * 关卡相关限定配置
		 */
		public function get tollLimitId():uint
		{
			return _tollLimitId;
		}

		/**
		 * @private
		 */
		public function set tollLimitId(value:uint):void
		{
			_tollLimitId = value;
		}

		/**
		 * 经验奖励 
		 */
		public function get expReward():uint
		{
			return _expReward;
		}

		/**
		 * @private
		 */
		public function set expReward(value:uint):void
		{
			_expReward = value;
		}

		/**
		 * 通关道具奖励
		 */
		public function get succReward():uint
		{
			return _succReward;
		}

		/**
		 * @private
		 */
		public function set succReward(value:uint):void
		{
			_succReward = value;
		}

		/**
		 * 通关金币奖励
		 */
		public function get passReward():uint
		{
			return _passReward;
		}

		/**
		 * @private
		 */
		public function set passReward(value:uint):void
		{
			_passReward = value;
		}

		/**
		 * 解锁关卡
		 */
		public function get unlockTolls():String
		{
			return _unlockTolls;
		}

		/**
		 * @private
		 */
		public function set unlockTolls(value:String):void
		{
			_unlockTolls = value;
		}

		/**
		 * 前置关卡
		 */
		public function get preTollId():uint
		{
			return _preTollId;
		}

		/**
		 * @private
		 */
		public function set preTollId(value:uint):void
		{
			_preTollId = value;
		}

		/**
		 * 归属地图
		 */
		public function get mapId():uint
		{
			return _mapId;
		}

		/**
		 * @private
		 */
		public function set mapId(value:uint):void
		{
			_mapId = value;
		}

		/**
		 * 关卡分配物资
		 */
		public function get goods():int
		{
			return _goods;
		}

		/**
		 * @private
		 */
		public function set goods(value:int):void
		{
			_goods = value;
		}

		/**
		 * 关卡生命
		 */
		public function get life():uint
		{
			return _life;
		}

		/**
		 * @private
		 */
		public function set life(value:uint):void
		{
			_life = value;
		}

		/**
		 * 掉落信息
		 */
		public function get dropInfo():String
		{
			return _dropInfo;
		}

		/**
		 * @private
		 */
		public function set dropInfo(value:String):void
		{
			_dropInfo = value;
		}

		/**
		 * 消耗能量
		 */
		public function get needEnergy():int
		{
			return _needEnergy;
		}

		/**
		 * @private
		 */
		public function set needEnergy(value:int):void
		{
			_needEnergy = value;
		}

		/**
		 * 解锁关卡需要的城堡等级 
		 */
		public function get needLevel():int
		{
			return _needLevel;
		}

		/**
		 * @private
		 */
		public function set needLevel(value:int):void
		{
			_needLevel = value;
		}

		/**
		 * 关卡基础积分
		 */
		public function get baseScore():uint
		{
			return _baseScore;
		}

		/**
		 * @private
		 */
		public function set baseScore(value:uint):void
		{
			_baseScore = value;
		}

		/**
		 * 难度
		 */
		public function get hard():int
		{
			return _hard;
		}

		/**
		 * @private
		 */
		public function set hard(value:int):void
		{
			_hard = value;
		}

		/**
		 * 关卡Id
		 */
		public function get tollId():int
		{
			return _tollId;
		}

		/**
		 * @private
		 */
		public function set tollId(value:int):void
		{
			_tollId = value;
		}

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
	}
}