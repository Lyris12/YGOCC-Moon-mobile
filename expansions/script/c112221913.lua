--created by Hoshi, coded by Lyris
local cid,id=GetID()
function cid.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,aux.FilterBoolFunction(aux.AND(Card.IsFaceup,Card.IsXyzLevel),c,4),function(g) return g:IsExists(Card.IsCode,1,nil,id-13) end,2,2,aux.FilterBoolFunction(aux.AND(Card.IsFaceup,Card.IsCode),id-13),nil,cid.xyzop)
	aux.AddCodeList(c,id-13)
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsOriginalCodeRule,id))
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(id-13)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetTarget(cid.target)
	e2:SetOperation(cid.operation)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetOperation(cid.xdop)
	c:RegisterEffect(e4)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1000)
	e1:SetCondition(cid.con)
	e1:SetLabel(1)
	c:RegisterEffect(e1)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetValue(1)
	e5:SetCondition(cid.con)
	e5:SetLabel(2)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e7:SetLabel(3)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e8:SetCategory(CATEGORY_DESTROY)
	e8:SetLabel(4)
	e8:SetDescription(1124)
	e8:SetCondition(cid.con)
	e8:SetTarget(cid.destg)
	e8:SetOperation(cid.desop)
	c:RegisterEffect(e8)
	local qe1=e8:Clone()
	qe1:SetType(EFFECT_TYPE_QUICK_O)
	qe1:SetCode(EVENT_FREE_CHAIN)
	qe1:SetCondition(function(e,tp) return cid.con(e) and Duel.IsPlayerAffectedByEffect(tp,id+101) end)
	c:RegisterEffect(qe1)
	local e9=e8:Clone()
	e9:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE+2)
	e9:SetCategory(CATEGORY_REMOVE)
	e9:SetLabel(5)
	e9:SetDescription(1102)
	e9:SetTarget(cid.rmtg)
	e9:SetOperation(cid.rmop)
	c:RegisterEffect(e9)
	local qe2=e9:Clone()
	qe2:SetType(EFFECT_TYPE_QUICK_O)
	qe2:SetCode(EVENT_FREE_CHAIN)
	qe2:SetCondition(function(e,tp) return cid.con(e) and Duel.IsPlayerAffectedByEffect(tp,id+101) end)
	c:RegisterEffect(qe2)
	local ea=e8:Clone()
	ea:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE+4)
	ea:SetCategory(CATEGORY_TODECK)
	ea:SetLabel(6)
	ea:SetDescription(1105)
	ea:SetTarget(cid.tdtg)
	ea:SetOperation(cid.tdop)
	c:RegisterEffect(ea)
	local qe3=ea:Clone()
	qe3:SetType(EFFECT_TYPE_QUICK_O)
	qe3:SetCode(EVENT_FREE_CHAIN)
	qe3:SetCondition(function(e,tp) return cid.con(e) and Duel.IsPlayerAffectedByEffect(tp,id+101) end)
	c:RegisterEffect(qe3)
end
function cid.mfilter(c)
	return c:IsFaceup() and c:GetOriginalType()&TYPE_MONSTER>0 and c:IsSetCard(0xcda)
end
function cid.xyzop(e,tp,chk,tc)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.Overlay(e:GetHandler(),tc:GetEquipGroup():FilterSelect(tp,cid.mfilter,0,99,nil))
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function cid.filter(c,e,tp)
	return c:IsOriginalCodeRule(id-13) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND)
	if Duel.IsPlayerAffectedByEffect(tp,id+1) then Duel.SetChainLimit(function(e,rpr,p) return rpr==p end) end
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Duel.SpecialSummon(Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cid.filter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp),0,tp,tp,false,false,POS_FACEUP)
end
function cid.xdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetOverlayCount()>0 then c:RemoveOverlayCard(tp,1,1,REASON_EFFECT) end
end
function cid.con(e)
	return e:GetHandler():GetOverlayGroup():GetClassCount(Card.GetCode)>=e:GetLabel()
end
function cid.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cid.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD):Select(tp,1,1,nil)
	Duel.HintSelection(g)
	Duel.Destroy(g,REASON_EFFECT)
end
function cid.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function cid.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.HintSelection(g)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function cid.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_ONFIELD)
end
function cid.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.HintSelection(g)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
