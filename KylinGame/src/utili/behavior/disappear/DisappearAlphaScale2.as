package utili.behavior.disappear
{
	import kylin.echo.edward.utilities.display.DisplayUtility;
	
	import utili.behavior.Behavior;
	import utili.behavior.interfaces.IDisappearBehavior;

	/**
	 * 面板消失特效
	 * （20130105前后要求统一的效果）  
	 * @author Jiao Zhongxiao
	 * 
	 */	
	public class DisappearAlphaScale2 extends Behavior implements IDisappearBehavior
	{
		public function DisappearAlphaScale2()
		{
			super();
		}
		
		public function disappear():void
		{
			DisplayUtility.instance.panelDisappear( _mPanel, false, false,appearCB);
		}
	}
}