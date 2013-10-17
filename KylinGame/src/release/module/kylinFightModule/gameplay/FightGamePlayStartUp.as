package release.module.kylinFightModule.gameplay
{
	import io.smash.time.TimeManager;
	
	import release.module.kylinFightModule.gameplay.oldcore.core.TickSynchronizer;
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
			
			injector.map(SimpleCDTimer).toType(SimpleCDTimer);
		}
	}
}