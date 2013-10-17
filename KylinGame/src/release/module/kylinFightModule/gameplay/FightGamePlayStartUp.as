package release.module.kylinFightModule.gameplay
{
	import io.smash.time.TimeManager;
	
	import release.module.kylinFightModule.gameplay.oldcore.core.TickSynchronizer;
	
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
		}
	}
}