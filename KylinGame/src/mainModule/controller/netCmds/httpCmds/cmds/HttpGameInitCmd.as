package mainModule.controller.netCmds.httpCmds.cmds
{
	import mainModule.controller.netCmds.httpCmds.HttpCmd;
	import mainModule.model.gameData.sheetData.hero.IHeroSheetDataModel;
	import mainModule.model.gameData.sheetData.hero.IHeroSheetItem;

	/**
	 * 请求游戏初始化的后台数据 
	 * @author Edward
	 * 
	 */	
	public class HttpGameInitCmd extends HttpCmd
	{
		[Inject]
		public var heroSheet:IHeroSheetDataModel;
		
		public function HttpGameInitCmd()
		{
			super();
		}
		
		override protected function request():void
		{
			super.request();
			
			var item:IHeroSheetItem = heroSheet.getHeroSheetById(180001);
			trace(item);
		}
	}
}