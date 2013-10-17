package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.basics
{
	import release.module.kylinFightModule.gameplay.oldcore.core.ISceneFocusElement;
	import release.module.kylinFightModule.gameplay.oldcore.events.SceneElementEvent;
	import release.module.kylinFightModule.gameplay.oldcore.events.SceneElementFocusEvent;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	
	import flash.events.MouseEvent;

	/**
	 * 此类是场景交互元素（主要是点击）的获取焦点的逻辑。 
	 * @author Administrator
	 * 
	 */	
	public class BasicSceneInteractiveElement extends BasicBodySkinSceneElement implements ISceneFocusElement
	{
		protected var myIsInFocus:Boolean = false;
		protected var myFocusEnable:Boolean = true;
		protected var myFocusTipEnable:Boolean = false;

		public function BasicSceneInteractiveElement()
		{
			super();

			//self call interactive
			this.mouseEnabled = true;
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
				GameAGlobalManager.getInstance().gameInteractiveManager.disFocusTargetElement(this);
			}
		}
	}
}