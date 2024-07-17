--Gacha's Duel is Kami Game
Gacha={}

--메인 캐릭터 유틸
function Gacha.MainCharacter(c)
	Gacha.DuelStartMainCharacter(c)
	Gacha.DrawMainCharacter(c)
	Gacha.SpMainCharacter(c)
	Gacha.TurnPositionMainCharacter(c)
	Gacha.MainCharacterEff(c)
	Gacha.MainCharacterEff2(c)
	Gacha.MainCharacterTextEff(c)
end

--1듀얼 개시시의 효과
function Gacha.DuelStartMainCharacter(c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1)
	e1:SetOperation(Gacha.DuelStartop)
	c:RegisterEffect(e1)
end
function Gacha.drawcon3(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetTurnCount()==1
end
function Gacha.cost2filter(c)
	return c:IsLevel(2)
end
function Gacha.DuelStartop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ssg=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
	Duel.MoveToField(c,tp,tp,LOCATION_EMZONE,POS_FACEUP_ATTACK,true)
	local maindeck=1
	while maindeck<6 do
	local token=Duel.CreateToken(tp,11000101)
	Duel.Remove(token,POS_FACEDOWN,REASON_RULE)
	maindeck=maindeck+1
	end
	if Duel.GetTurnPlayer()==tp then
	if (Duel.GetMatchingGroupCount(Gacha.cost2filter,tp,LOCATION_DECK+LOCATION_HAND,0,nil)>5
	or Duel.GetMatchingGroupCount(Gacha.cost2filter,tp,0,LOCATION_DECK+LOCATION_HAND,nil)>5)
	and not (Duel.SelectYesNo(tp,aux.Stringid(11000002,5)) and Duel.SelectYesNo(1-tp,aux.Stringid(11000002,5)))
	then return Duel.Win(tp,WIN_REASON_GHOSTRICK_MISCHIEF) end
	Duel.SendtoDeck(ssg,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	Duel.Draw(tp,7,REASON_RULE)
	Duel.Draw(1-tp,8,REASON_RULE)
	local fg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local ffg=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	local a=1
	local b=1
	while a<=6 do
	local sg=fg:Filter(Card.IsLevel,nil,7-a)
	Duel.SendtoDeck(sg,nil,0,REASON_RULE)
	a=a+1
	end
	while b<=6 do
	local sg=ffg:Filter(Card.IsLevel,nil,7-b)
	Duel.SendtoDeck(sg,nil,0,REASON_RULE)
	b=b+1
	end
	Duel.Draw(tp,#fg,REASON_RULE)
	Duel.Draw(1-tp,#ffg,REASON_RULE)	end
	while Duel.GetTurnPlayer()==tp and Duel.GetMatchingGroupCount(nil,tp,LOCATION_EXTRA,0,nil)<2 do
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11000002,8))
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil):GetFirst()
	if g:IsLocation(LOCATION_HAND) then
	Duel.Sendto(g,LOCATION_EXTRA,REASON_RULE,POS_FACEDOWN)
	elseif g:IsLocation(LOCATION_EXTRA) then
	Duel.SendtoHand(g,nil,REASON_RULE)
	elseif Duel.GetMatchingGroupCount(nil,tp,LOCATION_EXTRA,0,nil)>1 then return end end	
	while Duel.GetTurnPlayer()==1-tp and Duel.GetMatchingGroupCount(nil,tp,LOCATION_EXTRA,0,nil)<3 do
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil):GetFirst()
	if g:IsLocation(LOCATION_HAND) then
	Duel.Sendto(g,LOCATION_EXTRA,REASON_RULE,POS_FACEDOWN)
	elseif g:IsLocation(LOCATION_EXTRA) then
	Duel.SendtoHand(g,nil,REASON_RULE)
	elseif Duel.GetMatchingGroupCount(nil,tp,LOCATION_EXTRA,0,nil)>2 then return end end
end

--특이사항처리(2유닛카드=랭크,3티켓수=라이프,5유닛존7제한)
function Gacha.SpMainCharacter(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CHANGE_RANK)
	e2:SetRange(LOCATION_EMZONE)
	e2:SetValue(Gacha.lvval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)	
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_EMZONE)
	e3:SetValue(Gacha.atkval)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)	
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	e4:SetRange(LOCATION_EMZONE)
	e4:SetValue(Gacha.defval)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_REPEAT+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetRange(LOCATION_EMZONE)
	e5:SetCode(EFFECT_DISABLE_FIELD)
	e5:SetOperation(Gacha.FieldTheRockop)
	c:RegisterEffect(e5)
end
function Gacha.lvval(e,c)
	return e:GetHandler():GetOverlayGroup():GetCount()
end
function Gacha.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsFacedown,c:GetControler(),LOCATION_EXTRA,0,nil)
end
function Gacha.defval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_EXTRA,0,nil)
end
function Gacha.FieldTheRockop(e,tp)
	return 0x00001500
end
--드로우페이즈 처리
 function Gacha.DrawMainCharacter(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_EMZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(Gacha.drawcon)
	e1:SetOperation(Gacha.drawop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_DRAW)
	e2:SetRange(LOCATION_EMZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(Gacha.drawcon2)
	e2:SetOperation(Gacha.drawop2)
	c:RegisterEffect(e2)
end
function Gacha.drawcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and (Duel.GetTurnCount()~=1 and Duel.GetTurnCount()~=2)
end
function Gacha.drawop(e,tp,eg,ep,ev,re,r,rp)
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
function Gacha.caffefilter(c)
    return not c:IsLocation(LOCATION_EMZONE) and c:IsCode(11050007)
end
function Gacha.drawcon2(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function Gacha.drawop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 then return end
	if Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)<7 then
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11000002,8))
	local ticketloss=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND,0,0,1,nil)
	while #ticketloss==0 and not Duel.SelectYesNo(tp,aux.Stringid(11000002,1)) do
	ticketloss=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND,0,0,1,nil)
	end
	Duel.Sendto(ticketloss,LOCATION_EXTRA,REASON_RULE,POS_FACEDOWN) end
	local c=e:GetHandler()
	local extra=Duel.GetMatchingGroupCount(nil,tp,LOCATION_EXTRA,0,nil)
	local caffe=Duel.GetMatchingGroupCount(Gacha.caffefilter,tp,LOCATION_ONFIELD,0,nil)
	local deck=Duel.GetMatchingGroup(nil,tp,LOCATION_DECK,0,nil)
	local deckcount=Duel.GetMatchingGroupCount(nil,tp,LOCATION_DECK,0,nil)
	local refill=Duel.GetMatchingGroup(nil,tp,LOCATION_GRAVE,0,nil)
	local grave=Duel.GetMatchingGroupCount(nil,tp,LOCATION_GRAVE,0,nil)
	if caffe==0 then
	if extra>deckcount+grave then 
	Duel.SetLP(tp,444)
	Duel.Overlay(c,deck)
	Duel.Overlay(c,refill)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetValue(0xa09)
	c:RegisterEffect(e1)
	elseif extra>deckcount and extra<=deckcount+grave then
	Duel.Overlay(c,deck)
	Duel.SendtoDeck(refill,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	local bg=Duel.GetDecktopGroup(tp,extra-deckcount)
	Duel.Overlay(c,bg)
	else
	local bg2=Duel.GetDecktopGroup(tp,extra)
	Duel.Overlay(c,bg2) end
	
	else
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11000002,6))
	local ac=Duel.AnnounceNumber(tp,0,1,caffe)
	if extra+ac>deckcount+grave then 
	Duel.SetLP(tp,444)
	Duel.Overlay(c,deck)
	Duel.Overlay(c,refill)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetValue(0xa09)
	c:RegisterEffect(e1)
	elseif extra+ac>deckcount and extra+ac<=deckcount+grave then
	Duel.Overlay(c,deck)
	Duel.SendtoDeck(refill,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	local bg=Duel.GetDecktopGroup(tp,extra+ac-deckcount)
	Duel.Overlay(c,bg)
	else
	local bg2=Duel.GetDecktopGroup(tp,extra+ac)
	Duel.Overlay(c,bg2) end
	end
end

--메인 캐릭터 기동효과
--1턴종료처리,2데미지처리,3패정렬,4데미지0
function Gacha.TurnPositionMainCharacter(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_EMZONE)
	e1:SetCountLimit(1)
	e1:SetOperation(Gacha.TurnPositionop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_EMZONE)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetCondition(Gacha.btdamcon)
	e2:SetOperation(Gacha.btdamop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11000002,4))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_EMZONE)
	e3:SetOperation(Gacha.handop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_EMZONE)
	e4:SetCode(EFFECT_CHANGE_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetTargetRange(1,0)
	e4:SetCondition(Gacha.damcon)
	e4:SetValue(0)
	c:RegisterEffect(e4)
end
function Gacha.TurnPositionfilter1(c)
	return c:IsDefensePos() and not c:IsLocation(LOCATION_EMZONE)
	and not c:IsCode(11030005)
end
function Gacha.TurnPositionfilter2(c)
	return c:IsDefensePos() and not c:IsLocation(LOCATION_EMZONE)
end
function Gacha.TurnPositionop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsSetCard(0xa09) then return Duel.Win(1-tp,WIN_REASON_GHOSTRICK_MISCHIEF) end
	local sg1=Duel.GetMatchingGroup(Gacha.TurnPositionfilter1,tp,LOCATION_ONFIELD,0,nil)
	local sg2=Duel.GetMatchingGroup(Gacha.TurnPositionfilter2,tp,LOCATION_ONFIELD,0,nil)
	if Duel.GetTurnPlayer()==tp then
	local og=c:GetOverlayGroup()
	Duel.ChangePosition(sg1,POS_FACEUP_ATTACK)
	Duel.Remove(og,POS_FACEUP,REASON_RULE) end
	if Duel.GetTurnPlayer()==1-tp then
	Duel.ChangePosition(sg2,POS_FACEUP_ATTACK) end
end
function Gacha.btdamcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and tp~=rp and r&REASON_BATTLE~=0 and Duel.GetAttacker():IsControler(1-tp)
end
function Gacha.btdamop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)
	if #ct==0 then return Duel.Win(1-tp,WIN_REASON_GHOSTRICK_MISCHIEF) end
	local ct2=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_EXTRA,0,nil)	
	if #ct2==7 then return Duel.Win(1-tp,WIN_REASON_GHOSTRICK_MISCHIEF) end
	local last=ct:GetFirst()
	local tc=ct:GetNext()
	for tc in aux.Next(ct) do
		if tc:GetSequence()<last:GetSequence() then last=tc end
	end
	Duel.SendtoGrave(last,REASON_RULE)
	Duel.SendtoExtraP(last,tp,REASON_RULE)
end
function Gacha.handop(e,tp,eg,ep,ev,re,r,rp)
	local fg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local a=1
	while a<=6 do
	local sg=fg:Filter(Card.IsLevel,nil,7-a)
	Duel.SendtoDeck(sg,nil,0,REASON_RULE)
	a=a+1
	end
	Duel.Draw(tp,#fg,REASON_RULE)
end
function Gacha.damcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetTurnPlayer()==tp
end

--유희왕과 다른 룰(1메인2스킵,2공격대상안됨,3패매수제한X,4드로우불가,5표시형식변경불가,6공격불가,7선공배틀,8몬스터존10개)
function Gacha.MainCharacterEff(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_EMZONE)
	e1:SetTargetRange(1,1)
	e1:SetCode(EFFECT_CANNOT_M2)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e2:SetRange(LOCATION_EMZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_HAND_LIMIT)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_EMZONE)
	e3:SetTargetRange(1,0)
	e3:SetValue(100)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DRAW_COUNT)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_EMZONE)
	e4:SetTargetRange(1,0)
	e4:SetValue(0)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetCode(EFFECT_BP_FIRST_TURN)
	e7:SetRange(LOCATION_EMZONE)
	e7:SetTargetRange(1,1)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_RIKKA_CROSS)
	e8:SetRange(LOCATION_EMZONE)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e8:SetTargetRange(1,0)
	c:RegisterEffect(e8)
end

function Gacha.MainCharacterEff2(c)
end



--텍스트(1턴종료시패배)
function Gacha.MainCharacterTextEff(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCondition(Gacha.hintcon)
	e1:SetOperation(Gacha.hintop)
	c:RegisterEffect(e1)
end
function Gacha.hintcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSetCard(0xa09)
end
function Gacha.hintop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetDescription(aux.Stringid(11000002,7))
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end