package release.module.kylinFightModule.gameplay.oldcore.core
{
	import flash.events.IEventDispatcher;

	public interface ISceneFocusElement extends IEventDispatcher
	{
		function setIsOnFocus(isFocus:Boolean):void;
		function get focusTipEnable():Boolean;
		function get focusEnable():Boolean;
		function get focusTips():String;
	}
}