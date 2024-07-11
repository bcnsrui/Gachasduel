local s,id=GetID()
function s.initial_effect(c)
	Gacha2.UnitCharacter(c)
	Gacha3.BattlePhaseUnit(c)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCondition(s.tgcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
end
function s.tgcon(e)
	return e:GetHandler():IsAttackPos()
end