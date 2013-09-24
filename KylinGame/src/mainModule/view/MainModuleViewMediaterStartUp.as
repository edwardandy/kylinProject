package mainModule.view
{
	import mainModule.view.loadPanel.LoadPanel;
	import mainModule.view.loadPanel.LoadPanelMediater;
	
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	

	public final class MainModuleViewMediaterStartUp
	{
		public function MainModuleViewMediaterStartUp(mediaterMap:IMediatorMap)
		{
			mediaterMap.mapView(LoadPanel,LoadPanelMediater);
		}
	}
}