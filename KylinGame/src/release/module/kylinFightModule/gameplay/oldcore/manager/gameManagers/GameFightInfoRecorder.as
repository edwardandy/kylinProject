package release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers
{
	import mainModule.model.gameConstAndVar.interfaces.IConfigDataModel;
	import mainModule.model.gameData.dynamicData.fight.IFightDynamicDataModel;
	import mainModule.model.gameData.dynamicData.hero.IHeroDynamicDataModel;
	
	import release.module.kylinFightModule.model.interfaces.IMonsterWaveModel;
	import release.module.kylinFightModule.model.interfaces.ISceneDataModel;
	/**
	 * 战斗中的统计数据，生成最终的战斗结果数据 
	 * @author Edward
	 * 
	 */	
	public class GameFightInfoRecorder extends BasicGameManager
	{
		[Inject]
		public var fightData:IFightDynamicDataModel;
		[Inject]
		public var sceneData:ISceneDataModel;
		[Inject]
		public var monsterWaveData:IMonsterWaveModel;
		[Inject]
		public var heroData:IHeroDynamicDataModel;
		[Inject]
		public var cfgData:IConfigDataModel;
		//socre record temp data================================================
		private var _heroKilledUintTotalSocre:uint = 0;
		private var _magicSkillUsedTotalSocre:uint = 0;
		private var _propItemUsedTotalSocre:uint = 0;
		
		private var _heroesExpMap:Object = {};//typeId -> exp
		private var _propItemUseCountMap:Object = {};//typeId->count
		
		private var _finalFightInfoData:Object = null;
		private var _isWin:Boolean;
		
		public function GameFightInfoRecorder()
		{
			super();
		}
		/**
		 * 战斗胜利 
		 * @return 
		 * 
		 */		
		public function get isWin():Boolean
		{
			return _isWin;
		}

		public function set isWin(value:Boolean):void
		{
			_isWin = value;
		}

		[PostConstruct]
		public function onPostConstruct():void
		{
			initializeFightInfoHeores();
			initializeFightInfoPropItems();
		}
		/**
		 * 生成最终战斗结果数据回传给服务器 
		 * @return 
		 * 
		 */		
		public function getFinalFightInfoData():Object
		{
			if(_finalFightInfoData == null)
			{
				_finalFightInfoData = {
						fightId:fightData.fightId,
						tollgateId:fightData.tollgateId,
						bWin:_isWin,
						life:sceneData.sceneLife,
						goods:sceneData.sceneGoods,
						score:getCurrentSceneResultScore(),
						star:getCurrentSceneResultStar(),
						hero:_heroesExpMap,
						waveCount:(isWin?monsterWaveData.totalWaveCount:monsterWaveData.curWaveCount-1),
						useItems:_propItemUseCountMap
					}
			};
			return _finalFightInfoData;
		}
		/**
		 * 英雄杀怪获得经验值 
		 * @param heroTypeId
		 * @param value
		 * 
		 */		
		public function addHeroKillUintEXP(heroTypeId:int, value:uint):void
		{
			if(_heroesExpMap[heroTypeId] == undefined || value == 0) 
				return;
			
			_heroesExpMap[heroTypeId] += value;
		}
		/**
		 * 使用道具的积分累计 
		 * @param itemPropTypeId
		 * @param useScore
		 * 
		 */		
		public function addPropItemUse(itemPropTypeId:int, useScore:uint):void
		{
			if(_propItemUseCountMap[itemPropTypeId] != undefined)
			{
				_propItemUseCountMap[itemPropTypeId] += 1;
				_propItemUsedTotalSocre += useScore;
				sceneData.updateSceneScore();
			}
		}
		/**
		 * 统计英雄杀怪的积分
		 * @param value
		 * 
		 */		
		public function addHeroKillUintSocre(value:uint):void
		{
			_heroKilledUintTotalSocre += value;
			sceneData.updateSceneScore();
		}
		/**
		 * 统计法术使用的积分 
		 * @param value
		 * 
		 */		
		public function addMagicSkillUseScore(value:uint):void
		{
			_magicSkillUsedTotalSocre += value;
			sceneData.updateSceneScore();
		}
		/**
		 * 获得本次战斗的累计积分 
		 * @return 
		 * 
		 */		
		public function getCurrentSceneResultScore():uint
		{	
			 /*EndlessBattleMgr.instance.recordScore + */
			return _heroKilledUintTotalSocre + 
				_magicSkillUsedTotalSocre  +
				_propItemUsedTotalSocre;
		}
		/**
		 * 当前关卡的星数 
		 * @return 
		 * 
		 */		
		public function getCurrentSceneResultStar():uint
		{
			var sceneLife:int = sceneData.sceneLife;
			if(sceneLife == 0) return 0;
			
			var sceneTotalLife:int = sceneData.sceneTotalLife;
			var p:Number = sceneLife / sceneTotalLife;
			
			var star:uint = 0;
			if(p >= 0.9)
			{
				star =  3;
			}
			else if(p >= 0.5 )
			{
				star =  2;
			} 
			else if(p < 0.5 && sceneLife >=1 )
			{
				star =  1;
			}
			
			return star;	
		}
		
		private function initializeFightInfoHeores():void
		{
			for each(var id:uint in heroData.arrHeroIdsInFight)
			{
				_heroesExpMap[id] = 0;
			}
		}
		
		private function initializeFightInfoPropItems():void
		{
			for each(var id:uint in cfgData.arrItemIdsInFight)
			{
				_propItemUseCountMap[id] = 0;
			}
		}
		
		override public function onFightStart():void
		{
			super.onFightStart();
			_heroKilledUintTotalSocre = 0;
			_magicSkillUsedTotalSocre = 0;
			_propItemUsedTotalSocre = 0;
			_finalFightInfoData = null;
			_isWin = false;
			initializeFightInfoHeores();
			initializeFightInfoPropItems();
		}
		
		override public function dispose():void
		{
			super.dispose();
			_heroesExpMap = null;
			_propItemUseCountMap = null;
			_finalFightInfoData = null;
		}
	}
}