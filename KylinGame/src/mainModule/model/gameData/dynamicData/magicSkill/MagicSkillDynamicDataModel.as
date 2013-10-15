package mainModule.model.gameData.dynamicData.magicSkill
{
	import mainModule.controller.gameData.GameDataUpdateEvent;
	import mainModule.model.gameData.dynamicData.BaseDynamicItemsModel;
	import mainModule.model.gameData.dynamicData.DynamicDataNameConst;

	/**
	 * 魔法动态数据 
	 * @author Edward
	 * 
	 */	
	public class MagicSkillDynamicDataModel extends BaseDynamicItemsModel implements IMagicSkillDynamicDataModel
	{
		public function MagicSkillDynamicDataModel()
		{
			super();
			dataId = DynamicDataNameConst.MagicSkillData;
			updateEventType = GameDataUpdateEvent.GameDataUpdate_MagicSkillData;
			itemClazz = MagicSkillDynamicItem;
		}
		/**
		 * @inheritDoc
		 */		
		public function getMagicDataById(id:uint):IMagicSkillDynamicItem
		{
			return getItemById(id) as IMagicSkillDynamicItem;
		}
		/**
		 * @inheritDoc
		 */
		public function getAllMagicData():Vector.<IMagicSkillDynamicItem>
		{
			return Vector.<IMagicSkillDynamicItem>(getAllItems());
		}
	}
}