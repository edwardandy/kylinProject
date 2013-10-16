package release.module.kylinFightModule.service
{
	import release.module.kylinFightModule.service.fightResPreload.FightResPreloadService;
	import release.module.kylinFightModule.service.fightResPreload.IFightResPreloadService;
	
	import robotlegs.bender.framework.api.IInjector;

	public final class FightModuleServicesStartUp
	{
		public function FightModuleServicesStartUp(injector:IInjector)
		{
			injector.map(IFightResPreloadService).toSingleton(FightResPreloadService);
		}
	}
}