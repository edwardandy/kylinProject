package mainModule.service
{	
	import kylin.echo.edward.utilities.loader.LoaderProgress;
	import kylin.echo.edward.utilities.loader.interfaces.ILoaderProgress;
	
	import mainModule.service.gameDataServices.helpServices.ITollgateService;
	import mainModule.service.gameDataServices.helpServices.TollgateService;
	import mainModule.service.gameDataServices.interfaces.ISheetDataService;
	import mainModule.service.gameDataServices.sheetData.CSVSheetDataService;
	import mainModule.service.loadServices.IconService;
	import mainModule.service.loadServices.LoadAssetsServices;
	import mainModule.service.loadServices.interfaces.IIconService;
	import mainModule.service.loadServices.interfaces.ILoadAssetsServices;
	import mainModule.service.netServices.httpServices.HttpRequestParam;
	import mainModule.service.netServices.httpServices.HttpRequestService;
	import mainModule.service.netServices.httpServices.interfaces.IHttpRequestService;
	import mainModule.service.soundServices.ISoundService;
	import mainModule.service.soundServices.SoundService;
	import mainModule.service.textService.ITextTranslateService;
	import mainModule.service.textService.TextTranslateService;
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
			inject.map(IIconService).toSingleton(IconService);	
			
			inject.map(ISoundService).toSingleton(SoundService);	
			
			inject.map(HttpRequestParam).toType(HttpRequestParam);
			
			inject.map(ITextTranslateService).toSingleton(TextTranslateService);
			
			//帮助类，提供具体的功能
			inject.map(ITollgateService).toSingleton(TollgateService);	
		}
	}
}