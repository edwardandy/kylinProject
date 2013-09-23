package release.module.kylinFightModule.gameplay.main
{
	import kylin.echo.edward.gameplay.KylinGameGroup;
	
	import org.robotlegs.core.IInjector;

	/**
	 * 战斗主场景 
	 * @author Edward
	 * 
	 */	
	public class MainFightScene extends KylinGameGroup
	{
		[Inject]
		public var injector:IInjector;
		
		public function MainFightScene(_name:String=null)
		{
			super(_name);
		}
		
		[PostConstruct]
		override public function initialize():void
		{
			super.initialize();
			injector.injectInto(new PreRegisterManager(this));
		}
	}
}