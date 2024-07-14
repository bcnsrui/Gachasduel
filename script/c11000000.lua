local s,id=GetID()
function s.initial_effect(c)
	Gacha.SpMainCharacter(c)
	Gacha.MainCharacterEff(c)
	Gacha.DrawMainCharacter(c)
	Gacha.MainCharacterTextEff(c)
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PREDRAW)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCountLimit(1)
	e0:SetOperation(s.DuelStartop)
	c:RegisterEffect(e0)
	--0~5카드보내기,6~8드로우,9메인덱맨위,10소환제약ON/OFF
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_EMZONE)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,6))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_EMZONE)
	e6:SetOperation(s.draw)
	c:RegisterEffect(e6)
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(id,9))
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetRange(LOCATION_EMZONE)
	e9:SetOperation(s.op2)
	c:RegisterEffect(e9)
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(id,10))
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetRange(LOCATION_EMZONE)
	e10:SetOperation(s.op3)
	c:RegisterEffect(e10)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_EMZONE)
	e4:SetCode(EFFECT_CHANGE_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetTargetRange(1,0)
	e4:SetCondition(Gacha.damcon)
	e4:SetValue(0)
	c:RegisterEffect(e4)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_EMZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(s.TurnPositionop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_EMZONE)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetCondition(s.btdamcon)
	e3:SetOperation(s.btdamop)
	c:RegisterEffect(e3)
end
function s.DuelStartop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_EMZONE,POS_FACEUP_DEFENSE,true)
	local maindeck=1
	while maindeck<6 do
	local token=Duel.CreateToken(tp,11000101)
	Duel.Remove(token,POS_FACEDOWN,REASON_RULE)
	maindeck=maindeck+1
	end
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetReset(RESET_EVENT+RESET_TOHAND)
	e1:SetValue(0xa03)
	tc:RegisterEffect(e1)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAttackPos() then
	Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	else Duel.ChangePosition(c,POS_FACEUP_ATTACK) end
end

--1트래시,2드롭존,3메인덱,4소재채우기,5라이프
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_DECK,0,0,100,nil)
	local op=Duel.SelectEffect(tp,{true,aux.Stringid(id,1)},{true,aux.Stringid(id,2)},
	{true,aux.Stringid(id,3)},{true,aux.Stringid(id,4)},{true,aux.Stringid(id,5)})
	if op==1 then
	Duel.Remove(g,POS_FACEUP,REASON_RULE)
	elseif op==2 then
	Duel.SendtoGrave(g,REASON_RULE)
	elseif op==3 then
	Duel.Remove(g,POS_FACEDOWN,REASON_RULE)
	elseif op==4 then
	Duel.Overlay(c,g)
	elseif op==5 then
	Duel.Sendto(g,LOCATION_EXTRA,REASON_RULE,POS_FACEDOWN)
	end
end
--7드로우1,8드로우2
function s.draw(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=Duel.SelectEffect(tp,{true,aux.Stringid(id,7)},{true,aux.Stringid(id,8)})
	if op==1 then
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil)
    local ag=g:Filter(Card.IsSetCard,nil,0xa03)
    
    if #ag==0 and #g>0 then
    sg1=g:RandomSelect(tp,1)    
    Duel.SendtoDeck(sg1,nil,0,REASON_RULE)
    Duel.Draw(tp,1,REASON_RULE) end

    if #ag==0 and #g==0 then
    local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_REMOVED,0,nil)
    Duel.SendtoGrave(g2,REASON_RULE)
    Duel.Remove(g2,POS_FACEDOWN,REASON_RULE)
    sg2=g2:RandomSelect(tp,1)
    if #sg2==0 then return end
    Duel.SendtoDeck(sg2,nil,0,REASON_RULE)
    Duel.Draw(tp,1,REASON_RULE) end
    
    if #ag>0 then
    Duel.SendtoHand(ag:GetFirst(),nil,REASON_RULE) end
	
	elseif op==2 then
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
end end

function s.TurnPositionfilter1(c)
	return c:IsDefensePos() and not c:IsLocation(LOCATION_EMZONE)
	and not c:IsCode(11030005)
end
function s.TurnPositionfilter2(c)
	return c:IsDefensePos() and not c:IsLocation(LOCATION_EMZONE)
end
function s.TurnPositionop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()	
	local sg1=Duel.GetMatchingGroup(s.TurnPositionfilter1,tp,LOCATION_ONFIELD,0,nil)
	local sg2=Duel.GetMatchingGroup(s.TurnPositionfilter2,tp,LOCATION_ONFIELD,0,nil)
	if Duel.GetTurnPlayer()==tp then
	local og=c:GetOverlayGroup()
	Duel.ChangePosition(sg1,POS_FACEUP_ATTACK)
	Duel.Remove(og,POS_FACEUP,REASON_RULE) end
	if Duel.GetTurnPlayer()==1-tp then
	Duel.ChangePosition(sg2,POS_FACEUP_ATTACK) end
end
function s.btdamcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and tp~=rp and r&REASON_BATTLE~=0 and Duel.GetAttacker():IsControler(1-tp)
end
function s.btdamop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)
	if #ct==0 then return Duel.Win(1-tp,WIN_REASON_GHOSTRICK_MISCHIEF) end
	local last=ct:GetFirst()
	local tc=ct:GetNext()
	for tc in aux.Next(ct) do
		if tc:GetSequence()<last:GetSequence() then last=tc end
	end
	Duel.SendtoGrave(last,REASON_RULE)
	Duel.SendtoExtraP(last,tp,REASON_RULE)
	local ct2=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_EXTRA,0,nil)	
	if #ct2==7 then return Duel.Win(1-tp,WIN_REASON_GHOSTRICK_MISCHIEF) end
end