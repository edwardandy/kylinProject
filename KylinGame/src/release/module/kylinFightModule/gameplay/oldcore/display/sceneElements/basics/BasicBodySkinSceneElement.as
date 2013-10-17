package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.basics
{
	import com.shinezone.core.resource.ClassLibrary;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import com.shinezone.towerDefense.fight.constants.OrganismBodySizeType;
	import release.module.kylinFightModule.gameplay.oldcore.core.TickSynchronizer;
	import release.module.kylinFightModule.gameplay.oldcore.display.render.BitmapFrameInfo;
	import release.module.kylinFightModule.gameplay.oldcore.display.render.BitmapMovieClip;
	import release.module.kylinFightModule.gameplay.oldcore.display.render.NewBitmapMovieClip;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	
	import framecore.tools.loadmgr.LoadMgr;

	/**
	 * 此类聚合了 BitmapMovieClip 对象， 实现了通过bodySkinResourceURL对动画数据的映射
	 * @author Administrator
	 * 
	 */	
	public class BasicBodySkinSceneElement extends BasicSceneElement
	{
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
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
		}
		
		protected final function setScaleRatioType(scaleRatioType:int):void
		{
			myScaleRatioType = scaleRatioType;
		}
		
		protected function createBodySkin():void
		{
			if(!bodySkinResourceURL)
				return;
			//will stop inner default
			//var vecFrames:Vector.<BitmapFrameInfo> = ObjectPoolManager.getInstance().getBitmapFrameInfos(bodySkinResourceURL, myScaleRatioType);
			//if(vecFrames)
			{
				myBodySkin = new NewBitmapMovieClip([bodySkinResourceURL], [myScaleRatioType]);
				myBodySkin.smoothing = true;
				addChild(myBodySkin);
			}
		}
		
		override public function update(iElapse:int):void
		{
			if(myBodySkin != null) 
				myBodySkin.update(iElapse);
		}

		override public function render(iElapse:int):void
		{
			//有时会在render函数调用dispose(), 这样myBodySkin被设置为null了
			if(myBodySkin != null) 
				myBodySkin.render(iElapse);
		}
		
		//IDisposeObject Interface
		override public function dispose():void
		{
			super.dispose();
			
			if(myBodySkin != null)
			{
				removeChild(myBodySkin);
				myBodySkin.dispose();
				myBodySkin = null;
			}	
		}
		
		protected function playClickEff():void
		{
			if(!_mcClickEff)
			{
				//_mcClickEff = ClassLibrary.getInstance().getMovieClip("click_effect");//new clickCls();
				_mcClickEff = LoadMgr.instance.domainMgr.getMovieClipByDomain("click_effect");
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
			if(!_mcClickEff || !contains(_mcClickEff))
				return;
			removeChild(_mcClickEff);
		}
	}
}