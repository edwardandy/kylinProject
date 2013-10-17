package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms
{
	public interface IOrganismSkiller
	{
		//通知伤害着，被伤害者死亡
		function notifyHurtTagetOnkill(beHurtTarget:BasicOrganismElement, finalHurtValue:uint):void;
	}
}