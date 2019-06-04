--Angelic Summoner of Twilight
function c249000688.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x1E5),1)
	aux.EnablePendulumAttribute(c,false)
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x1E5),3,true)
	--fusion summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27346636,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(SUMMON_TYPE_FUSION)
	e1:SetCondition(c249000688.sprcon)
	e1:SetOperation(c249000688.sprop)
	c:RegisterEffect(e1)
	--move
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(92204263,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,2490006881)
	e2:SetTarget(c249000688.seqtg)
	e2:SetOperation(c249000688.seqop)
	c:RegisterEffect(e2)
	--special summon other
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(31786629,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,2490006882)
	e3:SetCondition(c249000688.condition)
	e3:SetCost(c249000688.cost)
	e3:SetTarget(c249000688.target)
	e3:SetOperation(c249000688.operation)
	c:RegisterEffect(e3)
	--pendulum zone draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(16178681,1))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1,2490006883)
	e4:SetTarget(c249000688.drtg2)
	e4:SetOperation(c249000688.drop2)
	c:RegisterEffect(e4)
end
function c249000688.cfilter(c)
	return c:IsFusionSetCard(0x1E5) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeFusionMaterial() and c:IsReleasable()
end
function c249000688.fcheck(c,sg)
	return c:IsFusionSetCard(0x1E5) and c:IsType(TYPE_MONSTER) and sg:IsExists(c249000688.fcheck2,2,c)
end
function c249000688.fcheck2(c)
	return c:IsFusionSetCard(0x1E5) and c:IsType(TYPE_MONSTER)
end
function c249000688.fselect(c,tp,mg,sg)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()<3 then
		res=mg:IsExists(c249000688.fselect,1,sg,tp,mg,sg)
	elseif Duel.GetLocationCountFromEx(tp,tp,sg)>0 then
		res=sg:IsExists(c249000688.fcheck,1,nil,sg)
	end
	sg:RemoveCard(c)
	return res
end
function c249000688.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c249000688.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	local sg=Group.CreateGroup()
	return mg:IsExists(c249000688.fselect,1,nil,tp,mg,sg)
end
function c249000688.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c249000688.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	local sg=Group.CreateGroup()
	while sg:GetCount()<3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=mg:FilterSelect(tp,c249000688.fselect,1,1,sg,tp,mg,sg)
		sg:Merge(g)
	end
	local cg=sg:Filter(Card.IsFacedown,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c249000688.spfilter(c)
	return c:IsSetCard(0x1E5) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c249000688.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c249000688.ctfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_EXTRA+LOCATION_REMOVED,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>3
end
function c249000688.rmfilter(c)
	return c:IsSetCard(0x1E5) and c:IsAbleToRemoveAsCost() and ((not c:IsLocation(LOCATION_EXTRA)) or (c:IsFaceup() and c:IsLocation(LOCATION_EXTRA)))
end
function c249000688.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000688.rmfilter,tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) end
	local sg=Duel.SelectMatchingCard(tp,c249000688.rmfilter,tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c249000688.tfilter(c,att,e,tp,lvrk)
	return c:IsAttribute(att) and
	((c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and (c:GetLevel() > lvrk) and (c:GetLevel() <= lvrk+3) and (c:GetLevel() <= 10))
	or (c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and (c:GetRank() > lvrk) and (c:GetRank() <= lvrk+3) and (c:GetLevel() <= 10)))
end
function c249000688.filter(c,e,tp)
	local lvrk
	if c:GetLevel() > c:GetRank() then lvrk = c:GetLevel() else lvrk = c:GetRank() end
	return lvrk > 0 and c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,c)>0 and Duel.IsExistingMatchingCard(c249000688.tfilter,tp,LOCATION_EXTRA,0,1,nil,c:GetAttribute(),e,tp,lvrk)
end
function c249000688.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler() 
	if chk==0 then return Duel.IsExistingMatchingCard(c249000688.filter,tp,LOCATION_MZONE,0,1,c,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c249000688.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.SelectMatchingCard(tp,c249000688.filter,tp,LOCATION_MZONE,0,1,1,c,e,tp):GetFirst()
	if not tc then return end
	local att=tc:GetAttribute()
	local lvrk
	if tc:GetLevel() > tc:GetRank() then lvrk = tc:GetLevel() else lvrk = tc:GetRank() end
	if Duel.SendtoGrave(tc,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c249000688.tfilter,tp,LOCATION_EXTRA,0,1,1,nil,att,e,tp,lvrk):GetFirst()
	if not sc then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c249000688.damval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if sc:IsType(TYPE_XYZ) then
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	else
		sc:SetMaterial(Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()	
	end
end
function c249000688.damval(e,re,val,r,rp,rc)
	return val/2
end
function c249000688.drtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable()
		and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c249000688.drop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c249000688.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c249000688.seqfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 end
end
function c249000688.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsControler(1-tp) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(c,nseq)
end
