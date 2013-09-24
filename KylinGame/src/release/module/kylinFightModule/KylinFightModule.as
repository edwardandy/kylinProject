package release.module.kylinFightModule
{
	import flash.display.MovieClip;
	import flash.system.ApplicationDomain;
	
	import kylin.echo.edward.framwork.view.KylinBasePanel;
	
	import robotlegs.bender.framework.api.IInjector;
	
	
	[SWF(width="760",height="650",frameRate="30",backgroundColor="0xff0000")] 
	public class KylinFightModule extends KylinBasePanel
	{
		private var _context:KylinFightContext;
		
		[Inject]
		public var moduleParentInjector:IInjector;
		
		public function KylinFightModule()
		{
			super();
		}
		
		[PostConstruct]
		public function init():void
		{
			_context = new KylinFightContext(this,true,moduleParentInjector,ApplicationDomain.currentDomain);
		}
		
		override public function get content():MovieClip
		{
			return this as MovieClip;
		}
		
		override protected function initContent():void
		{
			
		}
	}
}