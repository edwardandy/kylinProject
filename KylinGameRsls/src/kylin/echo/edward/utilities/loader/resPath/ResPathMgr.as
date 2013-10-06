package kylin.echo.edward.utilities.loader.resPath
{	
	/**
	 * 资源路径生成管理器 
	 * @author Edward
	 * 
	 */	
	public final class ResPathMgr
	{
		private var _param:ResPathParam;
		
		public function ResPathMgr(value:ResPathParam)
		{
			_param = value;
		}
		/**
		 * 通过目录键和id生成资源实际路径 
		 * @param folderKey 目录键名
		 * @param id 资源id
		 * @return 资源实际url路径
		 * 
		 */		
		public function genResUrl(folderKey:String,id:String):ResPathVO
		{
			var folderXml:XML = _param.resCfg.child(folderKey)[0];
			var folder:String = folderXml.@folder;
			var items:XMLList = folderXml.item;
			var allLanVerItem:XML;
			for each(var item:XML in items)
			{
				if(item.@id.toLowerCase() == (id+"_"+_param.curLan).toLowerCase())
				{
					return getResult(folder,item);
				}
				else if(item.@id.toLowerCase() == id.toLowerCase())
					allLanVerItem = item;
			}
			
			if(allLanVerItem)
				return getResult(folder,allLanVerItem);
			return null;
		}
		
		private function getResult(folder:String,item:XML):ResPathVO
		{
			var res:ResPathVO = new ResPathVO;
			res.url = _param.rootPath + folder + item;
			res.size = uint(item.@size);
			return res;
		}
	}
}