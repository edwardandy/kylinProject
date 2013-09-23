package kylin.echo.edward.utilities.loader
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	import kylin.echo.edward.utilities.loader.interfaces.IDomainResMgr;
	
	public final class DomainResMgr implements IDomainResMgr
	{
		//id:domainName
		private var _dicDomainName:Dictionary;
		//domainName:ApplicationDomain
		private var _dicDomain:Dictionary;
		private var _loadMgr:LoadMgr;
		
		public function DomainResMgr(loadMgr:LoadMgr)
		{
			_dicDomainName = new Dictionary(true);
			_dicDomain = new Dictionary(true);
			_loadMgr = loadMgr;
		}
		
		/*public function checkDomainLoaded(loadItem:LoadingItem):void
		{
			if(!loadItem.isSWF())
				return;
			for(var url:String in _dicDomainName)
			{
				if(url != loadItem.url.url)
					continue;
				var content:MovieClip = loadItem.content as MovieClip;
				var domain:String = _dicDomainName[url];
				
				if(domain)
				{
					addDomain(domain, content.loaderInfo.applicationDomain);		
				}
				else
				{
					addDomain("currentDomain", content.loaderInfo.applicationDomain);		
				}
				
			}
		}
		
		private function addDomain(name:String, domain:ApplicationDomain):void	
		{
			if(_dicDomain[name] == null)
			{
				_dicDomain[name] = domain;
			}
		}*/
		
		/**
		 * @inheritDoc
		 */		
		public function addSwfDomainItem(folderKey:String,idKey:String,domainName:String = null,props:Object = null,loaderName:String = "root"):LoadingItem
		{
			if(!folderKey || !idKey)
				return null;
			
			var loadKey:String = _loadMgr.genLoadKey(folderKey,idKey);
			if(!_dicDomainName[loadKey])
			{
				domainName ||= "currentDomain";
				_dicDomainName[loadKey] = domainName;
				var applicationDomain:ApplicationDomain = ("currentDomain" == domainName) ? ApplicationDomain.currentDomain : 
					(_dicDomain[domainName] || (-1 != domainName.indexOf("childDomain") ? new ApplicationDomain(ApplicationDomain.currentDomain) : new ApplicationDomain));
				_dicDomain[domainName] ||= applicationDomain;
				var context:LoaderContext = (props && props["context"] is LoaderContext)? props["context"] as LoaderContext : new LoaderContext();
				context.applicationDomain =  applicationDomain;
				if(!props)
					props = {"context":context};
				else
					props["context"] = context;
			}
			return _loadMgr.addLoadItem(folderKey,idKey,props,loaderName);
		}
		
		private function getClassFromDomain(clsName:String, domainName:String = null):Class{
			if (domainName)	{
				var domain:ApplicationDomain = _dicDomain[domainName];
				if (domain)	{
					if (domain.hasDefinition(clsName))	{
						return domain.getDefinition(clsName) as Class;
					}
					return null;
				}
			}
			for each(var eachDomain:ApplicationDomain in _dicDomain)	{
				if (eachDomain.hasDefinition(clsName))	{
					return eachDomain.getDefinition(clsName) as Class;
				}
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
			var cls:Class = getClassByDomain(key,domainName);
			return (null != cls ? new cls() as MovieClip : null);
		}
		/**
		 * @inheritDoc
		 */	
		public function getSimpleButtonByDomain(key:String,domainName:String = null):SimpleButton
		{
			var cls:Class = getClassByDomain(key,domainName);
			return (null != cls ? new cls() as SimpleButton : null);
		}
		/**
		 * @inheritDoc
		 */	
		public function getSpriteByDomain(key:String,domainName:String = null):Sprite
		{
			var cls:Class = getClassByDomain(key,domainName);
			return (null != cls ? new cls() as Sprite : null);
		}
	}
}