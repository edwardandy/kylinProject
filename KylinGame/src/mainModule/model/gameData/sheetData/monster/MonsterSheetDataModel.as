package mainModule.model.gameData.sheetData.monster
{
	import mainModule.model.gameData.sheetData.BaseSheetDataModel;

	/**
	 * 怪物数值表 
	 * @author Edward
	 * 
	 */	
	public class MonsterSheetDataModel extends BaseSheetDataModel implements IMonsterSheetDataModel
	{
		public function MonsterSheetDataModel()
		{
			super();
			sheetName = "monsterSheetData";
			sheetClass = MonsterSheetItem;
		}
		
		public function getMonsterSheetById(id:uint):IMonsterSheetItem
		{
			return genSheetElement(id) as IMonsterSheetItem;
		}
	}
}