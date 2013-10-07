package kylin.echo.edward.utilities.loader
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
		
	import kylin.echo.edward.utilities.loader.interfaces.IDomainResMgr;
	/**
	 *  SWF域加载管理器
	 * @author Edward
	 * 
	 */	
	public final class DomainResMgr implements IDomainResMgr
	{
		/**
		 *  loadKey => domainName
		 */		
		private var _dicDomainName:Dictionary;
		/**
		 *  domainName => ApplicationDomain
		 */		
		private var _dicDomain:Dictionary;
		private var _loadMgr:LoadMgr;
		
		public function DomainResMgr(loadMgr:LoadMgr)
		{
			_dicDomainName = new Dictionary(true);
			_dicDomain = new Dictionary(true);
			_loadMgr = loadMgr;
		}
		
		/**
		 * 添加SWF域加载项 
		 * @param folderKey 资源配置目录键名
		 * @param idKey 资源配置id
		 * @param domainName 资源加载到的域名称
		 * @param props 加载时传递给bulkloader的加载参数
		 * @return props参数
		 * 
		 */			
		internal function addDomainItem(folderKey:String,idKey:String,domainName:String,props:Object = null):Object
		{
			if(!folderKey || !idKey || !domainName)
				return props;
			
			const loadKey:String = _loadMgr.genLoadKey(folderKey,idKey);
			if(!_dicDomainName[loadKey])
			{
				_dicDomainName[loadKey] = domainName;
				const applicationDomain:ApplicationDomain = ("currentDomain" == domainName) ? ApplicationDomain.currentDomain : 
					(_dicDomain[domainName] || (-1 != domainName.indexOf("childDomain") ? new ApplicationDomain(ApplicationDomain.currentDomain) : new ApplicationDomain));
				_dicDomain[domainName] ||= applicationDomain;
				const context:LoaderContext = (props && props["context"] is LoaderContext)? props["context"] as LoaderContext : new LoaderContext();
				context.applicationDomain =  applicationDomain;
				if(!props)
					props = {"context":context};
				else
					props["context"] = context;
			}
			return props;
		}
		
		private function getClassFromDomain(clsName:String, domainName:String = null):Class
		{
			if (domainName)	
			{
				const domain:ApplicationDomain = _dicDomain[domainName];
				if (domain)	
				{
					if (domain.hasDefinition(clsName))	
						return domain.getDefinition(clsName) as Class;
					return null;
				}
			}
			
			for each(var eachDomain:ApplicationDomain in _dicDomain)	
			{
				if (eachDomain.hasDefinition(clsName))	
					return eachDomain.getDefinition(clsName) as Class;
			}
			return null;
		}	
		/**
		 * @inheritDoc
		 */	
		public function getClassByDomain(key:String,domainName:String = null):Class 
		{
			return getClassFromDomain(key,domainName);
		}
		/**
		 * @inheritDoc
		 */	
		public function getMovieClipByDomain(key:String,domainName:String = null):MovieClip
		{
			const cls:Class = getClassByDomain(key,domainName);
			return (null != cls ? new cls() as MovieClip : null);
		}
		/**
		 * @inheritDoc
		 */	
		public function getSimpleButtonByDomain(key:String,domainName:String = null):SimpleButton
		{
			const cls:Class = getClassByDomain(key,domainName);
			return (null != cls ? new cls() as SimpleButton : null);
		}
		/**
		 * @inheritDoc
		 */	
		public function getSpriteByDomain(key:String,domainName:String = null):Sprite
		{
			const cls:Class = getClassByDomain(key,domainName);
			return (null != cls ? new cls() as Sprite : null);
		}
	}
}