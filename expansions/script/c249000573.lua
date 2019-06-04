--Auium Synchro Summoner
function c249000573.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c249000573.spcon)
	e1:SetCost(c249000573.spcost)
	e1:SetTarget(c249000573.sptg)
	e1:SetOperation(c249000573.spop)
	c:RegisterEffect(e1)
end
function c249000573.confilter(c)
	return c:IsSetCard(0x1D1) and c:GetCode()~=249000573 and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c249000573.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c249000573.confilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil)
end
function c249000573.costfilter(c)
	return c:IsSetCard(0x1D1) and c:IsAbleToRemoveAsCost()
end
function c249000573.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000573.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c249000573.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c249000573.filter(c,e,tp)
	local lv=c:GetLevel()
	return lv > 0 and (not c:IsImmuneToEffect(e)) and (not c:IsType(TYPE_TOKEN))
		and Duel.IsExistingMatchingCard(c249000573.filter2,tp,LOCATION_HAND,0,1,c,e,tp,lv,c:GetRace())
end
function c249000573.filter2(c,e,tp,lv2,race1)
	local lv=c:GetLevel()
	return lv > 0 and lv + lv2 <= 10 and (not c:IsImmuneToEffect(e)) and (not c:IsType(TYPE_TOKEN))
		and Duel.IsExistingMatchingCard(c249000573.filter3,tp,LOCATION_EXTRA,0,1,c,e,tp,lv+lv2,race1,c:GetRace())
end
function c249000573.filter3(c,e,tp,lv,race1,race2)
	return c:GetLevel()==lv  and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and (c:IsRace(race1) or c:IsRace(race2))
end
function c249000573.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c249000573.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c249000573.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c249000573.filter,tp,LOCATION_HAND,0,1,1,c,e,tp)
	if g then
		local g2=Duel.SelectMatchingCard(tp,c249000573.filter2,tp,LOCATION_HAND,0,1,1,Group.FromCards(g:GetFirst(),c),e,tp,g:GetFirst():GetLevel(),g:GetFirst():GetRace())
		if g2 then
			local sc=Duel.SelectMatchingCard(tp,c249000573.filter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,g:GetFirst():GetLevel()+g2:GetFirst():GetLevel(),g:GetFirst():GetRace(),g2:GetFirst():GetRace()):GetFirst()
			if sc then
				g:Merge(g2)
				if Duel.SendtoGrave(g,REASON_EFFECT)~=2 then return end
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EXTRA_TOMAIN_KOISHI)
				e1:SetReset(RESET_CHAIN)
				sc:RegisterEffect(e1)
				Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_FIELD)
				e2:SetCode(EFFECT_CANNOT_ATTACK)
				e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e2:SetTargetRange(LOCATION_MZONE,0)
				e2:SetTarget(c249000573.ftarget)
				e2:SetLabel(sc:GetFieldID())
				e2:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e2,tp)
			end
		end
	end
end
function c249000573.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
