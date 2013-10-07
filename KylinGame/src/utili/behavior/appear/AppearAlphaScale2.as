 package utili.behavior.appear
{
	import kylin.echo.edward.utilities.display.DisplayUtility;
	
	import utili.behavior.Behavior;
	import utili.behavior.interfaces.IAppearBehavior;

	/**
	 * 面板出现特效
	 * （20130105前后要求统一的效果） 
	 * @author Jiao Zhongxiao
	 * 
	 */	
	public class AppearAlphaScale2 extends Behavior implements IAppearBehavior
	{
		public function AppearAlphaScale2()
		{
			super();
		}
		
		public function appear():void
		{
			DisplayUtility.instance.panelAppear( _mPanel, false, false, appearCB);
		}
	}
}