local s,id=GetID()
function s.initial_effect(c)
	Gacha2.UnitCharacter(c)
	Gacha3.BattlePhaseUnit(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCost(s.cost)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil)
	local ag=g:Filter(Card.IsSetCard,nil,0xa03)
	
	if #ag==0 then	
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil)
	
	if #g>1 then
	local sg=g:RandomSelect(tp,2)
	Duel.SendtoDeck(sg,nil,0,REASON_RULE)
	Duel.Draw(tp,2,REASON_RULE) end	
	
	if #g==1 then
	Duel.SendtoDeck(g,nil,0,REASON_RULE)
	Duel.Draw(tp,1,REASON_RULE)
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_REMOVED,0,nil)
	Duel.SendtoGrave(g1,REASON_RULE)
	Duel.Remove(g1,POS_FACEDOWN,REASON_RULE)
	sg1=g1:RandomSelect(tp,1)
	if #sg1==0 then return end
	Duel.SendtoDeck(sg1,nil,0,REASON_RULE)
	Duel.Draw(tp,1,REASON_RULE) end
	
	if #g==0 then
	local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_REMOVED,0,nil)
	Duel.SendtoGrave(g2,REASON_RULE)
	Duel.Remove(g2,POS_FACEDOWN,REASON_RULE)
	sg2=g2:RandomSelect(tp,2)
	if #sg2==0 then 
	elseif #sg2==1 then
	Duel.SendtoDeck(sg2,nil,0,REASON_RULE)
	Duel.Draw(tp,1,REASON_RULE)
	elseif #sg2==2 then
	Duel.SendtoDeck(sg2,nil,0,REASON_RULE)
	Duel.Draw(tp,2,REASON_RULE) end end
	
	
	elseif #ag==1 then
	Duel.SendtoHand(ag:GetFirst(),nil,REASON_RULE)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil)
	
	if #g>0 then
	local sg=g:RandomSelect(tp,1)
	if #sg==0 then return end
	Duel.SendtoDeck(sg,nil,0,REASON_RULE)
	Duel.Draw(tp,1,REASON_RULE)
	
	elseif #g==0 then
	local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_REMOVED,0,nil)
	Duel.SendtoGrave(g2,REASON_RULE)
	Duel.Remove(g2,POS_FACEDOWN,REASON_RULE)
	sg2=g2:RandomSelect(tp,1)
	if #sg2==0 then return end
	Duel.SendtoDeck(sg2,nil,0,REASON_RULE)
	Duel.Draw(tp,1,REASON_RULE) end
	
	
	elseif #ag>1 then
	Duel.SendtoHand(ag:GetFirst(),nil,REASON_RULE)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil)
	local ag2=g:Filter(Card.IsSetCard,nil,0xa03)
	Duel.SendtoHand(ag2:GetFirst(),nil,REASON_RULE) end
end