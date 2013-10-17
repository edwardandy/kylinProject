package release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers
{
	import avmplus.getQualifiedClassName;
	
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
	import release.module.kylinFightModule.gameplay.oldcore.display.GroundScene;
	import release.module.kylinFightModule.gameplay.oldcore.display.GroundSceneHelper;
	import release.module.kylinFightModule.gameplay.oldcore.display.TowerDefenseGame;
	import release.module.kylinFightModule.gameplay.oldcore.logic.move.GameFightMoveLogicMgr;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.buffer.GameFightBufferProcessorMgr;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.condition.GameFightSkillConditionMgr;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.process.GameFightSkillProcessorMgr;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.GameFightSkillResultMgr;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.GameFilterManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.TimeTaskManager;
	import release.module.kylinFightModule.gameplay.oldcore.vo.GlobalTemp;
	import release.module.kylinFightModule.gameplay.oldcore.vo.treasureData.TreasureDataList;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.net.getClassByAlias;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	
	import io.smash.time.TimeManager;

	public final class GameAGlobalManager extends BasicGameManager
	{
		private static var _instance:GameAGlobalManager;
		
		public static function getInstance():GameAGlobalManager
		{
			return 	_instance ||= new GameAGlobalManager();
		}

		//Main UI reference
		public var stage:Stage;
		public var game:TowerDefenseGame;
		public var groundScene:GroundScene;
		public var gameMenuLayer:Sprite;
		public var groundSceneHelper:GroundSceneHelper;
		
		//manager reference
		public var gameDataInfoManager:GameFightDataInfoManager;
		public var gameMonsterMarchManager:GameFightMonsterMarchManager;
		public var gameInteractiveManager:GameFightInteractiveManager;
		public var gameSoundManager:GameFightSoundManager;
		public var gamePopupManager:GameFightPopupManager;
		public var gameMouseCursorManager:GameFightMouseCursorManager;
		
		public var gameSuccessAndFailedDetector:GameFightSuccessAndFailedDetector;
		public var gameFightInfoRecorder:GameFightInfoRecorder;
		
		public var gameSkillConditionMgr:GameFightSkillConditionMgr;
		public var gameSkillProcessorMgr:GameFightSkillProcessorMgr;
		public var gameSkillResultMgr:GameFightSkillResultMgr;
		public var gameMoveLogicMgr:GameFightMoveLogicMgr;
		public var gameBufferProcessorMgr:GameFightBufferProcessorMgr;
		
		public var treasureList:TreasureDataList;
		//test by gaojian
		public static var bTest:Boolean = false;
		
		public function GameAGlobalManager()
		{
			super();
		}
		
		override public function initialize(...parameters:Array):void
		{
			this.stage = parameters[0];
			this.game = parameters[1];
			this.groundScene = parameters[2];
			this.gameMenuLayer = parameters[3];
			
			this.groundSceneHelper = new GroundSceneHelper();
			
			gameDataInfoManager = new GameFightDataInfoManager();
			gameDataInfoManager.initialize();
			
			gameMonsterMarchManager = new GameFightMonsterMarchManager();
			gameMonsterMarchManager.initialize();
			
			gameInteractiveManager = new GameFightInteractiveManager();
			gameInteractiveManager.initialize();
			
			gameSoundManager = new GameFightSoundManager();
			gameSoundManager.initialize();

			gamePopupManager = new GameFightPopupManager();
			gamePopupManager.initialize();
			
			gameMouseCursorManager = new GameFightMouseCursorManager();
			gameMouseCursorManager.initialize();
			
			gameSuccessAndFailedDetector = new GameFightSuccessAndFailedDetector();
			gameFightInfoRecorder = new GameFightInfoRecorder();
			
			gameSkillConditionMgr = new GameFightSkillConditionMgr;
			gameSkillConditionMgr.initialize();
			
			gameSkillProcessorMgr = new GameFightSkillProcessorMgr;
			gameSkillProcessorMgr.initialize();
			
			gameSkillResultMgr = new GameFightSkillResultMgr;
			gameSkillResultMgr.initialize();
			
			gameMoveLogicMgr = new GameFightMoveLogicMgr;
			gameMoveLogicMgr.initialize();
			
			gameBufferProcessorMgr = new GameFightBufferProcessorMgr;
			gameBufferProcessorMgr.initialize();
			
			treasureList = new TreasureDataList;
		}
		
		override public function onGameStart():void
		{			
			gameDataInfoManager.onGameStart();
			gameMonsterMarchManager.onGameStart();
			gameInteractiveManager.onGameStart();
			gameSoundManager.onGameStart();
			gamePopupManager.onGameStart();
			gameMouseCursorManager.onGameStart();
			
			gameFightInfoRecorder.initializeFightInfo();
			
			gameSkillConditionMgr.onGameStart();
			gameSkillProcessorMgr.onGameStart();
			gameSkillResultMgr.onGameStart();
			gameMoveLogicMgr.onGameStart();
			gameBufferProcessorMgr.onGameStart();
			groundScene.filters = null;
		}
		
		override public function onGameEnd():void
		{
			gameDataInfoManager.onGameEnd();
			gameMonsterMarchManager.onGameEnd();
			gameInteractiveManager.onGameEnd();
			gameSoundManager.onGameEnd();
			gamePopupManager.onGameEnd();
			gameMouseCursorManager.onGameEnd();
			gameSkillConditionMgr.onGameEnd();
			gameSkillProcessorMgr.onGameEnd();
			gameSkillResultMgr.onGameEnd();
			gameMoveLogicMgr.onGameEnd();
			gameBufferProcessorMgr.onGameEnd();
			//ObjectPoolManager.getInstance().dispose();
		}
		
		override public function onGamePause():void
		{
			//GlobalTemp.useTime = getTimer() - GlobalTemp.tempTime;
			
			gameDataInfoManager.onGamePause();
			gameMonsterMarchManager.onGamePause();
			gameInteractiveManager.onGamePause();
			gameSoundManager.onGamePause();
			gamePopupManager.onGamePause();
			gameMouseCursorManager.onGamePause();
			gameSkillConditionMgr.onGamePause();
			gameSkillProcessorMgr.onGamePause();
			gameSkillResultMgr.onGamePause();
			gameMoveLogicMgr.onGamePause();
			gameBufferProcessorMgr.onGamePause();
		}
		
		override public function onGameResume():void
		{
			//GlobalTemp.tempTime = getTimer();
			
			gameDataInfoManager.onGameResume();
			gameMonsterMarchManager.onGameResume();
			gameInteractiveManager.onGameResume();
			gameSoundManager.onGameResume();
			gamePopupManager.onGameResume();
			gameMouseCursorManager.onGameResume();
			gameSkillConditionMgr.onGameResume();
			gameSkillProcessorMgr.onGameResume();
			gameSkillResultMgr.onGameResume();
			gameMoveLogicMgr.onGameResume();
			gameBufferProcessorMgr.onGameResume();
		}
		
		//IDisposeObject Interface
		override public function dispose():void
		{
			gameDataInfoManager.dispose();
			gameDataInfoManager = null;
			
			gameMonsterMarchManager.dispose();
			gameMonsterMarchManager = null;
			
			gameInteractiveManager.dispose();
			gameInteractiveManager = null;
			
			gameSoundManager.dispose();
			gameSoundManager = null;

			gamePopupManager.dispose();
			gamePopupManager = null;
			
			gameMouseCursorManager.dispose();
			gameMouseCursorManager = null;
			
			gameSuccessAndFailedDetector = null;
			
			gameSkillConditionMgr.dispose();
			gameSkillConditionMgr = null;
			
			gameSkillProcessorMgr.dispose();
			gameSkillProcessorMgr = null;
			
			gameSkillResultMgr.dispose();
			gameSkillResultMgr = null;
			
			gameMoveLogicMgr.dispose();
			gameMoveLogicMgr = null;
			
			gameBufferProcessorMgr.dispose();
			gameBufferProcessorMgr = null;
			
			_instance = null;
			
			this.groundSceneHelper.dispose();
			this.groundSceneHelper = null;
			this.groundScene = null;
			this.gameMenuLayer = null;
			this.game = null;
		}
	}
}