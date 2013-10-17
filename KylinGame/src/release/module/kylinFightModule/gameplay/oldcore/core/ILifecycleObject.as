package release.module.kylinFightModule.gameplay.oldcore.core
{
	//具有循环生命周期的对象
	public interface ILifecycleObject extends IDisposeObject
	{
		//激活
		function notifyLifecycleActive():void;
		//冻结
		function notifyLifecycleFreeze():void;
	}
}