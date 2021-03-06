package mainModule.model.gameData.sheetData.interfaces
{
	import mainModule.model.gameData.sheetData.hero.HeroSheetItem;

	/**
	 * 英雄数值表 
	 * @author Edward
	 * 
	 */	
	public interface IHeroSheetDataModel
	{
		/**
		 * 通过英雄id获得配置表项数值 
		 * @param id
		 * @return 
		 * 
		 */		
		function getHeroSheetById(id:uint):HeroSheetItem;
	}
}