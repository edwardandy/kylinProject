package mainModule.model.gameData.dynamicData.interfaces
{
	/**
	 * 动态数据类型名与动态数据模型对象的映射关系 管理
	 * @author Edward
	 * 
	 */	
	public interface IDynamicDataDictionaryModel
	{
		/**
		 * 更新动态数据 
		 * @param data
		 * 
		 */		
		function updateModels(data:Object):void;
	}
}