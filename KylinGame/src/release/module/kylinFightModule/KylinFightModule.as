package release.module.kylinFightModule
{
	import flash.display.MovieClip;
	import flash.net.getClassByAlias;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import kylin.echo.edward.framwork.view.KylinBasePanel;
	
	import release.module.kylinFightModule.configuration.KylinFightConfig;
	
	import robotlegs.bender.bundles.mvcs.MVCSBundle;
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.impl.Context;
	
	
	[SWF(width="760",height="650",frameRate="30",backgroundColor="0xff0000")] 
	public class KylinFightModule extends KylinBasePanel
	{
		private var _context:IContext;
		
		public function KylinFightModule()
		{
			super();
			this.mouseEnabled = false;
			//this.mouseChildren = false;
		}
		
		override public function appear(param:Object=null):void
		{
			super.appear(param);
			_context = new Context()
				.install( MVCSBundle)
				.configure(KylinFightConfig)
				.configure( new ContextView(this) );
		}
		
		override public function disappear(param:Object=null):void
		{
			super.disappear(param);
			_context.destroy(afterContextDestroy);
		}
		
		private function afterContextDestroy():void
		{
			_context = null;
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