package mainModule.model.preLoadData
{
	import kylin.echo.edward.framwork.model.KylinActor;
	
	import mainModule.model.preLoadData.interfaces.IPreLoadCfgModel;

	/**
	 * 游戏预加载资源配置 
	 * @author Edward
	 * 
	 */	
	public class PreLoadCfgModel extends KylinActor implements IPreLoadCfgModel
	{
		private var _cfg:XML;
		
		private var _vecFirstLoadRes:Vector.<PreLoadCfgVo>;
		private var _vecBackgroundLoadRes:Vector.<PreLoadCfgVo>;
		
		public function PreLoadCfgModel()
		{
			super();
		}
		
		public function initData(cfg:XML):void
		{
			_cfg = cfg;
			_vecFirstLoadRes ||= new Vector.<PreLoadCfgVo>;
			_vecBackgroundLoadRes ||= new Vector.<PreLoadCfgVo>;
			
			var vo:PreLoadCfgVo;
			for each(var item:XML in _cfg.res as XMLList)
			{
				vo = new PreLoadCfgVo;
				vo.id = item.@id;
				vo.folder = item.@folder;
				vo.bIsFirstLoad = (1 == int(item.@isFirst));
				vo.iPriority = item.@priority;
				
				if(vo.bIsFirstLoad)
					_vecFirstLoadRes.push(vo);
				else
					_vecBackgroundLoadRes.push(vo);
			}
		}
		
		public function get firstLoadRes():Vector.<PreLoadCfgVo>
		{
			return _vecFirstLoadRes;
		}
		
		public function get backgroundLoadRes():Vector.<PreLoadCfgVo>
		{
			return _vecBackgroundLoadRes;
		}
	}
}