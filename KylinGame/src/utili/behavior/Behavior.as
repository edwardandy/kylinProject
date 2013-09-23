package utili.behavior
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import utili.behavior.interfaces.IBehavior;
	
	/**
	 * ...行为父类
	 * @author MAY
	 */
	public class Behavior implements IBehavior
	{
		/**
		 * 面板引用
		 */
		protected var _mPanel:Sprite;
		/**
		 * 回调函数
		 */
		protected var _callBack:Function;
		/**
		 * 老时间
		 */
		protected var _iOldTime:int;
		/**
		 * 缩放因子
		 */
		protected var _nFactor:Number;
		
		/**
		 * 设置变量
		 * @param	_panel
		 * @param	_call
		 */
		public function init(panel:Sprite, cb:Function = null):void
		{
			_mPanel = panel;
			_callBack = cb;
		}
		
		protected function appearCB():void
		{
			if(null != _callBack)
				_callBack(this,_mPanel);
		}
		
		/**
		 * 销毁
		 */
		public function dispose():void
		{
			_mPanel = null;
			_callBack = null;
		}
		
	}

}