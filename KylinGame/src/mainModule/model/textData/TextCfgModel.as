package mainModule.model.textData
{
	import flash.utils.Dictionary;
		
	import mainModule.model.textData.interfaces.ITextCfgModel;
	
	public class TextCfgModel implements ITextCfgModel
	{
		private var _dicTextCfg:Dictionary;
		
		public function TextCfgModel()
		{
			super();
			init();
		}
		
		private function init():void
		{
			_dicTextCfg = new Dictionary;
		}
		
		public function addTextCfg(id:String,cfg:XML):void
		{
			_dicTextCfg[id] = cfg;
		}
		
		public function getTextCfg(id:String):XML
		{
			return _dicTextCfg[id];
		}
	}
}