package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects
{
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import com.shinezone.towerDefense.fight.constants.GroundSceneElementLayerType;
	import com.shinezone.towerDefense.fight.constants.SoundFields;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.basics.BasicBodySkinSceneElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.basics.BasicSceneElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.IOrganismSkiller;
	import release.module.kylinFightModule.gameplay.oldcore.utils.SimpleCDTimer;
	
	import framecore.structure.model.constdata.TowerSoundEffectsConst;
	import framecore.structure.model.user.TemplateDataFactory;
	import framecore.structure.model.user.magicSkill.MagicSkillTemplateInfo;
	import framecore.tools.GameStringUtil;
	import framecore.tools.media.TowerMediaPlayer;

	//法术效果
	public class BasicMagicSkillEffect extends BasicBodySkinSceneElement
	{
		
		protected var myMagicSkillTemplateInfo:MagicSkillTemplateInfo;
		
		protected var myEffectParameters:Object = null;
		
		protected var myBuffer1Parameters:Object = null;
		protected var myBuffer2Parameters:Object = null;
		protected var myBuffer3Parameters:Object = null;
		
		protected var myMagicSkillCDTimer:SimpleCDTimer;
		protected var myPerSceondCDTimer:SimpleCDTimer;
		protected var myIsMonomerMagic:Boolean = false;
		protected var _myMagicLevel:int = -1;
		/**
		 * 每次使用时的伤害值
		 */
		protected var myMagicHurtValue:int = -1;
		
		protected var myMonomerMagicTarget:BasicOrganismElement;
		
		public function BasicMagicSkillEffect(typeId:int)
		{
			super();

			//法术大部分都是顶层的，有部分是底层的
			this.myElemeCategory = GameObjectCategoryType.MAGIC_SKILL;
			this.myObjectTypeId = typeId;
			this.myGroundSceneLayerType = GroundSceneElementLayerType.LAYER_TOP;
			
			myMagicSkillTemplateInfo = TemplateDataFactory.getInstance().getMagicSkillTemplateById(typeId);
			_myMagicLevel = myMagicSkillTemplateInfo.level;
			myIsMonomerMagic = myMagicSkillTemplateInfo.releaseWay == 3;
			
			myEffectParameters = GameStringUtil.deserializeString(myMagicSkillTemplateInfo.effect);
			
			var buffs:Array = myMagicSkillTemplateInfo.getBuffs();
			if(buffs)
			{
				myBuffer1Parameters = GameStringUtil.deserializeString(buffs[0]);
				myBuffer2Parameters = GameStringUtil.deserializeString(buffs[1]);
				myBuffer3Parameters = GameStringUtil.deserializeString(buffs[2]);
			}
		}
		
		protected function get myMagicLevel():int
		{
			return ((_myMagicLevel-1)/10)+1;
		}
		
		//API
		public function setMonomerMagicTarget(target:BasicOrganismElement):void
		{
			if(myIsMonomerMagic)
			{
				myMonomerMagicTarget = target;
			}
		}
		
		override protected function get bodySkinResourceURL():String
		{
			return myMagicSkillTemplateInfo.resId>0?(myElemeCategory + "_" + myMagicSkillTemplateInfo.resId):"";
		}
		
		protected function necessarySearchConditionFilter(element:BasicOrganismElement):Boolean
		{
			return !element.isBoss && myMagicSkillTemplateInfo.canAirFight == 0 ? !element.fightState.isFlyUnit : true;
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			myMagicSkillCDTimer = new SimpleCDTimer(myMagicSkillTemplateInfo.duration);
			myPerSceondCDTimer = new SimpleCDTimer(1000);
		}

		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
			
			myMagicSkillCDTimer.resetCDTime();
			myPerSceondCDTimer.resetCDTime();
			
			playSound(getSoundId(SoundFields.Use));
		}
		
		override protected function getDefaultSoundString():String
		{
			return myMagicSkillTemplateInfo?myMagicSkillTemplateInfo.sound:null;
		}
		
		override protected function onLifecycleFreeze():void
		{
			super.onLifecycleFreeze();

			myMonomerMagicTarget = null;
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			myMagicSkillTemplateInfo = null;
			myEffectParameters = null;
		}
	}
}