package release.module.kylinFightModule.gameplay
{
	import io.smash.time.TimeManager;
	
	import release.module.kylinFightModule.gameplay.oldcore.core.TickSynchronizer;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.GameMouseCursorFactory;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.mouseCursorReleaseLogices.MagicMouseCursorReleaseLogic;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.mouseCursorReleaseValidators.MouseCursorReleaseValidator;
	import release.module.kylinFightModule.gameplay.oldcore.logic.move.GameFightMoveLogicMgr;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.buffer.GameFightBufferProcessorMgr;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.condition.GameFightSkillConditionMgr;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.process.GameFightSkillProcessorMgr;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.GameFightSkillResultMgr;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.GameFilterManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.TimeTaskManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameFightInfoRecorder;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameFightMouseCursorManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.mouse.MouseCursorManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.MovieClipRasterizationUtil;
	import release.module.kylinFightModule.gameplay.oldcore.utils.SimpleCDTimer;
	import release.module.kylinFightModule.gameplay.oldcore.vo.GlobalTemp;
	import release.module.kylinFightModule.gameplay.oldcore.vo.NewMonsterList;
	
	import robotlegs.bender.framework.api.IInjector;

	/**
	 * 游戏主逻辑规则注入 
	 * @author Edward
	 * 
	 */	
	public final class FightGamePlayStartUp
	{
		public function FightGamePlayStartUp(injector:IInjector)
		{
			injector.map(TimeManager).asSingleton();
			injector.map(TickSynchronizer).asSingleton();
			injector.map(MovieClipRasterizationUtil).asSingleton();
			injector.map(NewMonsterList).asSingleton();
			injector.map(GlobalTemp).asSingleton();
			injector.map(GameFightInfoRecorder).asSingleton();
			injector.map(MouseCursorManager).asSingleton();
			injector.map(GameFightMouseCursorManager).asSingleton();
			injector.map(TimeTaskManager).asSingleton();
			injector.map(ObjectPoolManager).asSingleton();
			injector.map(GameFilterManager).asSingleton();
			injector.map(GameMouseCursorFactory).asSingleton();
			injector.map(MagicMouseCursorReleaseLogic).asSingleton();
			injector.map(MouseCursorReleaseValidator).asSingleton();
			
			injector.map(GameFightSkillResultMgr).asSingleton();
			injector.map(GameFightSkillProcessorMgr).asSingleton();
			injector.map(GameFightSkillConditionMgr).asSingleton();
			injector.map(GameFightBufferProcessorMgr).asSingleton();
			injector.map(GameFightMoveLogicMgr).asSingleton();
			
			injector.map(SimpleCDTimer).toType(SimpleCDTimer);
		}
	}
}