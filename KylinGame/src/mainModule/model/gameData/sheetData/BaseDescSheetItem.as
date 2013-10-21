package mainModule.model.gameData.sheetData
{
	import kylin.echo.edward.utilities.string.KylinStringUtil;
	
	import mainModule.model.gameData.sheetData.interfaces.IBaseDescSheetItem;
	import mainModule.model.gameData.sheetData.lang.ILangSheetDataModel;
	import mainModule.model.gameData.sheetData.lang.ILangSheetItem;

	/**
	 * 名字和描述信息 
	 * @author Edward
	 * 
	 */	
	public class BaseDescSheetItem extends BaseSheetItem implements IBaseDescSheetItem
	{
		[Inject]
		public var langData:ILangSheetDataModel;
		
		private var _objSound:Object;
		
		public function BaseDescSheetItem()
		{
			super();
		}
		/**
		 * @inheritDoc
		 */		
		public function getName(specialId:uint = 0):String
		{
			var item:ILangSheetItem = langData.getLangSheetById(specialId?specialId:configId);
			if(item)
				return item.name;
			return "";
		}
		/**
		 * @inheritDoc
		 */
		public function getDesc(specialId:uint = 0):String
		{
			var item:ILangSheetItem = langData.getLangSheetById(specialId?specialId:configId);
			if(item)
				return item.desc;
			return "";
		}
		
		public function set sound(s:String):void
		{
			_objSound = KylinStringUtil.parseCommaString(s,";");
		}
		
		public function get objSound():Object
		{
			return _objSound;
		}
	}
}