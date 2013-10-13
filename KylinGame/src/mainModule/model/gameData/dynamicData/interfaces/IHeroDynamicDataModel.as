package mainModule.model.gameData.dynamicData.interfaces
{
	import mainModule.model.gameData.dynamicData.hero.HeroDynamicItem;

	/**
	 * 英雄动态数据 
	 * @author Edward
	 */
	public interface IHeroDynamicDataModel
	{
		/**
		 * 通过英雄id获得英雄动态数据 
		 * @param id
		 * @return 
		 * 
		 */		
		function getHeroDataById(id:uint):HeroDynamicItem;
		/**
		 * 获得所有英雄动态项 
		 * @return 
		 * 
		 */		
		function getAllHeroData():Vector.<HeroDynamicItem>;
	}
}