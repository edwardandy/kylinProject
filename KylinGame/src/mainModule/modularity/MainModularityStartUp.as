package mainModule.modularity
{
	import mainModule.controller.netCmds.httpCmds.HttpEvent;
	
	import robotlegs.bender.extensions.modularity.api.IModuleConnector;

	/**
	 * 模块间通信设置 
	 * @author Edward
	 * 
	 */	
	public class MainModularityStartUp
	{
		[Inject]
		public var moduleConnector:IModuleConnector;
		
		public function MainModularityStartUp()
		{
		}
		
		[PostConstruct]
		public function onPostConstruct():void
		{
			moduleConnector.onDefaultChannel().relayEvent(HttpEvent.FightRequestData);
		}
	}
}