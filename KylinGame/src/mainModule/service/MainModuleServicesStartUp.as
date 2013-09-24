package mainModule.service
{	
	import mainModule.service.gameDataServices.interfaces.ISheetDataService;
	import mainModule.service.gameDataServices.sheetData.CSVSheetDataService;
	import mainModule.service.netServices.httpServices.HttpRequestParam;
	import mainModule.service.netServices.httpServices.HttpRequestService;
	import mainModule.service.netServices.httpServices.interfaces.IHttpRequestService;
	import mainModule.service.uiServices.UIPanelBehaviorService;
	import mainModule.service.uiServices.UIPanelService;
	import mainModule.service.uiServices.interfaces.IUIPanelBehaviorService;
	import mainModule.service.uiServices.interfaces.IUIPanelService;
	
	import robotlegs.bender.framework.api.IInjector;
	
	import utili.behavior.declare.DeclareBehavior;

	public final class MainModuleServicesStartUp
	{
		public function MainModuleServicesStartUp(inject:IInjector)
		{
			inject.map(DeclareBehavior).asSingleton();
			inject.map(IUIPanelService).toSingleton(UIPanelService);
			inject.map(IUIPanelBehaviorService).toSingleton(UIPanelBehaviorService);
			inject.map(IHttpRequestService).toSingleton(HttpRequestService);
			inject.map(ISheetDataService).toSingleton(CSVSheetDataService);
			
			inject.map(HttpRequestParam).toType(HttpRequestParam);
		}
	}
}