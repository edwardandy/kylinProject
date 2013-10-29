package release.module.kylinFightModule.modularity
{
	import mainModule.controller.netCmds.httpCmds.HttpEvent;
	import mainModule.controller.uiCmds.UIPanelEvent;
	
	import robotlegs.bender.extensions.modularity.api.IModuleConnector;

	/**
	 * 模块间通信设置 
	 * @author Edward
	 * 
	 */
	public final class FightModularityStartUp
	{
		[Inject]
		public var moduleConnector:IModuleConnector;
		
		public function FightModularityStartUp()
		{
		}
		
		[PostConstruct]
		public function onPostConstruct():void
		{
			moduleConnector.onDefaultChannel().receiveEvent(HttpEvent.FightRequestData);
			moduleConnector.onDefaultChannel().relayEvent(UIPanelEvent.UI_OpenPanel);
			moduleConnector.onDefaultChannel().relayEvent(UIPanelEvent.UI_ClosePanel);
		}
	}
}