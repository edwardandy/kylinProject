package release.module.kylinFightModule.model.state
{
	import release.module.kylinFightModule.gameplay.oldcore.core.IFightLifecycle;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain.GameFightMainUIView;
	import release.module.kylinFightModule.gameplay.oldcore.logic.move.GameFightMoveLogicMgr;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.buffer.GameFightBufferProcessorMgr;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.condition.GameFightSkillConditionMgr;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.process.GameFightSkillProcessorMgr;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.GameFightSkillResultMgr;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.TimeTaskManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameFightInfoRecorder;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameFightInteractiveManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameFightMonsterMarchManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameFightMouseCursorManager;
	import release.module.kylinFightModule.gameplay.oldcore.vo.GlobalTemp;
	import release.module.kylinFightModule.gameplay.oldcore.vo.NewMonsterList;
	import release.module.kylinFightModule.model.interfaces.IMonsterWaveModel;
	import release.module.kylinFightModule.model.interfaces.ISceneDataModel;
	import release.module.kylinFightModule.model.sceneElements.ISceneElementsModel;
	import release.module.kylinFightModule.service.sceneElements.ISceneElementsService;

	/**
	 * 战斗生命周期管理器 
	 * @author Edward
	 * 
	 */	
	public class FightLifecycleGroup implements IFightLifecycleGroup
	{
		[Inject]
		public var newMonsterList:NewMonsterList;
		[Inject]
		public var globalTemp:GlobalTemp;
		[Inject]
		public var recorder:GameFightInfoRecorder;
		[Inject]
		public var mouseMgr:GameFightMouseCursorManager;
		[Inject]
		public var interactiveMgr:GameFightInteractiveManager;
		[Inject]
		public var monsterMarchMgr:GameFightMonsterMarchManager;
		[Inject]
		public var monsterWaveModel:IMonsterWaveModel;
		[Inject]
		public var timeTaskMgr:TimeTaskManager;
		[Inject]
		public var objPoolMgr:ObjectPoolManager;
		[Inject]
		public var sceneModel:ISceneDataModel;
		[Inject]
		public var sceneElementsModel:ISceneElementsModel;
		[Inject]
		public var sceneElementsService:ISceneElementsService;
		[Inject]
		public var mainUIView:GameFightMainUIView;
		[Inject]
		public var skillResultMgr:GameFightSkillResultMgr;
		[Inject]
		public var skillProcessorMgr:GameFightSkillProcessorMgr;
		[Inject]
		public var skillConditionMgr:GameFightSkillConditionMgr;
		[Inject]
		public var buffProcessorMgr:GameFightBufferProcessorMgr;
		[Inject]
		public var moveLogicMgr:GameFightMoveLogicMgr;
		
		private var _vecLifecycles:Vector.<IFightLifecycle> = new Vector.<IFightLifecycle>;
		
		public function FightLifecycleGroup()
		{
			
		}
		
		[PostConstruct]
		public function registerGroup():void
		{
			addLifecycle(newMonsterList);
			addLifecycle(globalTemp);
			addLifecycle(recorder);
			addLifecycle(mouseMgr);
			addLifecycle(interactiveMgr);
			addLifecycle(monsterWaveModel);
			addLifecycle(monsterMarchMgr);
			addLifecycle(timeTaskMgr);
			addLifecycle(objPoolMgr);
			addLifecycle(sceneModel);
			addLifecycle(sceneElementsModel);
			addLifecycle(sceneElementsService);
			addLifecycle(mainUIView);
			addLifecycle(skillResultMgr);
			addLifecycle(skillProcessorMgr);
			addLifecycle(skillConditionMgr);
			addLifecycle(buffProcessorMgr);
			addLifecycle(moveLogicMgr);
		}
		
		private function addLifecycle(lifecycle:IFightLifecycle):void
		{
			if(lifecycle && -1 == _vecLifecycles.indexOf(lifecycle))
				_vecLifecycles.push(lifecycle);
		}
		
		public function onFightStart():void
		{
			for each(var fightMgr:IFightLifecycle in _vecLifecycles)
			{
				fightMgr.onFightStart();
			}
		}
		
		public function onFightEnd():void
		{
			for each(var fightMgr:IFightLifecycle in _vecLifecycles.reverse())
			{
				fightMgr.onFightEnd();
			}
		}
		
		public function onFightPause():void
		{
			for each(var fightMgr:IFightLifecycle in _vecLifecycles)
			{
				fightMgr.onFightPause();
			}
		}
		
		public function onFightResume():void
		{
			for each(var fightMgr:IFightLifecycle in _vecLifecycles)
			{
				fightMgr.onFightResume();
			}
		}
		
		public function dispose():void
		{
			for each(var fightMgr:IFightLifecycle in _vecLifecycles.reverse())
			{
				fightMgr.dispose();
			}
			_vecLifecycles = null;
		}
	}
}