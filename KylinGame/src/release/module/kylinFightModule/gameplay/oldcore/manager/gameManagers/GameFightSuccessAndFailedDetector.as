package release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers
{
	import flash.events.IEventDispatcher;
	
	import mainModule.model.gameData.sheetData.monster.IMonsterSheetDataModel;
	import mainModule.model.gameData.sheetData.monster.IMonsterSheetItem;
	
	import release.module.kylinFightModule.controller.fightInitSteps.FightInitStepsEvent;
	import release.module.kylinFightModule.controller.fightState.FightStateEvent;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.BasicMonsterElement;
	import release.module.kylinFightModule.model.interfaces.IMonsterWaveModel;
	import release.module.kylinFightModule.model.interfaces.ISceneDataModel;
	import release.module.kylinFightModule.service.sceneElements.ISceneElementsService;

	/**
	 * 失败胜利判定逻辑 
	 * @author Administrator
	 * 
	 */	
	public final class GameFightSuccessAndFailedDetector
	{
		[Inject]
		public var sceneModel:ISceneDataModel;
		[Inject]
		public var sceneElementsModel:ISceneElementsService;
		[Inject]
		public var fightInfo:GameFightInfoRecorder;
		[Inject]
		public var monsterModel:IMonsterSheetDataModel;
		[Inject]
		public var monsterWaveModel:IMonsterWaveModel;
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		public function GameFightSuccessAndFailedDetector()
		{
			super();
		}
		
		//当敌方阵营到达终点时
		public function onEnemyCampUintArrivedEndPoint(monster:BasicMonsterElement,isBoss:Boolean = false):void
		{
			if(sceneModel.sceneLife <= 0)
			{
				/*if(EndlessBattleMgr.instance.isEndless )
				{
					if ( EndlessBattleMgr.instance.canRebirth() )
					{
						//GameEvent.getInstance().sendEvent(UI_CMD_Const.OPEN_POP , [UI_CMD_Const.OPEN_POP , "popPanel",PopConst.WRATH_OF_GOD,[EndlessBattleMgr.instance.iRebirthPrice]]);
						GameAGlobalManager.getInstance().game.pause( false, false );
						return;
					}
				}
				else */if(!isBoss)
				{
					eventDispatcher.dispatchEvent(new FightStateEvent(FightStateEvent.FightPause,false));
					//GameEvent.getInstance().sendEvent(UI_CMD_Const.OPEN_PANEL , [UI_CMD_Const.OPEN_PANEL , "deathRescue"]);
					return;
				}
				eventDispatcher.dispatchEvent(new FightInitStepsEvent(FightInitStepsEvent.FightGameOver,false));
			}
			else if(sceneElementsModel.getAllEnemyCampOrganismElementsCount() == 0)
			{
				onClearCurWaveMonsters();
			}
		}
		
		//当敌方阵营死亡时
		public function onEnemyCampUintDied(monster:BasicMonsterElement):void
		{
			var monsterTemp:IMonsterSheetItem = monsterModel.getMonsterSheetById(monster.objectTypeId);
			if(monsterTemp)
				fightInfo.addHeroKillUintSocre(monsterTemp.deadScore);
			
			if(sceneElementsModel.getAllEnemyCampOrganismElementsCount() == 0)
			{
				onClearCurWaveMonsters(/*monster*/);
			}
		}
		
		public function onClearCurWaveMonsters():void
		{
			/*if(EndlessBattleMgr.instance.isEndless)
			{
				if(EndlessBattleMgr.instance.isSavePointWave(monsterWaveModel.curWaveCount) 
				&& !monsterWaveModel.isCompleteWave)
				{
					EndlessBattleMgr.instance.saveProgress(monsterWaveModel.curWaveCount
						,fightInfo.getCurrentSceneResultScore());
					//to do 弹出提示面板后执行
					GameEvent.getInstance().sendEvent(UI_CMD_Const.OPEN_PANEL, [UI_CMD_Const.OPEN_PANEL,"endlessPauseRestPanel"]);
				}
			}*/
			
			if(monsterWaveModel.isCompleteWave)
			{
				//GlobalTemp.useTime = TimeManager.instance.virtualTime - GlobalTemp.tempTime;
				
				//清理新手引导
				/*NewbieGuideManager.getInstance().endCondition( NewbieConst.CONDITION_END_USE_ITEM_MAGIC, {"param":[210101]} );
				NewbieGuideManager.getInstance().endCondition( NewbieConst.CONDITION_END_USE_ITEM_MAGIC, {"param":[180001]} );
				
				NewbieGuideManager.getInstance().endCondition( NewbieConst.CONDITION_END_USED_OR_CANCEL_MAGIC, {"param":[210101]} );
				NewbieGuideManager.getInstance().endCondition( NewbieConst.CONDITION_END_USED_OR_CANCEL_MAGIC, {"param":[180001]} );
				
				NewbieGuideManager.getInstance().endCondition( NewbieConst.CONDITION_END_EMNIES_CLOSE_INTRO);
				
				NewbieGuideManager.getInstance().endCondition( NewbieConst.CONDITION_END_CLICK_TOWER_BASE);
				NewbieGuideManager.getInstance().endCondition( NewbieConst.CONDITION_END_CLICK_BUILD_MENU);
				NewbieGuideManager.getInstance().endCondition( NewbieConst.CONDITION_END_CLICK_TOWER);
				NewbieGuideManager.getInstance().endCondition( NewbieConst.CONDITION_END_CLICK_TOWER_UPGRADE_MENU);*/
				
				/*if(!GamePlotMgr.instance.playGamePlot(GamePlotProgress.END,onPlayPlotEnd))
					GameAGlobalManager.getInstance().game.notifyToGameOver(true);*/
				onPlayPlotEnd();
			}	
		}
		
		private function onPlayPlotEnd():void
		{
			eventDispatcher.dispatchEvent(new FightInitStepsEvent(FightInitStepsEvent.FightGameOver,true));;
		}
	}
}