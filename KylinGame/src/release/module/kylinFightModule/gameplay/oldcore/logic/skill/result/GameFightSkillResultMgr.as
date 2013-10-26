package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result
{
	import release.module.kylinFightModule.gameplay.constant.Skill.SkillResultTyps;
	import release.module.kylinFightModule.gameplay.oldcore.logic.BasicHashMapMgr;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_AddAtk;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_AddAtkArea;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_AddGoodsPct;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_AddGroundEff;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_AddMaxLifePct;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_AddSoldierAtk;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_AddSoldierDef;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_AddTowerAtk;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_AddWalkEff;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_AtkRoundEnemy;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_AtkSpeedPct;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_BeastAngry;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_Betray;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_Block;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_ChangeWeapon;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_Def;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_Dmg;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_DmgAddition;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_DmgFlyPct;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_DmgPct;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_DmgPctBySize;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_DropBox;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_ExplodeAfterDie;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_ExtraAddTowerAtk;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_FireMoreDmgPct;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_HugeDmgPct;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_IceShield;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_IgnoreNormalDef;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_ImmuneRdcMoveSpd;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_Infect;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_Invincible;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_Invisible;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_Life;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_LifeToPhysicDef;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_MagicDef;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_MagicDmg;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_MaxLife;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_MoveSpeedPct;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_MultyAtk;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_PassiveAtk;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_PassiveAtkArea;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_PassiveAtkAreaPct;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_PassiveAtkPct;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_PassiveAtkRange;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_PassiveAtkSpdPct;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_PassiveDef;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_PassiveEquipPct;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_PassiveMagicDef;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_PassiveMaxLife;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_PassiveMaxLifePct;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_PassiveMoveSpeed;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_PassiveMoveSpeedPct;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_PassiveRdcRebirthPct;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_PassiveRdcSkillCdPct;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_PassiveSkillAtkPct;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_PlayerSilent;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_Provoke;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_RdcDmgByCategory;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_RdcDmgByLifeDown;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_RdcMagicCdAfterDie;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_Rebirth;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_ReboundDmgPct;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_ReflectRdcAtkSpd;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_RollBack;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_SafeLaunch;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_SenseElect;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_Sheep;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_Snowball;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_SpecialProcess;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_Stun;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_SuddenDeath;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_Summon;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_SummonAfterDie;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_TargetDmgPctToLife;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults.SkillResult_WeaknessAtk;
	
	import robotlegs.bender.framework.api.IInjector;
	
	public class GameFightSkillResultMgr extends BasicHashMapMgr
	{
		[Inject]
		public var injector:IInjector;
		
		public function GameFightSkillResultMgr()
		{
			super();
		}
		
		public function getSkillResultById(id:String):BasicSkillResult
		{
			var result:BasicSkillResult = _hashMap.get(id) as BasicSkillResult;
			if(result)
			{
				return result;
			}
			
			result = createSkillResult(id);
			if(result)
				_hashMap.put(id,result);
			return result;
		}
		
		private function createSkillResult(id:String):BasicSkillResult
		{
			var result:BasicSkillResult;
			switch(id)
			{
				case SkillResultTyps.MAXLIFE:
				{
					result = new SkillResult_MaxLife(id);
				}
					break;
				case SkillResultTyps.DMG:
				{
					result = new SkillResult_Dmg(id);
				}
					break;
				case SkillResultTyps.LIFE:
				{
					result = new SkillResult_Life(id);
				}
					break;
				case SkillResultTyps.LIFE:
				{
					result = new SkillResult_Life(id);
				}
					break;
				case SkillResultTyps.SUMMON:
				{
					result = new SkillResult_Summon(id);
				}
					break;
				case SkillResultTyps.REBIRTH:
				{
					result = new SkillResult_Rebirth(id);
				}
					break;
				case SkillResultTyps.INFECT:
				{
					result = new SkillResult_Infect(id);
				}
					break;
				case SkillResultTyps.INVINCIBLE:
				{
					result = new SkillResult_Invincible(id);
				}
					break;
				case SkillResultTyps.STUN:
				{
					result = new SkillResult_Stun(id);
				}
					break;
				case SkillResultTyps.MAGICDMG:
				{
					result = new SkillResult_MagicDmg(id);
				}
					break;
				case SkillResultTyps.DEF:
				{
					result = new SkillResult_Def(id);
				}
					break;
				case SkillResultTyps.MAGICDEF:
				{
					result = new SkillResult_MagicDef(id);
				}
					break;
				case SkillResultTyps.PASSIVE_MAXLIFE:
				{
					result = new SkillResult_PassiveMaxLife(id);
				}
					break;
				case SkillResultTyps.PASSIVE_MAXLIFE_PCT:
				{
					result = new SkillResult_PassiveMaxLifePct(id);
				}
					break;
				case SkillResultTyps.PASSIVE_DEF:
				{
					result = new SkillResult_PassiveDef(id);
				}
					break;
				case SkillResultTyps.PASSIVE_MAGIC_DEF:
				{
					result = new SkillResult_PassiveMagicDef(id);
				}
					break;
				case SkillResultTyps.PASSIVE_ATK:
				{
					result = new SkillResult_PassiveAtk(id);
				}
					break;
				case SkillResultTyps.PASSIVE_ATK_PCT:
				{
					result = new SkillResult_PassiveAtkPct(id);
				}
					break;
				case SkillResultTyps.PASSIVE_ATK_AREA_PCT:
				{
					result = new SkillResult_PassiveAtkAreaPct(id);
				}
					break;
				case SkillResultTyps.PASSIVE_ATK_AREA:
				{
					result = new SkillResult_PassiveAtkArea(id);
				}
					break;
				case SkillResultTyps.PASSIVE_MOVE_SPEED_PCT:
				{
					result = new SkillResult_PassiveMoveSpeedPct(id);
				}
					break;
				case SkillResultTyps.PASSIVE_MOVE_SPEED:
				{
					result = new SkillResult_PassiveMoveSpeed(id);
				}
					break;
				case SkillResultTyps.PASSIVE_ATK_SPD_PCT:
				{
					result = new SkillResult_PassiveAtkSpdPct(id);
				}
					break;
				case SkillResultTyps.PASSIVE_RDC_REBIRTH_PCT:
				{
					result = new SkillResult_PassiveRdcRebirthPct(id);
				}
					break;
				case SkillResultTyps.PASSIVE_SKILL_ATK_PCT:
				{
					result = new SkillResult_PassiveSkillAtkPct(id);
				}
					break;
				case SkillResultTyps.LIFE_TO_PHYSIC_DEF:
				{
					result = new SkillResult_LifeToPhysicDef(id);
				}
					break;
				case SkillResultTyps.HUGE_DMG__PCT:
				{
					result = new SkillResult_HugeDmgPct(id);
				}
					break;
				case SkillResultTyps.PASSIVE_RDC_SKILL_CD_PCT:
				{
					result = new SkillResult_PassiveRdcSkillCdPct(id);
				}
					break;
				case SkillResultTyps.BLOCK:
				{
					result = new SkillResult_Block(id);
				}
					break;
				case SkillResultTyps.REBOUND_DMG_PCT:
				{
					result = new SkillResult_ReboundDmgPct(id);
				}
					break;
				case SkillResultTyps.DMG_ADDITION:
				{
					result = new SkillResult_DmgAddition(id);
				}
					break;
				case SkillResultTyps.SAFE_LAUNCH:
				{
					result = new SkillResult_SafeLaunch(id);
				}
					break;
				case SkillResultTyps.MULTY_ATK:
				{
					result = new SkillResult_MultyAtk(id);
				}
					break;
				case SkillResultTyps.ADD_TOWER_ATK:
				{
					result = new SkillResult_AddTowerAtk(id);
				}
					break;
				case SkillResultTyps.MOVE_SPEED_PCT:
				{
					result = new SkillResult_MoveSpeedPct(id);
				}
					break;
				case SkillResultTyps.TARGET_DMG_PCT_TO_LIFE :
				{
					result = new SkillResult_TargetDmgPctToLife(id);
				}
					break;
				case SkillResultTyps.IMMUNE_RDC_MOVE_SPD :
				{
					result = new SkillResult_ImmuneRdcMoveSpd(id);
				}
					break;
				case SkillResultTyps.BETRAY :
				{
					result = new SkillResult_Betray(id);
				}
					break;
				case SkillResultTyps.BEAST_ANGRY :
				{
					result = new SkillResult_BeastAngry(id);
				}
					break;
				case SkillResultTyps.SNOWBALL :
				{
					result = new SkillResult_Snowball(id);
				}
					break;
				case SkillResultTyps.REFLECT_RDC_ATK_SPD :
				{
					result = new SkillResult_ReflectRdcAtkSpd(id);
				}
					break;
				case SkillResultTyps.ATK_ROUND_ENEMY :
				{
					result = new SkillResult_AtkRoundEnemy(id);
				}
					break;
				case SkillResultTyps.PROVOKE :
				{
					result = new SkillResult_Provoke(id);
				}
					break;
				case SkillResultTyps.WEAKNESS_ATK :
				{
					result = new SkillResult_WeaknessAtk(id);
				}
					break;
				case SkillResultTyps.DMG_PCT_BY_SIZE :
				{
					result = new SkillResult_DmgPctBySize(id);
				}
					break;
				case SkillResultTyps.ADD_MAX_LIFE_PCT :
				{
					result = new SkillResult_AddMaxLifePct(id);
				}
					break;
				case SkillResultTyps.RDC_DMG_BY_LIFE_DOWN :
				{
					result = new SkillResult_RdcDmgByLifeDown(id);
				}
					break;
				case SkillResultTyps.ADD_WALK_EFF :
				{
					result = new SkillResult_AddWalkEff(id);
				}
					break;
				case SkillResultTyps.RDC_DMG_BY_CATEGORY :
				{
					result = new SkillResult_RdcDmgByCategory(id);
				}
					break;
				case SkillResultTyps.INVISIBLE :
				{
					result = new SkillResult_Invisible(id);
				}
					break;
				case SkillResultTyps.DROP_BOX :
				{
					result = new SkillResult_DropBox(id);
				}
					break;
				case SkillResultTyps.SUDDEN_DEATH :
				{
					result = new SkillResult_SuddenDeath(id);
				}
					break;
				case SkillResultTyps.ATK_SPEED_PCT :
				{
					result = new SkillResult_AtkSpeedPct(id);
				}
					break;
				case SkillResultTyps.FIRE_MORE_DMG_PCT :
				{
					result = new SkillResult_FireMoreDmgPct(id);
				}
					break;
				case SkillResultTyps.ROLL_BACK :
				{
					result = new SkillResult_RollBack(id);
				}
					break;
				case SkillResultTyps.SHEEP :
				{
					result = new SkillResult_Sheep(id);
				}
					break;	
				case SkillResultTyps.ADD_SOLDIER_ATK :
				{
					result = new SkillResult_AddSoldierAtk(id);
				}
					break;	
				case SkillResultTyps.ADD_SOLDIER_DEF :
				{
					result = new SkillResult_AddSoldierDef(id);
				}
					break;
				case SkillResultTyps.EXPLODE_AFTER_DIE :
				{
					result = new SkillResult_ExplodeAfterDie(id);
				}
					break;
				case SkillResultTyps.CHANGE_WEAPON :
				{
					result = new SkillResult_ChangeWeapon(id);
				}
					break;
				case SkillResultTyps.ADD_ATK :
				{
					result = new SkillResult_AddAtk(id);
				}
					break;
				case SkillResultTyps.ICE_SHIELD :
				{
					result = new SkillResult_IceShield(id);
				}
					break;
				case SkillResultTyps.DMG_PCT :
				{
					result = new SkillResult_DmgPct(id);
				}
					break;
				case SkillResultTyps.PLAYER_SILENT :
				{
					result = new SkillResult_PlayerSilent(id);
				}
					break;
				case SkillResultTyps.SUMMON_AFTER_DIE :
				{
					result = new SkillResult_SummonAfterDie(id);
				}
					break;
				case SkillResultTyps.SPECIAL_PROCESS :
				{
					result = new SkillResult_SpecialProcess(id);
				}
					break;
				case SkillResultTyps.ADD_GROUND_EFF :
				{
					result = new SkillResult_AddGroundEff(id);
				}
					break;
				case SkillResultTyps.RDC_MAGIC_CD_AFTER_DIE :
				{
					result = new SkillResult_RdcMagicCdAfterDie(id);
				}
					break;
				case SkillResultTyps.SENSE_ELECT :
				{
					result = new SkillResult_SenseElect(id);
				}
					break;
				case SkillResultTyps.PASSIVE_EQUIP_PCT :
				{
					result = new SkillResult_PassiveEquipPct(id);
				}
					break;
				case SkillResultTyps.ADD_GOODS_PCT :
				{
					result = new SkillResult_AddGoodsPct(id);
				}
					break;
				case SkillResultTyps.IGNORE_NORMAL_DEF :
				{
					result = new SkillResult_IgnoreNormalDef(id);
				}
					break;
				case SkillResultTyps.DMG_FLY_PCT :
				{
					result = new SkillResult_DmgFlyPct(id);
				}
					break;
				case SkillResultTyps.PASSIVE_ATK_RANGE :
				{
					result = new SkillResult_PassiveAtkRange(id);
				}
					break;
				case SkillResultTyps.EXTRA_ADD_TOWER_ATK :
				{
					result = new SkillResult_ExtraAddTowerAtk(id);
				}
					break;
				case SkillResultTyps.ADD_ATK_AREA :
				{
					result = new SkillResult_AddAtkArea(id);
				}
					break;
			}
			if(result)
				injector.injectInto(result);
			return result;
		}
	}
}