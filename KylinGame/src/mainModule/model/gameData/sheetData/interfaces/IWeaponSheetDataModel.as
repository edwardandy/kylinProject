package mainModule.model.gameData.sheetData.interfaces
{
	import mainModule.model.gameData.sheetData.weapon.WeaponSheetItem;

	/**
	 * 子弹数值表 
	 * @author Edward
	 * 
	 */	
	public interface IWeaponSheetDataModel
	{
		/**
		 * 通过子弹id获得配置表项数值 
		 * @param id
		 * @return 
		 * 
		 */	
		function getWeaponSheetById(id:uint):WeaponSheetItem
	}
}