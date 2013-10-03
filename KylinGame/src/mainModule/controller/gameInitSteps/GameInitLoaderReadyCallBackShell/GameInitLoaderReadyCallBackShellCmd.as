package mainModule.controller.gameInitSteps.GameInitLoaderReadyCallBackShell
{
	import kylin.echo.edward.framwork.controller.KylinCommand;
	
	/**
	 * 加载面板准备好之后进行回调,移除shell  
	 * @author Edward
	 * 
	 */	
	public class GameInitLoaderReadyCallBackShellCmd extends KylinCommand
	{
		
		public function GameInitLoaderReadyCallBackShellCmd()
		{
			super();
		}
		
		override public function execute():void
		{
			super.execute();
			
			if(contextView.view.stage && contextView.view.stage.numChildren)
			{
				//将shell从舞台移除
				contextView.view.stage.removeChildAt(1);
			}
		}
	}
}