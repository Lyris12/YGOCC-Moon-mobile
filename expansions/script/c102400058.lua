--created & coded by Lyris, art at https://images.homedepot-static.com/productImages/ea33e713-a782-4db2-9bb5-dfd662f36d47/svn/black-hdx-general-purpose-aw64003-64_1000.jpg and from "Degenerate Circuit"
--サイバーダーク・エクステンション・コード
local cid,id=GetID()
function cid.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_SPECIAL_SUMMON)
	e1:SetTarget(cid.cost)
	e1:SetOperation(cid.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetCondition(cid.condition)
	e2:SetTarget(cid.target)
	e2:SetOperation(cid.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function cid.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsSetCard(0x4093)
end
function cid.filter3(c,tp,e)
	return cid.cfilter(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cid.filter2(c)
	return c:IsLevelBelow(3) and c:IsRace(RACE_DRAGON) and not c:IsForbidden()
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		local b=e:GetHandler():IsLocation(LOCATION_HAND)
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cid.filter3,tp,LOCATION_DECK,0,1,nil,tp,e)
		and ((b and ft>1) or (not b and ft>0))
		and Duel.IsExistingTarget(cid.filter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,cid.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	local tg=g:Clone()+e:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,tg,2,0,0)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(cid.filter3,tp,LOCATION_DECK,0,1,nil,tp,e)
	local c=g:GetFirst()
	local tc=Duel.GetFirstTarget()
	if c and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and tc and tc:IsRelateToEffect(e) and tc:IsRace(RACE_DRAGON) and tc:IsLevelBelow(3) and not tc:IsForbidden() then
		local atk=tc:GetTextAttack()
		if atk<0 then atk=0 end
		if not Duel.Equip(tp,tc,c,false) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(cid.eqlimit)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(atk)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_EQUIP)
		e3:SetCode(EFFECT_DESTROY_SUBSTITUTE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetValue(cid.repval)
		tc:RegisterEffect(e3)
	end
end
function cid.eqlimit(e,c)
	return e:GetOwner()==c
end
function cid.repval(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function cid.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cid.cfilter,nil)
	e:SetLabelObject(g:GetFirst())
	return #g==1
end
function cid.filter(c,ec,tp)
	return c:IsRace(RACE_DRAGON) and not c:IsForbidden()
		and (ec:IsType(TYPE_FUSION) or Duel.IsExistingTarget(cid.filter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,c))
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ec=e:GetLabelObject()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and cid.filter(chkc,ec,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(cid.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,ec,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,cid.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,ec,tp)
	if not c:IsType(TYPE_FUSION) then
		local tc=g:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		g=Duel.SelectTarget(tp,cid.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,tc,ec,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e):Filter(Card.IsRace,nil,RACE_DRAGON):Filter(aux.NOT(Card.IsForbidden),nil)
	for ec in aux.Next(tg) do
		if #tg==1 then break end
		tg:RemoveCard(ec)
	end
	local c=e:GetLabelObject()
	if not c:IsType(TYPE_FUSION) then tg=tg:Filter(Card.IsLevelBelow,nil,3) end
	for i=1,Duel.GetCurrentChain() do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		if te:GetHandler()==c and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
			Duel.ChangeTargetCard(i,tg)
			return
		end
	end
	local tc=tg:GetFirst()
	if c:IsFaceup() and tc then
		local atk=tc:GetTextAttack()
		if atk<0 then atk=0 end
		if not Duel.Equip(tp,tc,c,false) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(cid.eqlimit)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(atk)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_EQUIP)
		e3:SetCode(EFFECT_DESTROY_SUBSTITUTE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetValue(cid.repval)
		tc:RegisterEffect(e3)
	end
end
