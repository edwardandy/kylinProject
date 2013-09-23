package kylin.echo.edward.framwork
{
	import flash.display.DisplayObjectContainer;
	import flash.system.ApplicationDomain;
	
	import org.robotlegs.core.IInjector;
	import org.robotlegs.utilities.modular.core.IModule;
	import org.robotlegs.utilities.modular.mvcs.ModuleContext;
	
	public class KylinContext extends ModuleContext
	{
		public function KylinContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true, parentInjector:IInjector = null, applicationDomain:ApplicationDomain = null)
		{
			super(contextView,autoStartup,parentInjector,applicationDomain);
			IModule;
		}
	}
}