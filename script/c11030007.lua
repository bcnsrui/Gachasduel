local s,id=GetID()
function s.initial_effect(c)
	Gacha2.UnitCharacter(c)
	Gacha3.BattlePhaseUnit(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCondition(s.con)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSetCard(0xa05) and not e:GetHandler():IsSetCard(0xc03)
end
function s.filter(c)
	return c:IsSetCard(0xa05) and c:IsLevel(4)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_ONFIELD,0,1,c) then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetTarget(function(_,c) return c:IsSetCard(0xa05) end)
	e1:SetValue(100)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
	c:RegisterEffect(e1) end
end