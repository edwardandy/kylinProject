package mainModule.model.gameData.sheetData.hero
{
	import mainModule.model.gameData.sheetData.BaseSheetDataModel;
	import mainModule.model.gameData.sheetData.interfaces.IHeroSheetDataModel;

	/**
	 * 英雄数值表 
	 * @author Edward
	 * 
	 */	
	public class HeroSheetDataModel extends BaseSheetDataModel implements IHeroSheetDataModel
	{	
		public function HeroSheetDataModel()
		{
			super();
			sheetName = "heroSheetData";
			sheetClass = HeroSheetItem;
		}
		
		public function getHeroSheetById(id:uint):HeroSheetItem
		{
			return genSheetElement(id) as HeroSheetItem;
		}
	}
}