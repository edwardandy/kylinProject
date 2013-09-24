package mainModule.controller.gameInitSteps
{
	import flash.events.Event;
	
	import br.com.stimuli.loading.loadingtypes.ImageItem;
	
	import kylin.echo.edward.framwork.controller.KylinCommand;
	import kylin.echo.edward.utilities.loader.interfaces.ILoadMgr;
	
	/**
	 * 加载游戏字体库 
	 * @author Edward
	 * 
	 */	
	public class GameInitLoadFontsCmd extends KylinCommand
	{
		[Inject]
		public var loadMgr:ILoadMgr;
		
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
			var item:ImageItem = loadMgr.addFontItem("FontLibrary");
			if(null == item)
			{
				dispatch(new GameInitStepEvent(GameInitStepEvent.GameInitSetViewLayers));
				directCommandMap.release(this);
				return;
			}
			
			if(item.isLoaded)
			{
				processFontUtil(item);
				return;
			}
			
			item.addEventListener(Event.COMPLETE,onLoadFontCmp);
		}
		
		private function onLoadFontCmp(e:Event):void
		{
			var item:ImageItem = e.currentTarget as ImageItem;
			item.removeEventListener(Event.COMPLETE,onLoadFontCmp);
			processFontUtil(item);
		}
		
		private function processFontUtil(item:ImageItem):void
		{	
			/*var arrNames:Vector.<String> = (item.content as MovieClip).loaderInfo.applicationDomain.getQualifiedDefinitionNames();
			for each(var fontName:String in arrNames)
			{
				var ft1:Font = new(item.getDefinitionByName(fontName) as Class);
				Font.registerFont(item.getDefinitionByName(fontName) as Class);
			}*/
			dispatch(new GameInitStepEvent(GameInitStepEvent.GameInitSetViewLayers));
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