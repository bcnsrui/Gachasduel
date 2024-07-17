local s,id=GetID()
function s.initial_effect(c)
	Gacha2.UnitCharacter(c)
	Gacha3.BattlePhaseUnit(c)
	Gacha2.CelestialUnit(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(s.atklimit)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and not c:IsLocation(LOCATION_EMZONE+LOCATION_FZONE)
	and c:IsLevelBelow(2) and not c:IsSetCard(0xb01)
end
function s.atklimit(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,0,LOCATION_ONFIELD,0,2,nil)
	if #g>0 then
	Duel.HintSelection(g)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT) end
end