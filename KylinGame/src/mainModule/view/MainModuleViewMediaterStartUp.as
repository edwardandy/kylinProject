package mainModule.view
{
	import kylin.echo.edward.framwork.view.KylinBasePanel;
	
	import mainModule.view.loadPanel.LoadPanel;
	import mainModule.view.loadPanel.LoadPanelMediater;
	
	import robotlegs.bender.extensions.matching.TypeMatcher;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	

	public final class MainModuleViewMediaterStartUp
	{
		public function MainModuleViewMediaterStartUp(mediaterMap:IMediatorMap)
		{
			mediaterMap.mapMatcher(new TypeMatcher().allOf(LoadPanel,KylinBasePanel)).toMediator(LoadPanelMediater);
		}
	}
}