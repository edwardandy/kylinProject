package mainModule.service.gameDataServices.interfaces
{
	/**
	 * 配置表解析方式 
	 * @author Edward
	 * 
	 */	
	public interface ISheetDataService
	{
		/**
		 * 解析数据表项为一个对象 
		 * @param id 表项的唯一标识id
		 * @param sheetName 数据表名
		 * @param sheetClass 数据表项对应的类
		 * @return id对应数据表项类的一个实例
		 * 
		 */		
		function genSheetElement(id:uint,sheetName:String,sheetClass:Class):Object;
	}
}