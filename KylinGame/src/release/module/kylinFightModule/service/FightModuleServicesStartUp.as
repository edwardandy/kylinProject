package release.module.kylinFightModule.service
{
	import release.module.kylinFightModule.service.fightResPreload.FightResPreloadService;
	import release.module.kylinFightModule.service.fightResPreload.IFightResPreloadService;
	import release.module.kylinFightModule.service.sceneElements.ISceneElementsService;
	import release.module.kylinFightModule.service.sceneElements.SceneElementsService;
	
	import robotlegs.bender.framework.api.IInjector;

	public final class FightModuleServicesStartUp
	{
		public function FightModuleServicesStartUp(injector:IInjector)
		{
			injector.map(IFightResPreloadService).toSingleton(FightResPreloadService);
			injector.map(ISceneElementsService).toSingleton(SceneElementsService);
		}
	}
}