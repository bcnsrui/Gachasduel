--Gacha's Duel is Kami Game
Gacha2={}

--유닛 유틸
function Gacha2.UnitCharacter(c)
	Gacha2.SummonUnit(c)
	Gacha2.UnitEff(c)
	Gacha2.SnipeUnit(c)
	Gacha2.HintUnit(c)
end

--등장 스크립트
function Gacha2.SummonUnit(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(Gacha2.sumcon)
	e1:SetTarget(Gacha2.sumtg)
	e1:SetOperation(Gacha2.sumop)
	c:RegisterEffect(e1)
end
function Gacha2.summonfilter(c)
	return c:IsDefensePos()
end
function Gacha2.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    return Duel.CheckRemoveOverlayCard(tp,1,0,c:GetLevel(),REASON_COST)
	or Duel.IsExistingMatchingCard(Gacha2.summonfilter,tp,LOCATION_EMZONE,0,1,nil)
end
function Gacha2.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function Gacha2.sumop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(Gacha2.summonfilter,tp,LOCATION_EMZONE,0,1,nil) 
	then return Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK) end
	local g=Duel.GetOverlayGroup(tp,1,0)
	local ag=g:Select(tp,0,c:GetLevel(),nil)
	if ag:GetCount()~=c:GetLevel() then return end
	Duel.SendtoGrave(ag,REASON_EFFECT)
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)
end

--유희왕과 다른 룰(1무한공격,2표시형식변경불가,3~4통상소환불가,6직공가능,7전투뎀1,8펜듈럼이아닌펜듈럼,9관통뎀)
function Gacha2.UnitEff(c)
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EFFECT_EXTRA_ATTACK)
    e1:SetValue(100)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(e4)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_DIRECT_ATTACK)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_LEAVE_FIELD)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e8:SetCondition(Gacha2.pencon)
	e8:SetOperation(Gacha2.penop)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e9:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e9)
end
function Gacha2.pencon(e)
	return e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function Gacha2.penop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end

--0공격대상안됨,1제로저격,2루시퍼저격
function Gacha2.SnipeUnit(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e0:SetCondition(Gacha2.snipecon)
	e0:SetValue(Gacha2.snipefilter)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetCondition(Gacha2.snipecon1)
	e1:SetValue(Gacha2.snipefilter1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetCondition(Gacha2.snipecon2)
	e2:SetValue(Gacha2.snipefilter2)
	c:RegisterEffect(e2)
end
function Gacha2.snipecon(e)
	local c=e:GetHandler()
	return not c:IsSetCard(0xc01) and not c:IsSetCard(0xc02)
end
function Gacha2.snipefilter(e,c)
	return c:IsAttackPos()
end
function Gacha2.snipecon1(e)
	return e:GetHandler():IsSetCard(0xc01)
end
function Gacha2.snipefilter1(e,c)
	return not c:IsLevelBelow(2)
end
function Gacha2.snipecon2(e)
	return e:GetHandler():IsSetCard(0xc02)
end
function Gacha2.snipefilter2(e,c)
	return not c:IsLevelBelow(5)
end

--1별자리
function Gacha2.CelestialUnit(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_REPEAT)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCondition(Gacha2.Celestialcon)
	e1:SetOperation(Gacha2.Celestialop)
	c:RegisterEffect(e1)
end
function Gacha2.Celestialcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp and e:GetHandler():IsDefensePos()
end
function Gacha2.Celestialop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetMatchingGroup(nil,tp,LOCATION_EMZONE,0,nil):GetFirst()
	Duel.Overlay(tc,c)
end

--1수비표시
function Gacha2.HintUnit(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCondition(Gacha2.hintcon)
	e1:SetOperation(Gacha2.hintop)
	c:RegisterEffect(e1)
end
function Gacha2.hintcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_SZONE) and c:IsDefensePos()
end
function Gacha2.hintop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11000002,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end