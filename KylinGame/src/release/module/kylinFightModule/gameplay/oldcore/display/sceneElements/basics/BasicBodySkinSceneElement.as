package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.basics
{
	import flash.display.MovieClip;
	
	import mainModule.service.loadServices.interfaces.ILoadAssetsServices;
	
	import release.module.kylinFightModule.gameplay.constant.OrganismBodySizeType;
	import release.module.kylinFightModule.gameplay.oldcore.display.render.NewBitmapMovieClip;
	
	import robotlegs.bender.framework.api.IInjector;

	/**
	 * 此类聚合了 BitmapMovieClip 对象， 实现了通过bodySkinResourceURL对动画数据的映射
	 * @author Administrator
	 * 
	 */	
	public class BasicBodySkinSceneElement extends BasicSceneElement
	{
		[Inject]
		public var injector:IInjector;
		[Inject]
		public var loadAssetsService:ILoadAssetsServices;
		
		protected var myBodySkin:NewBitmapMovieClip;
		protected var myOldBodySkin:NewBitmapMovieClip;
		protected var myScaleRatioType:int = OrganismBodySizeType.SIZE_NORMAL;
		
		private var _mcClickEff:MovieClip;
		
		public function BasicBodySkinSceneElement()
		{
			super();
		}
		
		//default
		protected function get bodySkinResourceURL():String
		{
			return myObjectTypeId>0 ? (myElemeCategory + "_" + myObjectTypeId) : "";
		}
		
		public function setBodyFilter(filters:Array):void
		{
			myBodySkin.filters = filters;
		}

		override protected function onInitialize():void
		{
			super.onInitialize();	
			createBodySkin();
		}
		
		override protected function clearStateWhenFreeze(bDie:Boolean=false):void
		{
			if(myBodySkin)
			{
				myBodySkin.filters = null;
				myBodySkin.clear();
			}
			stopClickEff();
			super.clearStateWhenFreeze(bDie);
		}
		
		protected final function setScaleRatioType(scaleRatioType:int):void
		{
			myScaleRatioType = scaleRatioType;
		}
		
		protected function createBodySkin():void
		{
			if(!bodySkinResourceURL)
				return;	
			myBodySkin = new NewBitmapMovieClip([bodySkinResourceURL], [myScaleRatioType]);
			injector.injectInto(myBodySkin);
			myBodySkin.smoothing = true;
			addChild(myBodySkin);
		}

		override public function render(iElapse:int):void
		{
			super.render(iElapse);
			//有时会在render函数调用dispose(), 这样myBodySkin被设置为null了
			if(myBodySkin != null) 
				myBodySkin.render(iElapse);
		}
		
		//IDisposeObject Interface
		override public function dispose():void
		{	
			if(myBodySkin)
			{
				removeChild(myBodySkin);
				myBodySkin.dispose();
				myBodySkin = null;
			}	
			_mcClickEff = null;
			super.dispose();
		}
		
		protected function playClickEff():void
		{
			if(!_mcClickEff)
			{				
				_mcClickEff = loadAssetsService.domainMgr.getMovieClipByDomain("click_effect");
				_mcClickEff.mouseChildren = false;
				_mcClickEff.mouseEnabled = false;
				_mcClickEff.x = 0;
				_mcClickEff.y = -myBodySkin.height-10;
			}
			addChild(_mcClickEff);
			_mcClickEff.gotoAndPlay(1);
		}
		
		protected function stopClickEff():void
		{
			if(_mcClickEff)
			{
				_mcClickEff.stop();
				if(contains(_mcClickEff))
					removeChild(_mcClickEff);
			}
		}
	}
}