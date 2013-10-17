package release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers
{
	import com.shinezone.core.structure.controls.GameEvent;
	import com.shinezone.core.structure.moudle.PanelData;
	import com.shinezone.towerDefense.fight.constants.GamePlotProgress;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.BasicMonsterElement;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.GamePlotMgr;
	import release.module.kylinFightModule.gameplay.oldcore.manager.eventsMgr.EndlessBattleMgr;
	import release.module.kylinFightModule.gameplay.oldcore.vo.GlobalTemp;
	
	import flash.utils.getTimer;
	
	import framecore.structure.controls.battleCommand.Battle_CMD_Const;
	import framecore.structure.controls.uiCommand.UI_CMD_Const;
	import framecore.structure.model.constdata.HttpConst;
	import framecore.structure.model.constdata.NewbieConst;
	import framecore.structure.model.constdata.PopConst;
	import framecore.structure.model.user.TemplateDataFactory;
	import framecore.structure.model.user.monster.MonsterTemplateInfo;
	import framecore.structure.views.newguidPanel.NewbieGuideManager;
	
	import io.smash.time.TimeManager;

	/**
	 * 失败胜利判定逻辑 
	 * @author Administrator
	 * 
	 */	
	public final class GameFightSuccessAndFailedDetector
	{
		public function GameFightSuccessAndFailedDetector()
		{
			super();
		}
		
		//当敌方阵营到达终点时
		public function onEnemyCampUintArrivedEndPoint(monster:BasicMonsterElement,isBoss:Boolean = false):void
		{
			if(GameAGlobalManager.getInstance().gameDataInfoManager.sceneLife <= 0)
			{
				if(EndlessBattleMgr.instance.isEndless )
				{
					if ( EndlessBattleMgr.instance.canRebirth() )
					{
						GameEvent.getInstance().sendEvent(UI_CMD_Const.OPEN_POP , [UI_CMD_Const.OPEN_POP , "popPanel",PopConst.WRATH_OF_GOD,[EndlessBattleMgr.instance.iRebirthPrice]]);
						GameAGlobalManager.getInstance().game.pause( false, false );
						return;
					}
				}
				else if(!isBoss)
				{
					GameAGlobalManager.getInstance().game.pause(false,false);
					GlobalTemp.bForcePause = true;
					GameEvent.getInstance().sendEvent(UI_CMD_Const.OPEN_PANEL , [UI_CMD_Const.OPEN_PANEL , "deathRescue"]);
					return;
				}
				GameAGlobalManager.getInstance().game.notifyToGameOver(false);
			}
			else if(GameAGlobalManager.getInstance().groundSceneHelper.getAllEnemyCampOrganismElementsCount() == 0)
			{
				onClearCurWaveMonsters(/*monster*/);
			}
		}
		
		//当敌方阵营死亡时
		public function onEnemyCampUintDied(monster:BasicMonsterElement):void
		{
			GameAGlobalManager.getInstance().gameFightInfoRecorder.addKillMonster( monster.objectTypeId );
			var monsterTemp:MonsterTemplateInfo = TemplateDataFactory.getInstance().getMonsterTemplateById(monster.objectTypeId);
			if(monsterTemp)
				GameAGlobalManager.getInstance().gameFightInfoRecorder.addHeroKillUintSocre(monsterTemp.deadScore);
			
			if(GameAGlobalManager.getInstance().groundSceneHelper.getAllEnemyCampOrganismElementsCount() == 0)
			{
				onClearCurWaveMonsters(/*monster*/);
			}
		}
		
		public function onClearCurWaveMonsters(/*monster:BasicMonsterElement*/):void
		{
			if(EndlessBattleMgr.instance.isEndless)
			{
				if(EndlessBattleMgr.instance.isSavePointWave(GameAGlobalManager.getInstance().gameDataInfoManager.sceneWaveCurrentCount) 
				&& !GameAGlobalManager.getInstance().gameDataInfoManager.getIsCompleteWave())
				{
					EndlessBattleMgr.instance.saveProgress(GameAGlobalManager.getInstance().gameDataInfoManager.sceneWaveCurrentCount
						,GameAGlobalManager.getInstance().gameFightInfoRecorder.getCurrentSceneResultScore());
					//to do 弹出提示面板后执行
					GameEvent.getInstance().sendEvent(UI_CMD_Const.OPEN_PANEL, [UI_CMD_Const.OPEN_PANEL,"endlessPauseRestPanel"]);
				}
			}
			
			if(GameAGlobalManager.getInstance().gameDataInfoManager.getIsCompleteWave())
			{
				GlobalTemp.useTime = TimeManager.instance.virtualTime - GlobalTemp.tempTime;
				
				//清理新手引导
				NewbieGuideManager.getInstance().endCondition( NewbieConst.CONDITION_END_USE_ITEM_MAGIC, {"param":[210101]} );
				NewbieGuideManager.getInstance().endCondition( NewbieConst.CONDITION_END_USE_ITEM_MAGIC, {"param":[180001]} );
				
				NewbieGuideManager.getInstance().endCondition( NewbieConst.CONDITION_END_USED_OR_CANCEL_MAGIC, {"param":[210101]} );
				NewbieGuideManager.getInstance().endCondition( NewbieConst.CONDITION_END_USED_OR_CANCEL_MAGIC, {"param":[180001]} );
				
				NewbieGuideManager.getInstance().endCondition( NewbieConst.CONDITION_END_EMNIES_CLOSE_INTRO);
				
				NewbieGuideManager.getInstance().endCondition( NewbieConst.CONDITION_END_CLICK_TOWER_BASE);
				NewbieGuideManager.getInstance().endCondition( NewbieConst.CONDITION_END_CLICK_BUILD_MENU);
				NewbieGuideManager.getInstance().endCondition( NewbieConst.CONDITION_END_CLICK_TOWER);
				NewbieGuideManager.getInstance().endCondition( NewbieConst.CONDITION_END_CLICK_TOWER_UPGRADE_MENU);
				
				if(!GamePlotMgr.instance.playGamePlot(GamePlotProgress.END,onPlayPlotEnd))
					GameAGlobalManager.getInstance().game.notifyToGameOver(true);
			}	
		}
		
		private function onPlayPlotEnd():void
		{
			GameAGlobalManager.getInstance().game.notifyToGameOver(true);
		}
	}
}