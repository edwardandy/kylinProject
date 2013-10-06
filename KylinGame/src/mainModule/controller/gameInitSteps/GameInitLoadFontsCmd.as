package mainModule.controller.gameInitSteps
{
	import flash.events.Event;
	
	import br.com.stimuli.loading.loadingtypes.ImageItem;
	
	import kylin.echo.edward.framwork.controller.KylinCommand;
	import kylin.echo.edward.utilities.loader.interfaces.IAssetsLoaderListener;
	import kylin.echo.edward.utilities.loader.interfaces.ILoadMgr;
	
	import mainModule.controller.uiCmds.UIPanelEvent;
	import mainModule.model.panelData.PanelNameConst;
	import mainModule.service.loadServices.interfaces.ILoadAssetsServices;
	
	/**
	 * 加载游戏字体库 
	 * @author Edward
	 * 
	 */	
	public class GameInitLoadFontsCmd extends KylinCommand
	{
		[Inject]
		public var loadService:ILoadAssetsServices;
		
		public function GameInitLoadFontsCmd()
		{
			super();
		}
		
		override public function execute():void
		{
			super.execute(); 
			
			loadFonts();
			
			directCommandMap.detain(this);
		}
		
		private function loadFonts():void
		{
			loadService.addFontItem("FontLibrary").addComplete(processFontUtil).addError(processFontUtil);
		}
		
		private function processFontUtil():void
		{	
			/*var arrNames:Vector.<String> = (item.content as MovieClip).loaderInfo.applicationDomain.getQualifiedDefinitionNames();
			for each(var fontName:String in arrNames)
			{
				var ft1:Font = new(item.getDefinitionByName(fontName) as Class);
				Font.registerFont(item.getDefinitionByName(fontName) as Class);
			}*/
			dispatch(new UIPanelEvent(UIPanelEvent.UI_OpenPanel,PanelNameConst.LoadPanel));
			directCommandMap.release(this);
		}
		
		/*[Embed(source="Museo700-Regular.otf", fontName="NormalFont",embedAsCFF="false", mimeType="application/x-font")]
		var NormalFont : Class;
		[Embed(source="Hum531uk.ttf", fontName="ButtonFont",embedAsCFF="false", mimeType="application/x-font")]
		var ButtonFont : Class;
		[Embed(source="SHOWG.TTF", fontName="TitleFont",embedAsCFF="false", mimeType="application/x-font")]
		var TitleFont : Class;
		
		Font.registerFont(NormalFont);
		Font.registerFont(ButtonFont);
		Font.registerFont(TitleFont);*/
	}
}