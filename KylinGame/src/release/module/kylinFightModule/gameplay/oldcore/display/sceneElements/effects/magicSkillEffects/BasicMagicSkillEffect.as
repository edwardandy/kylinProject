package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects
{
	import io.smash.time.TimeManager;
	
	import mainModule.model.gameData.dynamicData.magicSkill.IMagicSkillDynamicDataModel;
	import mainModule.model.gameData.sheetData.skill.magic.IMagicSkillSheetDataModel;
	import mainModule.model.gameData.sheetData.skill.magic.IMagicSkillSheetItem;
	
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.constant.GroundSceneElementLayerType;
	import release.module.kylinFightModule.gameplay.constant.SoundFields;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.basics.BasicBodySkinSceneElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.GameFightSkillResultMgr;
	import release.module.kylinFightModule.gameplay.oldcore.utils.SimpleCDTimer;

	//法术效果
	public class BasicMagicSkillEffect extends BasicBodySkinSceneElement
	{
		[Inject]
		public var magicModel:IMagicSkillSheetDataModel;
		[Inject]
		public var magicData:IMagicSkillDynamicDataModel;
		[Inject]
		public var timeMgr:TimeManager;
		[Inject]
		public var skillResultMgr:GameFightSkillResultMgr;
		
		protected var myMagicSkillTemplateInfo:IMagicSkillSheetItem;
		
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
		}
		
		[PostConstruct]
		public function onPostConstruct():void
		{
			myMagicSkillTemplateInfo = magicModel.getMagicSkillSheetById(myObjectTypeId);
			_myMagicLevel = myMagicSkillTemplateInfo.level;
			myIsMonomerMagic = myMagicSkillTemplateInfo.releaseWay == 3;
			
			myEffectParameters = myMagicSkillTemplateInfo.objEffect;
			
			var buffs:Array = myMagicSkillTemplateInfo.getBuffs();
			if(buffs)
			{
				myBuffer1Parameters = buffs[0];
				myBuffer2Parameters = buffs[1];
				myBuffer3Parameters = buffs[2];
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
			injector.injectInto(myMagicSkillCDTimer);
			myPerSceondCDTimer = new SimpleCDTimer(1000);
			injector.injectInto(myPerSceondCDTimer);
		}

		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
			
			myMagicSkillCDTimer.resetCDTime();
			myPerSceondCDTimer.resetCDTime();
			
			playSound(getSoundId(SoundFields.Use));
		}
		
		override protected function getDefaultSoundObj():Object
		{
			return myMagicSkillTemplateInfo?myMagicSkillTemplateInfo.objSound:null;
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