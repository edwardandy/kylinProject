package mainModule.model.gameData.dynamicData.fight
{
	import kylin.echo.edward.utilities.datastructures.HashMap;
	
	import mainModule.model.gameData.dynamicData.BaseDynamicDataModel;
	import mainModule.model.gameData.dynamicData.DynamicDataNameConst;
	import mainModule.model.gameData.dynamicData.interfaces.IFightDynamicDataModel;

	/**
	 * 进战斗之前获得的战斗所需动态数据 
	 * @author Edward
	 * 
	 */	
	public class FightDynamicDataModel extends BaseDynamicDataModel implements IFightDynamicDataModel
	{
		private var _fightId:String;
		private var _tollgateId:uint;	
		private var _dropItems:HashMap;
		private var _initGoods:int;
		private var _monAtkScale:Number;
		private var _monLifeScale:Number;
		private var _newMonsterIds:Array;
		private var _newItems:Array;
		private var _waveInfo:Array;
		
		public function FightDynamicDataModel()
		{
			super();
			dataId = DynamicDataNameConst.FightData;
			updateEventType = "";
		}

		/**
		 * 波次信息数组
		 * [{offsetStartTick=>int,subWaves=>[{startTime,interval,times,monsterCount,monsterTypeId,roadIndex,bRandomLine},...]},...] 
		 */
		public function get waveInfo():Array
		{
			return _waveInfo;
		}

		/**
		 * @private
		 */
		public function set waveInfo(value:Array):void
		{
			_waveInfo = value;
		}

		/**
		 * 本关卡新出现的道具id数组 
		 */
		public function get newItems():Array
		{
			return _newItems;
		}

		/**
		 * @private
		 */
		public function set newItems(value:Array):void
		{
			_newItems = value;
		}

		/**
		 * 本关卡新出现的怪物id数组 
		 */
		public function get newMonsterIds():Array
		{
			return _newMonsterIds;
		}

		/**
		 * @private
		 */
		public function set newMonsterIds(value:Array):void
		{
			_newMonsterIds = value;
		}

		/**
		 * 关卡怪物的生命值缩放系数 
		 */
		public function get monLifeScale():Number
		{
			return _monLifeScale;
		}

		/**
		 * @private
		 */
		public function set monLifeScale(value:Number):void
		{
			_monLifeScale = value;
		}

		/**
		 * 关卡怪物的攻击力缩放系数 
		 */
		public function get monAtkScale():Number
		{
			return _monAtkScale;
		}

		/**
		 * @private
		 */
		public function set monAtkScale(value:Number):void
		{
			_monAtkScale = value;
		}

		/**
		 * 关卡初始物资数 
		 */
		public function get initGoods():int
		{
			return _initGoods;
		}

		/**
		 * @private
		 */
		public function set initGoods(value:int):void
		{
			_initGoods = value;
		}

		/**
		 * 进入的关卡id(每个关卡的各难度的id不同)
		 */
		public function get tollgateId():uint
		{
			return _tollgateId;
		}

		/**
		 * @private
		 */
		public function set tollgateId(value:uint):void
		{
			_tollgateId = value;
		}

		/**
		 * 本次战斗的id,后台发送的 
		 */
		public function get fightId():String
		{
			return _fightId;
		}

		/**
		 * @private
		 */
		public function set fightId(value:String):void
		{
			_fightId = value;
		}

		/**
		 * 关卡主id(每个关卡的各个难度的主id相同) 
		 * @return 
		 * 
		 */		
		public function get tollgateMainId():uint
		{
			return tollgateId * 0.1;
		}
		
		public function set dropItems(arrDrops:Array):void
		{
			if(!arrDrops || 0 == arrDrops.length)
				return;
			_dropItems ||= new HashMap;
			for(var key:* in arrDrops)
			{
				_dropItems.put(uint(key),int(arrDrops[key]));
			}
		}
		/**
		 * 通关后奖励道具及数量 [id->count]
		 */	
		public function get hashDropItems():HashMap
		{
			return _dropItems;
		}
	}
}