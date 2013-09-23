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
	
	import org.robotlegs.core.IInjector;
	
	import utili.behavior.declare.DeclareBehavior;

	public final class MainModuleServicesStartUp
	{
		public function MainModuleServicesStartUp(inject:IInjector)
		{
			inject.mapSingleton(DeclareBehavior);
			inject.mapSingletonOf(IUIPanelService,UIPanelService);
			inject.mapSingletonOf(IUIPanelBehaviorService,UIPanelBehaviorService);
			inject.mapSingletonOf(IHttpRequestService,HttpRequestService);
			inject.mapSingletonOf(ISheetDataService,CSVSheetDataService);
			
			inject.mapClass(HttpRequestParam,HttpRequestParam);
		}
	}
}