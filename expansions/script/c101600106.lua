--Black-Winged Raven of the Signer Dragon
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	--pitch
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(cid.thtg)
	e1:SetOperation(cid.thop)
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--synchro summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+100)
	e2:SetLabel(0)
	e2:SetCost(cid.syncost)
	e2:SetTarget(cid.syntg)
	e2:SetOperation(cid.synop)
	c:RegisterEffect(e2)
end
--PITCH
function cid.filter(c)
	return c:IsSetCard(0xcd01) and c:IsAbleToGrave()
end
function cid.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cid.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,cid.filter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
--SYNCHRO SUMMON
function cid.filter1(c,e,tp,c1,c2,lv)
	local g=(c1 and c2) and Group.FromCards(c1,c2) or nil
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0xcd01) and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,g,c)>0 and c:IsLevel(lv)
end
function cid.cfilter2(c,e,tp,c1)
	return c:IsType(TYPE_TUNER) and c:IsAbleToRemoveAsCost() and c:IsSetCard(0xcd01) and c:GetLevel()>0
		and Duel.IsExistingMatchingCard(cid.filter1,tp,LOCATION_EXTRA,0,1,Group.FromCards(c,c1),e,tp,c1,c,c:GetLevel()+c1:GetLevel())
end
function cid.syncost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function cid.syntg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(cid.cfilter2,tp,LOCATION_GRAVE,0,1,c,e,tp,c)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,cid.cfilter2,tp,LOCATION_GRAVE,0,1,1,c,e,tp,c)
	if not g2:GetFirst() then return end
	lv=c:GetLevel()+g2:GetFirst():GetLevel()
	g2:AddCard(c)
	if #g2==2 then
		Duel.Remove(g2,POS_FACEUP,REASON_COST)
		Duel.SetTargetParam(lv)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end
end
function cid.synop(e,tp,eg,ep,ev,re,r,rp)
	local lv=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,cid.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil,nil,lv):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
