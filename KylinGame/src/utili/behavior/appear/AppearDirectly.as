package utili.behavior.appear
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import utili.behavior.Behavior;
	import utili.behavior.interfaces.IAppear;
	import utili.behavior.interfaces.IAppearBehavior;
	import utili.behavior.interfaces.IDispose;

	/**
	 * ...直接出现
	 * @author MAY
	 */
	public class AppearDirectly extends Behavior implements IAppearBehavior
	{
		/**
		 * 出现
		 */
		public function appear():void
		{
			_mPanel.alpha = 1;
			_mPanel.visible = true;
		}
		
		/**
		 * 停止动作
		 */
		public function stopAction():void
		{
			
		}
		
		/**
		 * 销毁
		 */
		override public function dispose():void
		{
			super.dispose();
		}
		
	}

}