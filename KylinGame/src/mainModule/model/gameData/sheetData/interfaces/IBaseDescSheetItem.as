package mainModule.model.gameData.sheetData.interfaces
{
	/**
	 * 名字和描述信息 
	 * @author Edward
	 * 
	 */	
	public interface IBaseDescSheetItem extends IBaseSheetItem
	{
		/**
		 * 获取名字 
		 * @param specialId
		 * @return 
		 * 
		 */		
		function getName(specialId:uint = 0):String;
		/**
		 * 获取描述 
		 * @param specialId
		 * @return 
		 * 
		 */		
		function getDesc(specialId:uint = 0):String;
		/**
		 * 声音id对象，不同的属性对应不同的用途 use,upgrade,attack,chant,special,nearAtk,farAtk,dead 
		 * @return 
		 * 
		 */		
		function get objSound():Object;
	}
}