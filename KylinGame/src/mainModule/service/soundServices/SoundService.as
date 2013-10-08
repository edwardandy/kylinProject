package mainModule.service.soundServices
{
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	
	import kylin.echo.edward.utilities.loader.AssetInfo;
	
	import mainModule.service.loadServices.interfaces.ILoadAssetsServices;
	
	import treefortress.sound.SoundAS;
	import treefortress.sound.SoundInstance;
	import treefortress.sound.SoundManager;

	public class SoundService
	{
		[Inject]
		public var loadService:ILoadAssetsServices;
		
		private var _rootMgr:SoundManager;
		private var _dicGroupPaused:Dictionary;
		private var _pauseAll:Boolean;
		
		public function SoundService()
		{
			_rootMgr = SoundAS;
			_dicGroupPaused = new Dictionary;
		}
		/**
		 * @inheritDoc
		 */	
		public function play(id:String, group:String, loops:int = 0, allowMultiple:Boolean = false , allowInterrupt:Boolean = true
							 ,enableSeamlessLoops:Boolean = false, loadCmpCB:Function=null,volume:Number = 1, startTime:Number = 0):void
		{
			if(null == _dicGroupPaused[group] || undefined == _dicGroupPaused[group])
				_dicGroupPaused[group] = false;
			if(_pauseAll)
				_dicGroupPaused[group] = true;
			
			const si:SoundInstance = _rootMgr.getSound(id);
			if(!si)
			{
				loadService.addSoundItem(id)
					.addComplete(function(info:AssetInfo):void{
						_rootMgr.group(group).addSound(id,info.content as Sound);
						_rootMgr.play(id,1,0,loops,allowMultiple,allowInterrupt,enableSeamlessLoops);
					if(_pauseAll || false === _dicGroupPaused[group])
						_rootMgr.pause(id);
					if(null != loadCmpCB)
						loadCmpCB.apply();
					});
				return;
			}
			_rootMgr.play(id,1,0,loops,allowMultiple,allowInterrupt,enableSeamlessLoops);
			if(_pauseAll || false === _dicGroupPaused[group])
				_rootMgr.pause(id);
			if(null != loadCmpCB)
				loadCmpCB.apply();
		}
		/**
		 * @inheritDoc
		 */	
		public function stopAll(group:String = ""):void 
		{
			(group?_rootMgr.group(group):_rootMgr).stopAll();
		}
		/**
		 * @inheritDoc
		 */	
		public function resume(id:String):SoundInstance 
		{
			return _rootMgr.resume(id);
		}
		/**
		 * @inheritDoc
		 */	
		public function resumeAll(group:String = ""):void 
		{
			if(_pauseAll && group)
				return;
			if(group)
			{
				_dicGroupPaused[group]=false;
				_rootMgr.group(group).resumeAll();
			}
			else
			{
				_pauseAll=false;
				for(var key:String in _dicGroupPaused)
					_dicGroupPaused[key] = false;
				_rootMgr.resumeAll();
			}
		}
		/**
		 * @inheritDoc
		 */	
		public function pause(id:String):SoundInstance 
		{
			return _rootMgr.pause(id);
		}
		/**
		 * @inheritDoc
		 */	
		public function pauseAll(group:String = ""):void 
		{
			if(_pauseAll && group)
				return;
			if(group)
			{
				_dicGroupPaused[group]=true;
				_rootMgr.group(group).pauseAll();
			}
			else
			{
				_pauseAll=true;
				for(var key:String in _dicGroupPaused)
					_dicGroupPaused[key] = true;
				_rootMgr.pauseAll();
			}
		}
		/**
		 * @inheritDoc
		 */	
		public function fadeTo(type:String, endVolume:Number = 1, duration:Number = 1000, stopAtZero:Boolean = true):SoundInstance 
		{
			return _rootMgr.fadeTo(type,endVolume,duration,stopAtZero);
		}
		/**
		 * @inheritDoc
		 */	
		public function fadeAllTo(group:String = "", endVolume:Number = 1, duration:Number = 1000, stopAtZero:Boolean = true):void 
		{
			(group?_rootMgr.group(group):_rootMgr).fadeAllTo(endVolume,duration,stopAtZero);
		}
		/**
		 * @inheritDoc
		 */	
		public function fadeFrom(type:String, startVolume:Number = 0, endVolume:Number = 1, duration:Number = 1000, stopAtZero:Boolean = true):SoundInstance 
		{
			return _rootMgr.fadeFrom(type,startVolume, endVolume, duration, stopAtZero);
		}
		/**
		 * @inheritDoc
		 */	
		public function fadeAllFrom(group:String = "",startVolume:Number = 0, endVolume:Number = 1, duration:Number = 1000, stopAtZero:Boolean = true):void 
		{
			(group?_rootMgr.group(group):_rootMgr).fadeAllFrom(startVolume,endVolume,duration,stopAtZero);
		}
		/**
		 * @inheritDoc
		 */	
		public function fadeMasterTo(endVolume:Number = 1, duration:Number = 1000, stopAtZero:Boolean = true):void 
		{
			_rootMgr.fadeMasterTo(endVolume, duration, stopAtZero);
		}
		/**
		 * @inheritDoc
		 */	
		public function fadeMasterFrom(startVolume:Number = 0, endVolume:Number = 1, duration:Number = 1000, stopAtZero:Boolean = true):void 
		{
			_rootMgr.fadeMasterFrom(startVolume, endVolume, duration, stopAtZero);
		}
		/**
		 * @inheritDoc
		 */	
		public function getMute(group:String):Boolean 
		{ 
			return (group?_rootMgr.group(group):_rootMgr).mute; 
		}
		/**
		 * @inheritDoc
		 */	
		public function setMute(value:Boolean,group:String=""):void 
		{
			(group?_rootMgr.group(group):_rootMgr).mute = value;
		}
		/**
		 * @inheritDoc
		 */	
		public function getVolume(group:String=""):Number 
		{ 
			return (group?_rootMgr.group(group):_rootMgr).volume; 
		}
		/**
		 * @inheritDoc
		 */	
		public function setVolume(value:Number,group:String=""):void 
		{
			(group?_rootMgr.group(group):_rootMgr).volume = value;
		}
		/**
		 * @inheritDoc
		 */	
		public function getPan(group:String=""):Number 
		{ 
			return (group?_rootMgr.group(group):_rootMgr).pan; 
		}
		/**
		 * @inheritDoc
		 */	
		public function setPan(value:Number,group:String=""):void 
		{
			(group?_rootMgr.group(group):_rootMgr).pan = value;
		}
		/**
		 * @inheritDoc
		 */	
		public function get masterVolume():Number 
		{ 
			return _rootMgr.masterVolume; 
		}
		/**
		 * @inheritDoc
		 */	
		public function set masterVolume(value:Number):void 
		{
			_rootMgr.masterVolume = value;
		}
		/**
		 * @inheritDoc
		 */	
		public function setSoundTransform(value:SoundTransform,group:String=""):void 
		{
			(group?_rootMgr.group(group):_rootMgr).soundTransform = value;
		}
		/**
		 * @inheritDoc
		 */	
		public function removeSound(id:String):void 
		{
			_rootMgr.removeSound(id);
			_rootMgr.groups.every(function(mgr:SoundManager):void{mgr.removeSound(id);});
			//todo clear assetinfos
			//loadService.remove;
		}	
		/**
		 * @inheritDoc
		 */	
		public function removeAll():void 
		{
			_rootMgr.removeAll();
			//todo clear assetinfos
			//loadService.remove;
		}
	}
}