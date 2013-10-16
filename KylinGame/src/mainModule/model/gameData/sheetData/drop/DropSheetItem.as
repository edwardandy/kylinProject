package mainModule.model.gameData.sheetData.drop
{
	import flash.utils.Dictionary;
	
	import mainModule.model.gameData.sheetData.BaseSheetItem;

	/**
	 * 掉落数值项 
	 * @author Edward
	 * 
	 */	
	public class DropSheetItem extends BaseSheetItem implements IDropSheetItem
	{
		private var _dicDropItems:Dictionary = new Dictionary;
		/**
		 * 设置掉落道具 
		 * @param value itemId:num;itemId:num;...
		 * 
		 */		
		public function set dropItems(value:String):void
		{
			_dicDropItems = new Dictionary;
			if(!value)
				return;
			for each(var drops:String in value.split(";"))
			{
				var arrDrop:Array = drops.split(":");
				_dicDropItems[uint(arrDrop[0])] = arrDrop.length>1?int(arrDrop[1]):1;
			}
		}
		/**
		 * 掉落道具 
		 * @return itemId:num;itemId:num;...
		 * 
		 */		
		public function get dicDropItems():Dictionary
		{
			return _dicDropItems;
		}
		
		public function DropSheetItem()
		{
			super();
		}
	}
}