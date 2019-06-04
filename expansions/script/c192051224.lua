function c192051224.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c192051224.target)
	e1:SetOperation(c192051224.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(192051224,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCountLimit(1)
	e6:SetCost(c192051224.cost)
	e6:SetOperation(c192051224.spop)
	c:RegisterEffect(e6)
	local sg=Group.CreateGroup()
	sg:KeepAlive()
	e6:SetLabelObject(sg)
	--leave field
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c192051224.spcon)
	e2:SetTarget(c192051224.sptg)
	e2:SetOperation(c192051224.spop1)
	e2:SetLabelObject(sg)
	c:RegisterEffect(e2)
end
function c192051224.filter(c)
	return c:IsSetCard(0x617)
end
function c192051224.filter2(c)
	return c:IsSetCard(0x617) and c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK--[[+TYPE_EVOLUTE]])
end
function c192051224.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then local ct=Duel.GetMatchingGroupCount(c192051224.filter2,tp,LOCATION_GRAVE,0,nil)
		local enough=math.floor(ct/2)>0
		if enough then
			return Duel.IsExistingMatchingCard(c192051224.filter,tp,LOCATION_REMOVED,0,2,nil)
		else
			return (Duel.IsExistingMatchingCard(c192051224.filter,tp,LOCATION_REMOVED,0,1,nil)
				and Duel.IsExistingMatchingCard(c192051224.filter2,tp,LOCATION_GRAVE,0,1,nil))
				or Duel.IsExistingMatchingCard(c192051224.filter2,tp,LOCATION_REMOVED,0,2,nil)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,0,0)
end
function c192051224.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(c192051224.filter2,tp,LOCATION_GRAVE,0,nil)
	if not c:IsRelateToEffect(e) then return end
	local total=ct+Duel.GetMatchingGroupCount(c192051224.filter2,tp,LOCATION_REMOVED,0,nil)
	if math.floor(ct/2)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(504,0))
		sg=Duel.SelectMatchingCard(tp,c192051224.filter,tp,LOCATION_REMOVED,0,2,2,nil)
	elseif total>=2 then
		local gt=ct
		local g=Duel.GetMatchingGroup(c192051224.filter2,tp,LOCATION_REMOVED,0,nil)
		sg=Group.CreateGroup()
		while gt<2 do
			sc=g:Select(tp,1,1,sg)
			sg:AddCard(sc:GetFirst())
			g:RemoveCard(sc:GetFirst())
			gt=gt+1
		end
		while sg:GetCount()<2 do
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(504,0))
			sc=Duel.SelectMatchingCard(tp,c192051224.filter,tp,LOCATION_REMOVED,0,1,1,sg)
			sg:AddCard(sc:GetFirst())
		end
	else
		if Duel.GetMatchingGroupCount(c192051224.filter,tp,LOCATION_REMOVED,0,nil)>=2 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(504,0))
			sg=Duel.SelectMatchingCard(tp,c192051224.filter,tp,LOCATION_REMOVED,0,2,2,nil)
		else return false
		end
	end
	if sg and sg:GetCount()>0 then
		if Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)==2 then
			local g=Duel.GetMatchingGroup(c192051224.filter2,tp,LOCATION_GRAVE,0,nil)
			local ct=math.floor(g:GetCount()/2)
			if ct<1 then return end
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(507,0))
			local sg=Duel.SelectMatchingCard(tp,c192051224.filter2,tp,LOCATION_GRAVE,0,ct,ct,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
		end
	end
end
function c192051224.c1(c)
	return c:IsSetCard(0x617) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c192051224.ban(c)
	return c:IsSetCard(0x617) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and not (c:GetLevel()==3)
end
function c192051224.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c192051224.c1,tp,LOCATION_GRAVE,0,4,nil)
		and Duel.IsExistingMatchingCard(c192051224.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local ct=Duel.GetMatchingGroupCount(c192051224.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if ct>3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c192051224.c1,tp,LOCATION_GRAVE,0,3,3,nil)
	else
		g=Group.CreateGroup()
		while (g:GetCount()+ct)<=3 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local cg=Duel.SelectMatchingCard(tp,c192051224.ban,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
			g:AddCard(cg)
		end
		if g:GetCount()<3 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=Duel.SelectMatchingCard(tp,c192051224.c1,tp,LOCATION_GRAVE,0,3-g:GetCount(),3-g:GetCount(),g)
			g:Merge(sg)
		end
	end
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
		if Duel.Remove(tc,POS_FACEUP,REASON_COST)~=0 and tc:IsLocation(LOCATION_REMOVED) then
			if c:IsRelateToEffect(e) then
				local sg=e:GetLabelObject()
				if c:GetFlagEffect(192051224)==0 then
					sg:Clear()
					c:RegisterFlagEffect(192051224,RESET_EVENT+0x1680000,0,1)
				end
				sg:AddCard(tc)
				tc:CreateRelation(c,RESET_EVENT+0x1fe0000)
			end
		end
		tc=g:GetNext()
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c192051224.spfilter(c,e,tp)
	return c:IsSetCard(0x617) and c:GetLevel()==3 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c192051224.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c192051224.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g and g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c192051224.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():GetFlagEffect(192051224)~=0
end
function c192051224.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c192051224.spfilter1(c,rc,e,tp)
	return c:IsRelateToCard(rc)
end
function c192051224.spop1(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c192051224.spfilter1,nil,e:GetHandler(),e,tp)
	if tg:GetCount()<3 then return end
	if tg:GetCount()>3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=tg:Select(tp,3,3,nil)
	end
	Duel.SendtoGrave(tg,REASON_EFFECT+REASON_RETURN)
end
