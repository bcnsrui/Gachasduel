local s,id=GetID()
function s.initial_effect(c)
	Gacha2.UnitCharacter(c)
	Gacha3.BattlePhaseUnit(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetValue(3)
	c:RegisterEffect(e1)
end
function s.fcfllter(c)
	return not c:IsLocation(LOCATION_EMZONE+LOCATION_FZONE)
end
function s.fcfllter2(c)
	return c:IsSetCard(0xa10)
end
function s.spcon(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(s.fcfllter,tp,0,LOCATION_ONFIELD,nil)-
	Duel.GetMatchingGroupCount(s.fcfllter,tp,LOCATION_ONFIELD,0,nil)>=2
	or (Duel.GetMatchingGroupCount(s.fcfllter2,tp,LOCATION_ONFIELD,0,nil)>=1 
	and Duel.GetMatchingGroupCount(s.fcfllter,tp,LOCATION_ONFIELD,0,nil)<=3)
end