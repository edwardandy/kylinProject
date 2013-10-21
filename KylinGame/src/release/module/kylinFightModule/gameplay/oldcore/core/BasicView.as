package release.module.kylinFightModule.gameplay.oldcore.core
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * 此类为战斗系统的显示的基础类， 该类实现了初始化，从显示列表加进移除的模板方法， 并提供了销毁机制 
	 * @author Administrator
	 * 
	 */	
	public class BasicView extends Sprite implements IDisposeObject
	{
		private var _isInitialized:Boolean = false;
		private var _isDisposed:Boolean = false;
		
		public function BasicView()
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
		}
		
		public final function get isInitialized():Boolean
		{
			return _isInitialized;
		}
		
		public function dispose():void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
		}
		
		protected function onInitialize():void 
		{
		}
		
		protected function onInitializedComplete():void
		{
		}
		
		protected function onAddToStage():void 
		{
		}
		
		protected function onRemoveFromStage():void 
		{
		}
		
		private function addToStageHandler(event:Event):void
		{
			if(!_isInitialized) 
			{
				_isInitialized = true;
				onInitialize();
				onInitializedComplete();
			}
			
			onAddToStage();
		}
		
		private function removeFromStageHandler(event:Event):void
		{
			onRemoveFromStage();
		}
	}
}
