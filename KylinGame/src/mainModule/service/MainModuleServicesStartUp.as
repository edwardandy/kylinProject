package mainModule.service
{	
	import kylin.echo.edward.utilities.loader.LoaderProgress;
	import kylin.echo.edward.utilities.loader.interfaces.ILoaderProgress;
	
	import mainModule.service.gameDataServices.interfaces.ISheetDataService;
	import mainModule.service.gameDataServices.sheetData.CSVSheetDataService;
	import mainModule.service.loadServices.LoadAssetsServices;
	import mainModule.service.loadServices.interfaces.ILoadAssetsServices;
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
			
			inject.map(ILoadAssetsServices).toSingleton(LoadAssetsServices);	
			inject.map(ILoaderProgress).toType(LoaderProgress);
			
			inject.map(HttpRequestParam).toType(HttpRequestParam);
		}
	}
}