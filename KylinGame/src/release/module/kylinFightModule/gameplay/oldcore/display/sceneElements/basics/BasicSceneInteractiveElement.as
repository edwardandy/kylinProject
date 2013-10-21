package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.basics
{
	import release.module.kylinFightModule.gameplay.oldcore.core.ISceneFocusElement;
	import release.module.kylinFightModule.gameplay.oldcore.events.SceneElementEvent;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameFightInteractiveManager;

	/**
	 * 此类是场景交互元素（主要是点击）的获取焦点的逻辑。 
	 * @author Administrator
	 * 
	 */	
	public class BasicSceneInteractiveElement extends BasicBodySkinSceneElement implements ISceneFocusElement
	{
		[Inject]
		public var gameInteractiveMgr:GameFightInteractiveManager;
		
		protected var myIsInFocus:Boolean = false;
		protected var myFocusEnable:Boolean = true;
		protected var myFocusTipEnable:Boolean = false;

		public function BasicSceneInteractiveElement()
		{
			super();

			//self call interactive
			this.mouseEnabled = true;
		}
		
		override protected function clearStateWhenFreeze(bDie:Boolean=false):void
		{
			myIsInFocus = false;
			myFocusEnable = true;
			myFocusTipEnable = false;
			super.clearStateWhenFreeze(bDie);
		}

		//ISceneFocusElement Interface
		public final function setIsOnFocus(isFocus:Boolean):void
		{
			if(myIsInFocus != isFocus)
			{
				myIsInFocus = isFocus;
				
				if(hasEventListener(SceneElementEvent.ON_FOCUS) ||
					hasEventListener(SceneElementEvent.ON_DISFOCUS))
				{
					dispatchEvent(new SceneElementEvent(myIsInFocus ? SceneElementEvent.ON_FOCUS : SceneElementEvent.ON_DISFOCUS));
				}
				
				onFocusChanged();
			}
		}
		
		public final function get focusEnable():Boolean
		{
			return myFocusEnable;
		}
		
		public final function get focusTipEnable():Boolean
		{
			return myFocusTipEnable;
		}
		
		public function get focusTips():String
		{
			return "BasicSceneInteractiveElement Tips";
		}
		
		protected function onFocusChanged():void
		{
		}
		
		override protected function onRemoveFromStage():void
		{
			super.onRemoveFromStage();
			
			if(myFocusEnable)
			{
				gameInteractiveMgr.disFocusTargetElement(this);
			}
		}
	}
}