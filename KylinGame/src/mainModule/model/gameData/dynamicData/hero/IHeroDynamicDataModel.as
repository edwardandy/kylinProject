package mainModule.model.gameData.dynamicData.hero
{
	import mainModule.model.gameData.dynamicData.interfaces.IBaseDynamicItemsModel;

	/**
	 * 英雄动态数据 
	 * @author Edward
	 */
	public interface IHeroDynamicDataModel extends IBaseDynamicItemsModel
	{
		/**
		 * 通过英雄id获得英雄动态数据 
		 * @param id
		 * @return 
		 * 
		 */		
		function getHeroDataById(id:uint):IHeroDynamicItem;
		/**
		 * 获得所有英雄动态项 
		 * @return 
		 * 
		 */		
		function getAllHeroData():Vector.<IHeroDynamicItem>;
		/**
		 * 带入到战斗中的英雄id 
		 */
		function get arrHeroIdsInFight():Array;
	}
}