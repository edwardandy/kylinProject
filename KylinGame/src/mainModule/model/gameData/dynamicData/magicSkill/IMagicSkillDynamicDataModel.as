package mainModule.model.gameData.dynamicData.magicSkill
{
	import mainModule.model.gameData.dynamicData.interfaces.IBaseDynamicItemsModel;

	/**
	 * 魔法动态数据 
	 * @author Edward
	 * 
	 */	
	public interface IMagicSkillDynamicDataModel extends IBaseDynamicItemsModel
	{
		/**
		 * 通过魔法模板id获得魔法动态数据项 
		 * @param id 魔法模板id
		 * @return 
		 * 
		 */		
		function getMagicDataById(id:uint):IMagicSkillDynamicItem;
		/**
		 * 获得所有魔法模板数据项 
		 * @return 
		 * 
		 */		
		function getAllMagicData():Vector.<IMagicSkillDynamicItem>;
	}
}