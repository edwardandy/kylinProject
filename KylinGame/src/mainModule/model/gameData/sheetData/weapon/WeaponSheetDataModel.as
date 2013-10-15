package mainModule.model.gameData.sheetData.weapon
{
	import mainModule.model.gameData.sheetData.BaseSheetDataModel;

	/**
	 * 子弹数值表 
	 * @author Edward
	 * 
	 */	
	public class WeaponSheetDataModel extends BaseSheetDataModel implements IWeaponSheetDataModel
	{
		public function WeaponSheetDataModel()
		{
			super();
			sheetName = "weaponSheetData";
			sheetClass = WeaponSheetItem;
		}
		
		public function getWeaponSheetById(id:uint):WeaponSheetItem
		{
			return genSheetElement(id) as WeaponSheetItem;
		}
	}
}