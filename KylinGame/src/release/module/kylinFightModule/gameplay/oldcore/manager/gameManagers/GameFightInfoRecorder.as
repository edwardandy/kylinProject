package release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers
{
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain.controllBarFightIcons.PropIconView;
	import release.module.kylinFightModule.gameplay.oldcore.manager.eventsMgr.EndlessBattleMgr;
	import release.module.kylinFightModule.gameplay.oldcore.vo.GlobalTemp;
	
	import flash.utils.getTimer;
	
	import framecore.structure.model.user.UserData;
	import framecore.structure.model.user.taskOperationVOs.BattleOPVO;
	import framecore.structure.model.user.tollgate.TollgateData;

	public class GameFightInfoRecorder
	{
		public static const BATTLE_OP_TYPE_UPGRADE_TOWER:String = "upgradeTowers";
		public static const BATTLE_OP_TYPE_USE_SKILL:String = "useSkills";
		public static const BATTLE_OP_TYPE_USE_ITEM:String = "useItems";
		public static const BATTLE_OP_TYPE_COUNT_MONSTER:String = "monTotal";
		public static const BATTLE_OP_TYPE_HERO_KILL_MONSTER:String = "heroKillMonsters";
		public static const BATTLE_OP_TYPE_UPGRADE_TOWER_SKILL:String = "upgradeTowerSkill";
		
		//socre record temp data================================================
		private var _heroKilledUintTotalSocre:uint = 0;
		private var _magicSkillUsedTotalSocre:uint = 0;
		private var _propItemUsedTotalSocre:uint = 0;
		private var _wavePreactTotalTime:uint = 0;//单位毫秒
		
		private var _heroesExpMap:Object = {};//typeId -> exp
		private var _propItemUseCountMap:Object = {};//typeId->count
		
		private var _finalFightInfoData:Object = null;
		public var taskOpData:BattleOPVO = null;

		//英雄战斗获得经验值
		public function GameFightInfoRecorder()
		{
			super();
		}
		
		public function getFinalTaskOpData():BattleOPVO
		{
			taskOpData.useTime = GlobalTemp.useTime;
			taskOpData.tollID = TollgateData.currentLevelId;
			return taskOpData;
		}
				
		public function addBattleOPRecord( type:String, id:uint, num:int=1 ):void
		{
			if ( taskOpData[type][id] == null )
			{
				taskOpData[type][id] = num;
			}
			else
			{
				taskOpData[type][id] += num;
			}
		}
		
		public function addKillMonster( monID:uint ):void
		{
			if ( taskOpData.killMonsters[monID] == null )
			{
				taskOpData.killMonsters[monID] = 1;
			}
			else
			{
				taskOpData.killMonsters[monID]++;
			}
		}
		
		public function addBuildTower( towerID:uint ):void
		{
			if ( taskOpData.buildTowers[towerID] == null )
			{
				taskOpData.buildTowers[towerID] = 1;
			}
			else
			{
				taskOpData.buildTowers[towerID]++;
			}
		}
		
		public function addMoveHero( id:uint ):void
		{
			if ( taskOpData.moveHeros[id] == null )
			{
				taskOpData.moveHeros[id] = 1;
			}
			else
			{
				taskOpData.moveHeros[id]++;
			}
		}
		
		public function getFinalFightInfoData(isWin:Boolean):Object
		{
			if(_finalFightInfoData == null)
			{
				_finalFightInfoData = {
						fightId:GameAGlobalManager.getInstance().gameDataInfoManager.gameFightId,
						configId:TollgateData.currentLevelId,
						isWin:isWin,
						life:GameAGlobalManager.getInstance().gameDataInfoManager.sceneLife,
						goods:GameAGlobalManager.getInstance().gameDataInfoManager.sceneGold,
						score:getCurrentSceneResultScore(),
						star:getCurrentSceneResultStart(),
						hero:getAllHeroesExpData(),
						waveId:(isWin?GameAGlobalManager.getInstance().gameDataInfoManager.sceneWaveTotalCount:GameAGlobalManager.getInstance().gameDataInfoManager.sceneWaveCurrentCount-1),
						useItem:getAllPropItemsUseCountData(),
						skills:UserData.getInstance().userExtendInfo.currentMagicSkillIds,
						conjure:taskOpData.useSkills
					}
			};
			
			return _finalFightInfoData;
		}
		
		public function initializeFightInfo():void
		{
			reset();//rest first
			taskOpData = new BattleOPVO();
			initializeFightInfoHeores();
			initializeFightInfoPropItems();
		}
		
		private function initializeFightInfoHeores():void
		{
			var currentHeroTypeIds:Array = UserData.getInstance().userExtendInfo.currentHeroIds;
			var n:uint = currentHeroTypeIds.length;
			for(var i:uint = 0; i < n; i++)
			{
				_heroesExpMap[currentHeroTypeIds[i]] = 0;
			}
		}
		
		private function initializeFightInfoPropItems():void
		{
			var currentItemIds:Array = PropIconView.ITEMIDS;
			var n:uint = currentItemIds.length;
			for(var i:uint = 0; i < n; i++)
			{
				_propItemUseCountMap[currentItemIds[i]] = 0;
			}
			
			_propItemUseCountMap[138001] = 0;
			_propItemUseCountMap[138002] = 0;
			_propItemUseCountMap[138003] = 0;
		}
		
		private function reset():void
		{
			resetScore();
			_heroesExpMap = {};
			_propItemUseCountMap = {};
			_finalFightInfoData = null;
		}
		
		//当前英雄获得积分
		private function getAllHeroesExpData():Object//typeId -> value
		{
			return _heroesExpMap;
		}
		
		public function addHeroKillUintEXP(heroTypeId:int, value:uint):void
		{
			if(_heroesExpMap[heroTypeId] == undefined || value == 0) return;
			
			_heroesExpMap[heroTypeId] += value;
		}
		
		public function addPropItemUse(itemPropTypeId:int, useScore:uint):void
		{
			if(_propItemUseCountMap[itemPropTypeId] != undefined)
			{
				_propItemUseCountMap[itemPropTypeId] += 1;
				_propItemUsedTotalSocre += useScore;
				GameAGlobalManager.getInstance().gameDataInfoManager.updateSceneScore();
			}
		}
		
		private function getAllPropItemsUseCountData():Object
		{
			return _propItemUseCountMap;
		}
		
		//Socre record API======================================================
		//英雄杀死单位积分
		public function addHeroKillUintSocre(value:uint):void
		{
			_heroKilledUintTotalSocre += value;
			GameAGlobalManager.getInstance().gameDataInfoManager.updateSceneScore();
		}
		
		//法术使用次数积分
		public function addMagicSkillUseScore(value:uint):void
		{
			_magicSkillUsedTotalSocre += value;
			GameAGlobalManager.getInstance().gameDataInfoManager.updateSceneScore();
		}
		
		//单位毫秒
		public function addWavePreactTime(value:uint):void
		{
			_wavePreactTotalTime += value;
		}
		
		public function getCurrentSceneResultScore():uint
		{
			//var initializeScore:int = GameAGlobalManager.getInstance().gameDataInfoManager.currentSceneMapInfo.initializeScore;
			//var sceneLife:int = GameAGlobalManager.getInstance().gameDataInfoManager.sceneLife;
			//var sceneGold:int = GameAGlobalManager.getInstance().gameDataInfoManager.sceneGold;
			
			return EndlessBattleMgr.instance.recordScore + 
				_heroKilledUintTotalSocre + 
				_magicSkillUsedTotalSocre  +
				_propItemUsedTotalSocre /*+
				sceneGold +
				(_wavePreactTotalTime / 1000) + 
				sceneLife * 5*/;
		}
		
		//当前关卡获得星级
		public function getCurrentSceneResultStart():uint
		{
			var sceneLife:int = GameAGlobalManager.getInstance().gameDataInfoManager.sceneLife;
			if(sceneLife == 0) return 0;
			
			var sceneTotalLife:int = GameAGlobalManager.getInstance().gameDataInfoManager.totalSceneLife;
			var p:Number = sceneLife / sceneTotalLife;
			
			var star:uint = 0;
			if(p >= 0.9/*sceneLife == sceneTotalLife*/ )
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
		
		private function resetScore():void
		{
			_heroKilledUintTotalSocre = 0;
			_magicSkillUsedTotalSocre = 0;
			_propItemUsedTotalSocre = 0;
			_wavePreactTotalTime = 0;
		}
	}
}