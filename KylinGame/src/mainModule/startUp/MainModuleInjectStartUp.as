package mainModule.startUp
{
	import kylin.echo.edward.utilities.loader.LoadMgr;
	import kylin.echo.edward.utilities.loader.LoaderProgress;
	import kylin.echo.edward.utilities.loader.interfaces.ILoadMgr;
	import kylin.echo.edward.utilities.loader.interfaces.ILoaderProgress;
	import kylin.echo.edward.utilities.loader.resPath.ResPathMgr;
	import kylin.echo.edward.utilities.loader.resPath.ResPathParam;
	
	import org.robotlegs.core.IInjector;
	/**
	 * 主模块依赖注入规则注册 
	 * @author Edward
	 * 
	 */	
	public final class MainModuleInjectStartUp
	{
		public function MainModuleInjectStartUp(inject:IInjector)
		{
			//在游戏初始化获得所有参数时执行
			//inject.mapValue(ResPathParam,new ResPathParam());
			inject.mapSingletonOf(ILoadMgr,LoadMgr);	
			inject.mapClass(ILoaderProgress,LoaderProgress);
		}
	}
}