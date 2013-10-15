package mainModule.model.gameData.sheetData.groundEff
{
	/**
	 * 地表特效配置表数据 
	 * @author Edward
	 * 
	 */	
	public interface IGroundEffSheetDataModel
	{
		/**
		 * 通过id获得地表特效数值表项 
		 * @param id
		 * @return 
		 * 
		 */		
		function getGroundEffSheetById(id:uint):IGroundEffSheetItem;
	}
}