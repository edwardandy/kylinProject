package release.module.kylinFightModule.gameplay.oldcore.display
{
	import com.shinezone.core.structure.controls.GameEvent;
	import com.shinezone.core.structure.moudle.PanelData;
	import com.shinezone.towerDefense.fight.constants.GameFightConstant;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import com.shinezone.towerDefense.fight.constants.GamePlotProgress;
	import com.shinezone.towerDefense.fight.constants.Skill.SkillType;
	import com.shinezone.towerDefense.fight.constants.TowerDefenseGameState;
	import release.module.kylinFightModule.gameplay.oldcore.core.BasicView;
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
	import release.module.kylinFightModule.gameplay.oldcore.core.TickSynchronizer;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.GameFightLoadingView;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain.GameFightMainUIView;
	import release.module.kylinFightModule.gameplay.oldcore.events.GameDataInfoEvent;
	import release.module.kylinFightModule.gameplay.oldcore.events.SceneElementFocusEvent;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.GamePlotMgr;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.GamePreloadResMgr;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.PopupManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.TimeTaskManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.eventsMgr.EndlessBattleMgr;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameFightMonsterMarchManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameFightPopupManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.SimpleCDTimer;
	import release.module.kylinFightModule.gameplay.oldcore.vo.GlobalTemp;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	import com.shinezone.towerDefense.fight.vo.map.LineVO;
	import com.shinezone.towerDefense.fight.vo.map.MapConfigDataVO;
	import com.shinezone.towerDefense.fight.vo.map.RoadVO;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import framecore.structure.controls.battleCommand.Battle_CMD_Const;
	import framecore.structure.controls.uiCommand.UI_CMD_Const;
	import framecore.structure.model.constdata.GameConst;
	import framecore.structure.model.constdata.NewbieConst;
	import framecore.structure.model.constdata.TaskTypeConst;
	import framecore.structure.model.user.TemplateDataFactory;
	import framecore.structure.model.user.UserData;
	import framecore.structure.model.user.base.BaseSkillInfo;
	import framecore.structure.model.user.dreamland.DreamLandData;
	import framecore.structure.model.user.dreamland.DreamLandNode;
	import framecore.structure.model.user.fight.FightData;
	import framecore.structure.model.user.hero.HeroData;
	import framecore.structure.model.user.hero.HeroInfo;
	import framecore.structure.model.user.heroSkill.HeroSkillTemplateInfo;
	import framecore.structure.model.user.item.ItemData;
	import framecore.structure.model.user.item.ItemInfo;
	import framecore.structure.model.user.taskOperationVOs.BattleOPVO;
	import framecore.structure.model.user.tollgate.TollgateData;
	import framecore.structure.model.user.tollgate.TollgateInfo;
	import framecore.structure.model.user.tollgate.TollgateTemplateInfo;
	import framecore.structure.model.user.weapon.WeaponTemplateInfo;
	import framecore.structure.model.varMoudle.GameVar;
	import framecore.structure.views.newguidPanel.NewbieGuideManager;
	import framecore.tools.GameStringUtil;
	import framecore.tools.logger.logch;
	import framecore.tools.task.TaskManager;
	
	import io.smash.time.TimeManager;
	
	import mx.core.mx_internal;

	public class TowerDefenseGame extends BasicView implements IDisposeObject
	{
		private var _gameState:int = TowerDefenseGameState.GAME_UNREADY;

		private var _gameMenuLayer:Sprite;
		private var _gamePopUpLayer:Sprite;
		private var _gamePopUpLayerModalShape:Sprite;

		private var _gameFightMainUIView:GameFightMainUIView;
		private var _groundScene:GroundScene = null;
		
		public function TowerDefenseGame()
		{
			super();
		}

		//ITowerDefenseGame Interface
		public function get gameState():int
		{
			return 	_gameState;
		}
		
		public function playBattleEffect( type:int ,param:Array = null ):void
		{
			_gameFightMainUIView.playBattleEffect( type ,param );
		}
		
		public function quitGame():void
		{
			var preStateIsGameOverState:Boolean = _gameState == TowerDefenseGameState.GAME_OVER;
			_gameState = TowerDefenseGameState.GAME_UNREADY;
			
			//必须放在前面执行，场景里的对象会使用到下面的管理器
			_groundScene.destoryAllSceneElements();
			
			if(!preStateIsGameOverState)
			{
				isLockUIInteracticveByGameState(true);

				//TickSynchronizer.getInstance().pauseTick();
				TimeTaskManager.getInstance().reset();

				GameAGlobalManager.getInstance().onGameEnd();
				_gameFightMainUIView.onGameEnd();
				
				TimeManager.instance.destroy();
			}

			/*if(EndlessBattleMgr.instance.isEndless)
				GlobalTemp.quitDestFlag = 2;*/
			
			//var completeFightObj:Object = GameAGlobalManager.getInstance().gameFightInfoRecorder.getFinalFightInfoData(false);
			//GameEvent.getInstance().sendEvent(Battle_CMD_Const.CMD_COMPLETEBATTLE_REQ, [completeFightObj]);
			
			//GameEvent.getInstance().sendEvent(Battle_CMD_Const.MSG_DEACTIVE_ON_BATTLE,[false]);
				
			GameEvent.getInstance().sendEvent(Battle_CMD_Const.CMD_CLOSEBATTLE, [GlobalTemp.quitDestFlag]);
			
		}
		
		public function notifyToGameOver(isSuccess:Boolean):void
		{
			if(_gameState != TowerDefenseGameState.GAME_RUNNING && _gameState != TowerDefenseGameState.GAME_PAUSED) 
				return;
			
			_gameState = TowerDefenseGameState.GAME_OVER;
			
			isLockUIInteracticveByGameState(true);

			var currentLevelId:int = TollgateData.currentLevelId;
			var tollgateTemplateInfo:TollgateTemplateInfo = TollgateInfo(TollgateData.getInstance().getOwnInfoById(currentLevelId)).tollgateTemplateInfo;
			
			//同步server端数据
			var completeFightObj:Object = GameAGlobalManager.getInstance().gameFightInfoRecorder.getFinalFightInfoData(isSuccess);
			var taskOpData:BattleOPVO = GameAGlobalManager.getInstance().gameFightInfoRecorder.getFinalTaskOpData();
			taskOpData.isWin = isSuccess;
			taskOpData.star = completeFightObj.star;
			
			/*if ( EndlessBattleMgr.instance.isEndless )
			{
				taskOpData.endlessWaves = completeFightObj.waveId;
			}*/
			TaskManager.getInstance().updateProgress( TaskTypeConst.OPTYPE_BATTLE, taskOpData );
			completeFightObj["taskInfo"] = TaskManager.getInstance().getBattleTasksInfo();
			
			GameEvent.getInstance().sendEvent(Battle_CMD_Const.CMD_COMPLETEBATTLE_REQ, [completeFightObj]);

			//战斗结果面板
			/*if(EndlessBattleMgr.instance.isEndless)
			{
				GameEvent.getInstance().sendEvent(UI_CMD_Const.OPEN_PANEL, [UI_CMD_Const.OPEN_PANEL,"endlessBattleResultPanel"]);
				//DreamLandData.getInstance().setNode({score:EndlessBattleMgr.instance.lastSavePointScore,waveId:EndlessBattleMgr.instance.lastSavePointWave});
				DreamLandData.getInstance().setCurrent(new DreamLandNode(completeFightObj.score,completeFightObj.waveId));
				logch("EndlessData:","EndlessResult",completeFightObj);
			}
			else*/
			{
				GameEvent.getInstance().sendEvent(UI_CMD_Const.OPEN_PANEL, [UI_CMD_Const.OPEN_PANEL,"battleResultPanel"]);
				PanelData.panelInteraction("battleResultPanel", "setBattleResultData", 
					[
						{
							score:completeFightObj.score,
							//honnor:tollgateTemplateInfo.honorReward,
							heroExps:completeFightObj.hero,
							dropItems:FightData.getInstance().fightDataObj.dropInfo,//[typeId],
							star:completeFightObj.star
						}, 
						isSuccess, 
						fightResultPanelClosedHandler]);  
				logch("NormalBattle:","BattleResult",completeFightObj);
			}
			
			//---
			TimeTaskManager.getInstance().reset();
			//TickSynchronizer.getInstance().pauseTick();
			GameAGlobalManager.getInstance().onGameEnd();
			_gameFightMainUIView.onGameEnd();
    		TimeManager.instance.destroy();
		}
		
		public function initializeGameSceneMapData(data:MapConfigDataVO, backgroundMap:Sprite):void
		{
			if(_gameState != TowerDefenseGameState.GAME_UNREADY) return;
			
			_gameState = TowerDefenseGameState.GAME_READY;
			
			GameAGlobalManager.getInstance().gameDataInfoManager.initializeMapConfigData(data);
			_groundScene.initializeGameSceneMapData(data, backgroundMap);
		}
		
		public function startGame():void
		{
			this.filters = null;
			if(_gameState != TowerDefenseGameState.GAME_READY) return;
			
			_gameState = TowerDefenseGameState.GAME_RUNNING;

			isLockUIInteracticveByGameState(false);
			//TickSynchronizer.getInstance().resumeTick();
			//TimeTaskManager.getInstance().start();
			TimeManager.instance.stage = GameConst.stage;
			TimeManager.instance.initialize();
			GameAGlobalManager.getInstance().onGameStart();
			
			_gameFightMainUIView.onGameStart();
				
			NewbieGuideManager.getInstance().startCondition( NewbieConst.CONDITION_START_ENTER_BATTLE, {param:[TollgateData.currentLevelId]} );
			/*if(GameVar.isAutoPause)
				GameEvent.getInstance().sendEvent(Battle_CMD_Const.MSG_DEACTIVE_ON_BATTLE,[true]);*/
		}

		public function resume():void
		{
			if(GlobalTemp.bForcePause)
				return;
			
			if(_gameState != TowerDefenseGameState.GAME_PAUSED) return;
			_gameState = TowerDefenseGameState.GAME_RUNNING;
			
			
			
			isLockUIInteracticveByGameState(false);
			
			//TickSynchronizer.getInstance().resumeTick();
			//TimeTaskManager.getInstance().resume();
			TimeManager.instance.start();
			GameAGlobalManager.getInstance().onGameResume();
	
			GameAGlobalManager.getInstance().gamePopupManager.open2CloseGamePauseView(false);

			_gameFightMainUIView.onGameResume();
			
			//SimpleCDTimer.GameResumed();
		}

		public function pause(isAuto:Boolean = false, isShowPauseView:Boolean = true):void
		{
			if(_gameState != TowerDefenseGameState.GAME_RUNNING) return;
			_gameState = TowerDefenseGameState.GAME_PAUSED;
			
			isLockUIInteracticveByGameState(true);

			//TickSynchronizer.getInstance().pauseTick();
			//TimeTaskManager.getInstance().pause();
			TimeManager.instance.stop();
			GameAGlobalManager.getInstance().onGamePause();
			
			if(isShowPauseView)
			{
				GameAGlobalManager.getInstance().gamePopupManager.open2CloseGamePauseView(true);
			}
			
			_gameFightMainUIView.onGamePause();
			
			//SimpleCDTimer.GamePaused();
		}
		
		public function get gameFightMainUIView():GameFightMainUIView
		{
			return _gameFightMainUIView;
		}
		
		//IDisposeObject Interface
		override public function dispose():void
		{
			try
			{
				super.dispose();
				
				while(numChildren > 0) removeChildAt(0);

				_gameFightMainUIView.dispose();
				_gameFightMainUIView = null;
				
				_groundScene.dispose();
				_groundScene = null;
				
				onDisposeManagers();
			}
			catch(error:Error){};
		}

		override protected function onInitialize():void
		{
			TickSynchronizer.getInstance().setStage(this.stage);
			TimeManager.instance.stage = this.stage;
			
			_groundScene = new GroundScene();
			
			_gamePopUpLayer = new Sprite();
			_gamePopUpLayer.mouseEnabled = false;
			_gamePopUpLayerModalShape = new Sprite();
			_gamePopUpLayerModalShape.mouseChildren = false;
			
			_gameMenuLayer = new Sprite();
			_gameMenuLayer.mouseEnabled = false;
			
			_gameFightMainUIView = new GameFightMainUIView();
			
			onInitializeManagers();

			addChild(_groundScene);
			addChild(_gameFightMainUIView);
			
			addChild(_gamePopUpLayerModalShape);
			addChild(_gamePopUpLayer);
			addChild(_gameMenuLayer);
			
			PopupManager.getInstacne().initialize(_gamePopUpLayer, _gamePopUpLayerModalShape);
			
			isLockUIInteracticveByGameState(true);
		}
		
		private function onInitializeManagers():void
		{
			GameAGlobalManager.getInstance().initialize(this.stage, 
				this, 
				_groundScene, 
				_gameMenuLayer);
		}

		private function onDisposeManagers():void
		{
			TickSynchronizer.getInstance().dispose();
			ObjectPoolManager.getInstance().dispose();
			TimeTaskManager.getInstance().dispose();
			
			GameAGlobalManager.getInstance().dispose();
		}
		
		private function isLockUIInteracticveByGameState(isLock:Boolean):void
		{
			/*_gameFightMainUIView.mouseEnabled = */
				_gameFightMainUIView.mouseChildren = 
				_groundScene.mouseEnabled = 
				_groundScene.mouseChildren = !isLock;
		}
		
		private function gamePauseViewClickHandler(event:MouseEvent):void
		{
			resume();
		}
		
		private function fightResultPanelClosedHandler():void
		{
			quitGame();
		}
	}
}