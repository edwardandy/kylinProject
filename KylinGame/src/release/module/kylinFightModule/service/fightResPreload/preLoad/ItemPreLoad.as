package release.module.kylinFightModule.service.fightResPreload.preLoad
{
	import kylin.echo.edward.utilities.string.KylinStringUtil;
	
	import mainModule.model.gameData.sheetData.item.IItemSheetDataModel;
	import mainModule.model.gameData.sheetData.item.IItemSheetItem;
	
	import release.module.kylinFightModule.service.fightResPreload.FightResPreloadService;
	
	public class ItemPreLoad extends BasicPreLoad
	{
		[Inject]
		public var itemModel:IItemSheetDataModel;
		
		public function ItemPreLoad(mgr:FightResPreloadService)
		{
			super(mgr);
		}
		
		override public function checkCurLoadRes(id:uint):void
		{
			var itemTemp:IItemSheetItem = itemModel.getItemSheetById(id);
			if(!itemTemp)
				return;
			
			if(1 == itemTemp.effectType)
			{
				var param:Object = KylinStringUtil.parseCommaString(itemTemp.effectValue);
				if(param && param.hasOwnProperty("magic"))
					preloadMagicRes(param.magic);
			}
		}
	}
}