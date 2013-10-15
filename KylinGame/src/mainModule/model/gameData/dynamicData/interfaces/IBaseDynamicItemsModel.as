package mainModule.model.gameData.dynamicData.interfaces
{
	/**
	 * 具有一组动态项的数据，比如一组英雄数据
	 * {dynamicItems=>{180001=>{id=>180001,,,}...},,,} 
	 * @author Edward
	 * 
	 */	
	public interface IBaseDynamicItemsModel
	{
		/**
		 * 通过id移除动态数值项 
		 * @param id
		 * 
		 */		
		function removeItemById(id:uint):void;
	}
}